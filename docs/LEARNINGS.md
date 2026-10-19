# Journal d'apprentissage

Format : une entrée par date, courte. Ajouter en haut. Piège évité ou concept compris, pas de roman.

## 2026-10-19
- LLM changé : DeepSeek à la place de Claude Haiku (appel HTTP Request `POST https://api.deepseek.com/chat/completions`, format compatible OpenAI). Clé uniquement dans une credential n8n. Les tokens se lisent dans `usage.total_tokens` de la réponse, ce qui servira à W5.
- Dans W1, l'appel LLM est un nœud HTTP, pas un workflow séparé : `Digest → IF (écart ≥ 3 %) → Analyste → Assemble → Telegram`, la branche « calme » va direct à Telegram sans token.
- Piège : message Telegram vide quand Telegram était branché juste après le HTTP, car la réponse DeepSeek n'a pas de champ `text` ; le nœud `Assemble` (Code) recolle le tableau et le commentaire.
- Piège : le champ JSON du corps HTTP doit être en mode Expression, sinon `{{ ... }}` est envoyé tel quel.

- W5 : suivi des tokens fait dans W1 (nœud Code `Suivi tokens` + IF + Telegram), cumul mensuel dans `$getWorkflowStaticData('global')`, remis à zéro au changement de mois, alerte une seule fois. Piège : les static data ne sont enregistrées que par les exécutions planifiées, pas par les lancements manuels ; pour tester, baisser temporairement le seuil.

## 2026-10-18
- W1 construit : `Tickers` (Code) → `HTTP Request` (batch 1 par 500 ms, retry 2) → `Variations` (Code) → `Digest` (Code) → Telegram. Cron `30 22 * * 0-5` : `0` = dimanche, le week-end la bourse est fermée donc le digest reprend la dernière clôture (vendredi). Pas de LLM dans W1 : le calcul et le classement sont du code, donc zéro token.
- Source de cours : Stooq écarté (page de vérification anti-robot en JavaScript, inutilisable depuis un nœud HTTP). Yahoo `query1.finance.yahoo.com/v8/finance/chart/<TICKER>?range=3mo&interval=1d` répond en JSON (timestamps + clôtures), avec un User-Agent navigateur ; endpoint non officiel donc fragile. 65 points sur 3 mois, assez pour J-1, 7 j et 30 j. À valider depuis l'IP de la VM (les IP de centres de données sont parfois bloquées).
- W0 (Error Trigger → Telegram) : sur n8n 2.x il doit être **publié** pour apparaître dans le sélecteur « Error workflow » des autres workflows ; sinon il est grisé. Seuls deux nœuds, `Error Trigger → Send message`, sans Manual Trigger. Test fiable avec un Schedule Trigger (un lancement manuel n'appelle pas toujours le workflow d'erreur) ; dépublier le workflow de test ensuite.
- n8n figé en 2.43.7 dans `deploy/docker-compose.yml` (plus de `latest`).
- Budget LLM fixé : 2 € par mois maximum (limite de dépense à régler côté console API), alerte W5 à 100 000 tokens par mois. Claude Haiku 5.5 : 0,10 $ / 0,50 $ par million de tokens (entrée / sortie, tarifs en cache au 2026-10-06) ; l'usage prévu coûte environ 0,005 $ par mois.
- L'abonnement Claude (claude.ai, Claude Code) est séparé de l'API : n8n a besoin d'une clé API de la console avec son propre crédit.
- Telegram : « chat not found » = mauvais Chat ID ou bot jamais démarré (`/start`) ; l'id personnel vient de @userinfobot.
- Caddy commun de la VM : n8n le rejoint via le réseau Docker `web` (alias `n8n-app`), sans publier de port ; le domaine dans le `.env` du proxy doit être exact, sinon pas de certificat.

## 2026-10-17
- Décision : fil rouge = suivi des actions IT ; un seul agent LLM (Haiku), le calcul des variations est déterministe donc gratuit en tokens. Alertes via Telegram.
- Cadrage du projet : n8n sur VM Oracle, objectifs tokens/alertes/traçabilité. Voir `PLAN.md`.
