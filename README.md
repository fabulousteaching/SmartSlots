# SmartSlot

**Termine effizient organisieren:** SmartSlot liest die Antworten einer Terminumfrage (CSV oder Excel, z. B. aus Nuudel, Rallly, Doodle, Framadate, Microsoft Forms oder Google Forms) und verteilt die Gespräche:

- alle Familien bekommen einen Termin, wenn das irgendwie geht
- an möglichst wenigen Tagen und ohne Leerzeiten
- wer keinen Termin bekommen kann, steht mit Grund in einer Liste
- Familien lassen sich zu einem gemeinsamen Termin zusammenfassen
- anspruchsvolle Gespräche folgen nach Möglichkeit nicht direkt aufeinander

Mit Konto (Supabase) werden die SmartSlots gespeichert, sodass man jederzeit weiterarbeiten kann. Ohne Konto wird nichts gespeichert.

**Online:** https://fabulousteaching.github.io/SmartSlot/

## Aufbau

| Datei | Inhalt |
| --- | --- |
| `index.html` | die ganze Anwendung (läuft im Browser, ohne eigenen Server) |
| `smartslot-config.js` | Adresse und öffentlicher Schlüssel des Supabase-Projekts |
| `supabase/smartslot.sql` | Tabelle und Zugriffsregeln für Supabase |
| `supabase/ANLEITUNG.md` | Einrichtung Schritt für Schritt |
| `bilder/` | Logo und Symbole |
