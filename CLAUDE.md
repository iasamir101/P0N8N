# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Objectif du projet

Projet d'apprentissage : héberger **n8n** sur une VM Oracle Cloud (Always Free) pour orchestrer des agents simples et des workflows planifiés (cron) qui tournent même PC éteint. Le plan est dans `PLAN.md`, l'avancement dans `BACKLOG.md`.

Le dépôt local contient les workflows (JSON/TypeScript n8n-as-code), la config de déploiement (docker-compose) et la documentation d'apprentissage. Il n'y a pas de build/lint/tests : la validation passe par `validate_n8n_workflow` (MCP n8n-as-code) et par une exécution de test dans n8n.

## Architecture

Fil rouge : suivi des cours d'actions IT (jour/semaine/mois, hausses et chutes), digest Telegram. Workflows liés par Execute Workflow :
`Cron → W1 collecte+calcul → W2 analyste (seul appel LLM, DeepSeek) → W3 digest Telegram`, `W4 approbation` sur grosse chute, `W0 error handler` lié à tous, `W5` suivi des tokens. Détail dans `PLAN.md`. Les exports vont dans `workflows/` (sans secrets).

W4 reste une action **simulée** : aucun vrai ordre ni paiement sans accord explicite de l'utilisateur.

## Fichiers de suivi (à tenir à jour)

- `PLAN.md` : phases et étapes.
- `BACKLOG.md` : état des tâches (source de vérité de l'avancement).
- `docs/LEARNINGS.md` : journal chronologique des apprentissages (une entrée par session/découverte).
- `docs/COMPETENCES.md` : cahier des compétences (grille de niveau par sujet n8n/infra).

## Commandes projet (`.claude/commands/`)

- `/backlog` : affiche l'avancement.
- `/validate-and-commit` : valide puis commit **sans push**.
- `/update-docs` : met à jour LEARNINGS et COMPETENCES.

## Règles de travail

- **Sobriété en tokens** : préférer les nœuds n8n déterministes (HTTP, Code, IF, Filter, Set) ; n'appeler un LLM que pour ce qui l'exige, avec le plus petit modèle suffisant, `max_tokens` borné, entrée pré-filtrée/tronquée, résultats mis en cache. Ne pas lire de gros fichiers entiers ni relancer des recherches déjà documentées dans `docs/LEARNINGS.md`.
- **Actions critiques = validation humaine** : tout workflow qui paie, supprime, envoie à l'extérieur ou modifie l'infra doit passer par une étape d'approbation (Telegram « send and wait ») avant exécution. Ne jamais l'exécuter automatiquement.
- **Alerte sur erreur** : chaque workflow actif référence le workflow d'erreur global (Error Trigger → notification Telegram).
- **Git** : commits locaux uniquement ; ne jamais `git push` sans demande explicite.
- **Secrets** : credentials uniquement dans n8n ou `.env` (ignoré par git), jamais dans les JSON de workflows exportés.
- **Dépôt public** (`iasamir101/P0N8N`) : ne jamais y mettre l'IP ou le vrai domaine de la VM (utiliser `n8n.example.com`), ni chat id Telegram, URL de webhook, archive de sauvegarde ou export de workflow non relu. Un secret poussé par erreur se révoque, il ne s'efface pas.
- Documenter chaque nouvelle découverte dans `docs/LEARNINGS.md` (court, orienté « ce que j'ai appris / piège évité »).
