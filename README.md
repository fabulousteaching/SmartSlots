# SmartSlots

**Termine effizient organisieren:** SmartSlots sammelt die Antworten einer Terminumfrage und verteilt die Gespräche. Die Antworten kommen entweder aus einer eigenen Umfrage (Link an die Eltern, mit Konto) oder aus einer CSV- oder Excel-Datei (z. B. aus Nuudel, Rallly, Doodle, Framadate, Microsoft Forms oder Google Forms, auch ohne Konto).

- alle Familien bekommen einen Termin, wenn das irgendwie geht
- an möglichst wenigen Tagen und ohne Leerzeiten
- wer keinen Termin bekommen kann, steht mit Grund in einer Liste
- Familien lassen sich zu einem gemeinsamen Termin zusammenfassen
- anspruchsvolle Gespräche folgen nach Möglichkeit nicht direkt aufeinander
- sind alle eingeteilt, gibt es für jede Familie eine fertige Nachricht mit Datum, Zeit und Ort (per Sie oder Du), zum Herunterladen oder Kopieren

Bei einer eigenen Umfrage erscheint jede neue Antwort automatisch, und die Verteilung passt sich an.

**Wochenplan (Stundenplan):** Für wiederkehrende Lektionen, z. B. Logopädie oder andere Förderlektionen. Die Planende legt Wochentage und Lektionen fest und sperrt, was ihr nicht passt. Die Lehrpersonen geben über den Link an, welche Lektionen passen (passt / wenn's sein muss / passt nicht) und wie viele ihre Klasse braucht. SmartSlots erstellt daraus den Plan; Lektionen verschiedener Klassen lassen sich per Drag & Drop zusammenlegen.

Mit Konto (Supabase) werden die SmartSlots gespeichert, sodass man jederzeit weiterarbeiten kann. Ohne Konto wird nichts gespeichert.

**Online:** https://www.smartslots.ch

## Aufbau

| Datei | Inhalt |
| --- | --- |
| `index.html` | die ganze Anwendung (läuft im Browser, ohne eigenen Server) |
| `umfrage.html` | die Seite, auf der die Eltern antworten (über den Link aus einer eigenen Umfrage) |
| `smartslot-config.js` | Adresse und öffentlicher Schlüssel des Supabase-Projekts |
| `supabase/smartslot.sql` | Tabelle und Zugriffsregeln für Supabase |
| `supabase/ANLEITUNG.md` | Einrichtung Schritt für Schritt |
| `bilder/` | Logo und Symbole |
