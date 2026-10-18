# SmartSlots

**Termine effizient organisieren:** SmartSlots sammelt die Antworten einer Terminumfrage und verteilt die Gespräche. Die Antworten kommen entweder aus einer eigenen Umfrage (Link an die Eltern, mit Konto) oder aus einer CSV- oder Excel-Datei (z. B. aus Nuudel, Rallly, Doodle, Framadate, Microsoft Forms oder Google Forms, auch ohne Konto).

- alle Familien bekommen einen Termin, wenn das irgendwie geht
- an möglichst wenigen Tagen und ohne Leerzeiten
- wer keinen Termin bekommen kann, steht mit Grund in einer Liste
- Familien lassen sich zu einem gemeinsamen Termin zusammenfassen
- anspruchsvolle Gespräche folgen nach Möglichkeit nicht direkt aufeinander

Bei einer eigenen Umfrage erscheint jede neue Antwort automatisch, und die Verteilung passt sich an.

Mit Konto (Supabase) werden die SmartSlots gespeichert, sodass man jederzeit weiterarbeiten kann. Ohne Konto wird nichts gespeichert.

**Online:** https://fabulousteaching.github.io/SmartSlots/

## Aufbau

| Datei | Inhalt |
| --- | --- |
| `index.html` | die ganze Anwendung (läuft im Browser, ohne eigenen Server) |
| `umfrage.html` | die Seite, auf der die Eltern antworten (über den Link aus einer eigenen Umfrage) |
| `smartslot-config.js` | Adresse und öffentlicher Schlüssel des Supabase-Projekts |
| `supabase/smartslot.sql` | Tabelle und Zugriffsregeln für Supabase |
| `supabase/ANLEITUNG.md` | Einrichtung Schritt für Schritt |
| `bilder/` | Logo und Symbole |
