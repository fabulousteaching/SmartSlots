-- SmartSlots: Tabelle und Zugriffsregeln für gespeicherte SmartSlots
-- In Supabase unter «SQL Editor» einfügen und auf «Run» klicken. Mehrmals ausführen schadet nicht.

create table if not exists public.smartslots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  data jsonb not null default '{}'::jsonb check (octet_length(data::text) <= 2000000),
  version integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists smartslots_user_updated on public.smartslots (user_id, updated_at desc);

-- Nur angemeldete Personen, und jede nur mit ihren eigenen Zeilen
alter table public.smartslots enable row level security;
revoke all on public.smartslots from anon;
grant select, insert, update, delete on public.smartslots to authenticated;

drop policy if exists "smartslots lesen" on public.smartslots;
drop policy if exists "smartslots erstellen" on public.smartslots;
drop policy if exists "smartslots ändern" on public.smartslots;
drop policy if exists "smartslots löschen" on public.smartslots;
create policy "smartslots lesen" on public.smartslots for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "smartslots erstellen" on public.smartslots for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "smartslots ändern" on public.smartslots for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "smartslots löschen" on public.smartslots for delete to authenticated
  using ((select auth.uid()) = user_id);

-- Bei jeder Änderung: Zeit festhalten; ändern sich die Daten, zählt «version» hoch.
-- So merkt SmartSlots, wenn ein anderes Fenster inzwischen gespeichert hat, und überschreibt nichts.
create or replace function public.smartslots_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  new.user_id := old.user_id;
  new.created_at := old.created_at;
  if new.data is distinct from old.data then
    new.version := old.version + 1;
  else
    new.version := old.version;
  end if;
  return new;
end;
$$;

drop trigger if exists smartslots_touch on public.smartslots;
create trigger smartslots_touch before update on public.smartslots
  for each row execute function public.smartslots_touch();

-- ---------------------------------------------------------------------------
-- Eigene Terminumfragen: Die Lehrperson erstellt eine Umfrage zu einem SmartSlot,
-- die Eltern antworten über einen Link ohne Konto.
-- Eltern sehen nur die Umfrage und ihre eigene Antwort, nie die anderer Familien.

