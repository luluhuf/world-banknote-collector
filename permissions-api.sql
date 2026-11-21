-- V3: autoriser les clients connectés à utiliser les tables sous le contrôle RLS.
-- Les règles RLS existantes (owner_id = auth.uid()) restent obligatoires.
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.banknotes TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.banknote_photos TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.collection_shares TO authenticated;
-- Aucun droit accordé au rôle anonyme sur ces tables.
REVOKE ALL ON TABLE public.banknotes, public.banknote_photos, public.collection_shares FROM anon;
