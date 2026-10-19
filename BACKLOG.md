# Backlog

Statuts : `todo` · `doing` · `done` · `blocked`

| ID | Phase | Tâche | Statut | Notes |
|----|-------|-------|--------|-------|
| 0.1 | 0 | Choisir canal d'alerte | done | Telegram |
| 0.2 | 0 | Choisir LLM | done | Claude Haiku |
| 0.3 | 0 | git init + .gitignore | done | |
| 0.4 | 0 | Créer le bot Telegram (BotFather) + chat id | done | message de test reçu |
| 0.5 | 0 | Fixer le budget mensuel de tokens | done | plafond 2 € par mois (limite fournisseur) ; alerte W5 à 100 000 tokens par mois |
| 1.1 | 1 | Créer la VM Oracle Always Free | done | |
| 1.2 | 1 | Docker + n8n en compose | done | squelette dans `deploy/` |
| 1.3 | 1 | HTTPS + auth | done | compte owner créé |
| 1.4 | 1 | Sauvegarde + test de restauration | done | |
| 2.1 | 2 | W0 Error handler global | done | testé avec un cron en erreur, alerte Telegram reçue |
| 2.2 | 2 | Hello cron → Telegram (PC éteint) | done | message reçu, test PC éteint confirmé |
| 3.1 | 3 | W1 Collecte & calcul des variations | done | Yahoo chart, digest Telegram reçu, cron `30 22 * * 0-5` (Europe/Paris), publié |
| 3.2 | 3 | W2 Analyste (DeepSeek) + W3 Digest Telegram | done | dans W1 : IF (seuil 3 %) → HTTP Analyste → Assemble → Telegram ; les deux branches testées ; tokens dans `usage.total_tokens` |
| 3.3 | 3 | W5 Suivi des tokens + alerte budget | done | cumul mensuel en static data dans W1 (nœud `Suivi tokens` + IF), alerte à 100 000 tokens, testée avec seuils 1 et 10 000 |
| 4.1 | 4 | W4 Approbation (action simulée) | blocked | suspendu : problème avec la version de n8n (déclencheur « appelé par un autre workflow » introuvable) ; prévu : trigger → Telegram send-and-wait → IF → journal simulé |
| 5.1 | 5 | W6 Agent alertes : AI Agent + modèle DeepSeek, test manuel | done | workflow séparé, AI Agent + DeepSeek Chat Model, réponse cohérente sur données de test |
| 5.2 | 5 | W6 : un outil (historique d'un ticker) + garde-fous (3 itérations, tokens bornés) | doing | |
| 5.3 | 5 | W6 : décision d'intégrer ou non à W1 selon coût et valeur | todo | rester déterministe si pas de gain |
