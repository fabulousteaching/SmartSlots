/* SmartSlot: Verbindung zu Supabase (Anmeldung und gespeicherte SmartSlots)

   Beide Werte stehen in Supabase beim Projekt unter «Connect» oder «Project Settings → API Keys».
   Sie dürfen öffentlich sein: Die Daten schützen die Zugriffsregeln aus supabase/smartslot.sql,
   dort sieht jede Person nur ihre eigenen SmartSlots.
   Den «secret» bzw. «service_role» Schlüssel nie hier eintragen.

   Bleiben die Werte leer, läuft SmartSlot ohne Anmeldung, und nichts wird gespeichert. */
window.SMARTSLOT_CONFIG = {
  supabaseUrl: 'https://faztcphptdvrowlmywwm.supabase.co',
  supabaseKey: 'sb_publishable_txR6Br_GygbWsZD17txzVQ_iQtdC6OC'   // «Publishable key», darf öffentlich sein
};