create table if not exists public.polls (
  id uuid primary key default gen_random_uuid(),
  smartslot_id uuid not null unique references public.smartslots (id) on delete cascade,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  token text not null unique default replace(gen_random_uuid()::text, '-', ''),
  title text not null default '' check (char_length(title) <= 200),
  intro text not null default '' check (char_length(intro) <= 2000),
  slots jsonb not null default '[]'::jsonb check (jsonb_typeof(slots) = 'array' and jsonb_array_length(slots) <= 300),
  allow_maybe boolean not null default true,
  open boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.poll_responses (
  id uuid primary key default gen_random_uuid(),
  poll_id uuid not null references public.polls (id) on delete cascade,
  edit_token uuid not null default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  answers jsonb not null default '{}'::jsonb check (jsonb_typeof(answers) = 'object'),
  comment text not null default '' check (char_length(comment) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists poll_responses_poll on public.poll_responses (poll_id, created_at);

alter table public.polls enable row level security;
alter table public.poll_responses enable row level security;
revoke all on public.polls from anon, authenticated;
revoke all on public.poll_responses from anon, authenticated;
grant select, insert, update, delete on public.polls to authenticated;
-- Die Lehrperson liest die Antworten (ohne den Schlüssel, mit dem Eltern ihre Antwort ändern) und kann sie löschen
grant select (id, poll_id, name, answers, comment, created_at, updated_at) on public.poll_responses to authenticated;
grant delete on public.poll_responses to authenticated;
-- Den Namen darf die Lehrperson anpassen (die Eltern sehen dann den neuen Namen), sonst nichts
grant update (name) on public.poll_responses to authenticated;

drop policy if exists "polls lesen" on public.polls;
drop policy if exists "polls erstellen" on public.polls;
drop policy if exists "polls ändern" on public.polls;
drop policy if exists "polls löschen" on public.polls;
create policy "polls lesen" on public.polls for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "polls erstellen" on public.polls for insert to authenticated
  with check ((select auth.uid()) = user_id
    and exists (select 1 from public.smartslots s where s.id = smartslot_id and s.user_id = (select auth.uid())));
create policy "polls ändern" on public.polls for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "polls löschen" on public.polls for delete to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "antworten lesen" on public.poll_responses;
drop policy if exists "antworten löschen" on public.poll_responses;
drop policy if exists "antworten ändern" on public.poll_responses;
create policy "antworten lesen" on public.poll_responses for select to authenticated
  using (exists (select 1 from public.polls p where p.id = poll_id and p.user_id = (select auth.uid())));
create policy "antworten löschen" on public.poll_responses for delete to authenticated
  using (exists (select 1 from public.polls p where p.id = poll_id and p.user_id = (select auth.uid())));
create policy "antworten ändern" on public.poll_responses for update to authenticated
  using (exists (select 1 from public.polls p where p.id = poll_id and p.user_id = (select auth.uid())))
  with check (exists (select 1 from public.polls p where p.id = poll_id and p.user_id = (select auth.uid())));

-- Bei jeder Änderung einer Antwort die Zeit festhalten
create or replace function public.poll_responses_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end;
$$;
drop trigger if exists poll_responses_touch on public.poll_responses;
create trigger poll_responses_touch before update on public.poll_responses
  for each row execute function public.poll_responses_touch();

create or replace function public.polls_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  new.user_id := old.user_id;
  new.smartslot_id := old.smartslot_id;
  new.token := old.token;
  new.created_at := old.created_at;
  return new;
end;
$$;
drop trigger if exists polls_touch on public.polls;
create trigger polls_touch before update on public.polls
  for each row execute function public.polls_touch();

-- Für die Eltern: Umfrage lesen (nur mit dem Link)
create or replace function public.poll_get(p_token text) returns jsonb
language sql stable security definer set search_path = '' as $$
  select jsonb_build_object('title', p.title, 'intro', p.intro, 'slots', p.slots, 'allow_maybe', p.allow_maybe, 'open', p.open)
  from public.polls p where p.token = p_token;
$$;

-- Für die Eltern: antworten, oder mit p_id und p_edit die eigene Antwort ändern
create or replace function public.poll_answer(p_token text, p_name text, p_answers jsonb,
  p_comment text default '', p_id uuid default null, p_edit uuid default null) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare
  v_poll public.polls;
  v_row public.poll_responses;
  v_ans jsonb := '{}'::jsonb;
  v_slot jsonb;
  v_key text;
  v_val int;
  v_name text := btrim(coalesce(p_name, ''));
begin
  select * into v_poll from public.polls where token = p_token;
  if not found then raise exception 'poll_not_found'; end if;
  if not v_poll.open then raise exception 'poll_closed'; end if;
  if char_length(v_name) < 1 or char_length(v_name) > 120 then raise exception 'bad_name'; end if;
  if p_answers is null or jsonb_typeof(p_answers) <> 'object' then raise exception 'bad_answer'; end if;
  -- nur Termine dieser Umfrage, nur 0 (nein), 1 (wenn nötig), 2 (ja)
  for v_slot in select value from jsonb_array_elements(v_poll.slots) loop
    v_key := v_slot ->> 'id';
    if v_key is not null and p_answers ? v_key then
      if jsonb_typeof(p_answers -> v_key) <> 'number' then raise exception 'bad_answer'; end if;
      v_val := (p_answers ->> v_key)::numeric::int;
      if v_val not in (0, 1, 2) then raise exception 'bad_answer'; end if;
      if v_val = 1 and not v_poll.allow_maybe then v_val := 0; end if;
      v_ans := v_ans || jsonb_build_object(v_key, v_val);
    end if;
  end loop;
  if p_id is not null then
    update public.poll_responses
      set name = v_name, answers = v_ans, comment = left(coalesce(p_comment, ''), 1000), updated_at = now()
      where id = p_id and poll_id = v_poll.id and edit_token = p_edit
      returning * into v_row;
    if not found then raise exception 'not_found'; end if;
  else
    if (select count(*) from public.poll_responses where poll_id = v_poll.id) >= 1000 then raise exception 'too_many'; end if;
    insert into public.poll_responses (poll_id, name, answers, comment)
      values (v_poll.id, v_name, v_ans, left(coalesce(p_comment, ''), 1000))
      returning * into v_row;
  end if;
  return jsonb_build_object('id', v_row.id, 'edit', v_row.edit_token);
end;
$$;

-- Für die Eltern: die eigene Antwort wieder laden, um sie zu ändern
create or replace function public.poll_mine(p_token text, p_id uuid, p_edit uuid) returns jsonb
language sql stable security definer set search_path = '' as $$
  select jsonb_build_object('name', r.name, 'answers', r.answers, 'comment', r.comment)
  from public.poll_responses r join public.polls p on p.id = r.poll_id
  where p.token = p_token and r.id = p_id and r.edit_token = p_edit;
$$;

revoke all on function public.poll_get(text) from public;
revoke all on function public.poll_answer(text, text, jsonb, text, uuid, uuid) from public;
revoke all on function public.poll_mine(text, uuid, uuid) from public;
grant execute on function public.poll_get(text) to anon, authenticated;
grant execute on function public.poll_answer(text, text, jsonb, text, uuid, uuid) to anon, authenticated;
grant execute on function public.poll_mine(text, uuid, uuid) to anon, authenticated;

-- Supabase sofort über die neuen Tabellen und Funktionen informieren
notify pgrst, 'reload schema';
