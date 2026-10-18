# SmartSlots mit Anmeldung einrichten

SmartSlots speichert deine Umfragen und Verteilungen bei [Supabase](https://supabase.com) (Datenbank und Anmeldung, gratis für kleine Projekte).
Solange in `smartslot-config.js` nichts eingetragen ist, läuft SmartSlots ohne Anmeldung.

Die Menünamen in Supabase ändern sich ab und zu leicht. Die Wege unten stimmen sinngemäss.

## 1. Projekt erstellen

1. Auf supabase.com ein Konto erstellen und **New project** wählen.
2. Name z. B. `smartslot`. **Region in Europa** wählen (z. B. Frankfurt).
3. Das Datenbank-Passwort gut aufbewahren (SmartSlots braucht es nicht, aber Supabase fragt manchmal danach).

## 2. Tabelle anlegen

1. Links **SQL Editor** öffnen, **New query**.
2. Den ganzen Inhalt von `supabase/smartslot.sql` einfügen und **Run** klicken.
3. Es erscheint «Success. No rows returned». Mehrmals ausführen schadet nicht.

Das SQL legt die Tabelle `smartslots` an und sorgt dafür, dass jede Person nur ihre eigenen SmartSlots sieht.

## 3. Adresse der Seite eintragen

**Authentication → URL Configuration**

- **Site URL:** `https://fabulousteaching.github.io/SmartSlots/`
- **Redirect URLs:** `https://fabulousteaching.github.io/SmartSlots/**` hinzufügen.

Dorthin führen die Links in den E-Mails (Konto bestätigen, Passwort vergessen).

## 4. E-Mails

Der eingebaute E-Mail-Versand von Supabase ist nur zum Testen da: Er schickt nur an Mitglieder des eigenen Supabase-Teams und nur etwa 2 E-Mails pro Stunde. Damit sich andere Personen selbst ein Konto erstellen können, gibt es zwei Wege:

**Schnell:** Unter **Authentication → Sign In / Providers → Email** die Option **Confirm email** ausschalten.
Neue Konten sind dann sofort aktiv, ohne Bestätigungs-E-Mail. Nachteil: «Passwort vergessen» funktioniert so nur für Mitglieder des Supabase-Teams.

**Richtig:** Einen eigenen E-Mail-Versand (SMTP) eintragen, in den E-Mail-Einstellungen unter **Authentication** (SMTP Settings).
Zum Beispiel mit Brevo (gratis bis 300 E-Mails pro Tag) oder mit dem Postausgang der Schule.
Danach unter **Authentication → Rate Limits** die Zahl der E-Mails pro Stunde nach Bedarf erhöhen.

Ebenfalls unter **Authentication → Sign In / Providers → Email** empfohlen:

- **Minimum password length:** 8 (SmartSlots verlangt das auch).

Die Texte der E-Mails lassen sich unter **Authentication → Emails** auf Deutsch übersetzen.

## 5. Schlüssel in SmartSlots eintragen

Beim Projekt auf **Connect** klicken (oder **Project Settings → API Keys**) und zwei Werte kopieren:

- die **Project URL** (`https://….supabase.co`)
- den **Publishable key** (`sb_publishable_…`) oder den älteren **anon public** Schlüssel

Beide in `smartslot-config.js` eintragen. Diese beiden Werte dürfen öffentlich sein.
Den **secret** bzw. **service_role** Schlüssel nie eintragen und nie weitergeben.

## 6. Online stellen

Auf GitHub beim Repository **Settings → Pages** öffnen, bei **Source** «Deploy from a branch» wählen, dann **main** und **/ (root)**, und speichern.
Nach ein bis zwei Minuten läuft SmartSlots unter `https://fabulousteaching.github.io/SmartSlots/`.
Nach einer Änderung kann es ein paar Minuten dauern, bis GitHub Pages die neue Version zeigt.

Vorschau-Adressen wie raw.githack.com nur zum Ausprobieren verwenden: Dort teilen sich viele fremde Seiten dieselbe Adresse, und die Anmeldung wäre weniger geschützt.

## Gut zu wissen

- **Pause bei Gratis-Projekten:** Supabase pausiert Gratis-Projekte nach etwa 7 Tagen ohne Nutzung. Die Daten bleiben erhalten. Beim Projekt in Supabase **Restore** klicken, dann geht es nach ein paar Minuten weiter. Während der Pause meldet SmartSlots «Keine Verbindung zum Server». Am besten vor den Elterngesprächen kurz prüfen. Bezahlte Projekte werden nicht pausiert.
- **Datenschutz:** In den SmartSlots stehen Namen von Familien und ihre Antworten. Viele Schulen haben Regeln, wo solche Daten liegen dürfen. Im Zweifel bei der Schulleitung nachfragen.
- **Ohne Konto ausprobieren** bleibt möglich. Dann wird nichts gespeichert.
- **Abmelden** meldet nur diesen Browser ab.
