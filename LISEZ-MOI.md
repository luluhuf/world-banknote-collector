# World Banknote Collector V3 — BÊTA (21 novembre 2026)

## Inclus
- Écran de connexion par e-mail Supabase, sans nouvelle inscription.
- Scan recto-verso ; OCR libre côté navigateur (Internet requis au premier chargement).
- Collection filtrable : tous / actuels / anciens / à vérifier.
- Enregistrement local des nouveaux billets dans une file d'attente et tentative de synchronisation Supabase (métadonnées + deux photos privées).
- Suppression des billets synchronisés, synchronisation manuelle, liens de partage révocables.
- Lecture seule des liens seulement **après déploiement** de la fonction `public-collection`.

## NON GARANTI / RESTANT À TESTER
- Reconnaissance de *tous* les billets du monde : impossible avec l'OCR + mini-catalogue actuel. Les fiches historiques ne couvrent que 5 et 10 lei roumains. Ne pas promettre plus.
- Aucun test réel n'a été exécuté sur le compte Supabase ni sur Safari iPhone ; ce paquet a fait l'objet de vérifications locales de syntaxe et de cohérence.
- L'ancien contenu stocké sous `wbc_scanned_notes_v1` n'est pas migré automatiquement. Ne videz pas les données Safari et ne supprimez pas l'ancienne PWA avant une migration contrôlée.
- La consultation hors ligne complète n'est pas garantie, notamment après la fermeture de Safari. Une synchronisation réussie et une sauvegarde exportable restent nécessaires avant utilisation sérieuse.
- Ne publiez pas V3 à la racine du dépôt GitHub avant d'avoir testé la connexion et le partage.

## Sécurité
Seule la clé `sb_publishable_` est dans `app.js`, ce qui est normal. Aucune clé `secret` / `service_role` ne doit être mise dans GitHub Pages.
RLS doit rester activée. Le bucket `banknote-photos` doit rester **privé** avec les politiques `INSERT`, `SELECT`, `DELETE` limitées à `auth.uid()` et au dossier UID.
La fonction `public-collection` doit être déployée séparément **dans Supabase** (Edge Functions), sans vérification JWT à l'entrée, puisque les visiteurs ne sont pas connectés. Elle vérifie le jeton de partage fort côté serveur et produit des URL signées de 10 minutes. Le jeton est un mot de passe de lecture : quiconque l'obtient pourra consulter la collection avant révocation. Pas de garantie contre captures d'écran / copies de fichiers.

## Installation sûre (iPhone)
1. Continuer à utiliser V2 ; ne PAS remplacer ses fichiers tout de suite.
2. Dans Supabase > SQL Editor, exécuter `permissions-api.sql` une seule fois pour permettre au compte authentifié d’utiliser les tables sous RLS.
3. Dans Supabase > Edge Functions, créer `public-collection`, coller `edge-function/index.ts`, et déployer via le Dashboard. La fonction doit être accessible sans vérification JWT (désactiver `Verify JWT`). Le secret serveur Supabase doit être disponible via les secrets d'environnement du projet. Ne jamais le copier dans le client.
4. Tester le partage avec un vrai lien et avec un faux lien, tester révocation, vérifier que l'ami ne peut pas éditer.
5. Publier les 4 fichiers `index.html`, `app.js`, `sw.js`, `manifest.webmanifest` (les icônes actuelles restent en place) dans un dépôt **de test** séparé ou sur une branche d'essai avec hébergement Pages correspondant ; le `start_url` de la PWA est relatif.
6. Se connecter avec le compte Supabase déjà créé, scanner un billet, vérifier tables `banknotes`, `banknote_photos`, Storage, puis tester partage en navigation privée.
7. Après validation, remplacer la V2 en conservant une copie des photos/notes existantes. La V3 bêta ne migre pas automatiquement les billets V2.

## Évolutions
Pour un partage en continu pendant la consultation, actualiser périodiquement la page : la fonction renvoie la dernière collection à chaque visite/actualisation. Un abonnement temps réel n'est pas encore implémenté.
