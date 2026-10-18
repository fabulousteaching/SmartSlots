-- SmartSlot: Tabelle und Zugriffsregeln für gespeicherte SmartSlots
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
-- So merkt SmartSlot, wenn ein anderes Fenster inzwischen gespeichert hat, und überschreibt nichts.
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
