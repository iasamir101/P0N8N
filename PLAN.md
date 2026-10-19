# Plan

Objectifs : apprendre n8n (workflows, cron, agents), exécution 24/7 sur VM Oracle, **faible consommation de tokens**, **alerte sur paiement/action critique**, apprentissages tracés en markdown.

**Fil rouge** : suivre le cours d'actions IT (Google, IBM, Oracle, Microsoft, Apple, Meta, Amazon, Nvidia, Adobe, liste extensible) et comparer le prix vs hier / semaine dernière / mois dernier, avec les plus fortes hausses et chutes.

## Architecture cible

```
[Cron 22:30 lun-ven]
        │
   W1 Collecte+Calcul ──► JSON de variations ──► W2 Analyste (DeepSeek) ──► W3 Digest Telegram
        │                                                                      │
        └── échec ──► W0 Error handler global ──► Telegram erreur             └── chute > seuil ──► W4 Approbation (action simulée)
```

- **Un seul agent LLM** (W2 Analyste, DeepSeek, sans outils ni mémoire, ~1 appel/jour, sauté si rien ne bouge). Tout le reste est déterministe. Pas d'orchestrateur LLM : n8n orchestre via Execute Workflow. Un 2e agent seulement en phase 5 si besoin réel.
- **W0** Error Trigger → Telegram, lié à tous les workflows.
- **W1** Schedule → HTTP par ticker (source gratuite d'historique journalier, candidat Stooq CSV, à valider) → Code : clôture, J-1, J-7, J-30, % de variation, top 3 hausses / baisses. Sans stockage.
- **W2** reçoit uniquement le JSON compact, `max_tokens` ≈ 300, saute l'appel si aucune variation > 3 %.
- **W3** Digest Telegram (tableau jour/semaine/mois, 🟢/🔴 + commentaire).
- **W4** Chute > 8 % sur 1 jour → Telegram send-and-wait (Approuver/Refuser) ; action **simulée** (journalisée), aucun vrai ordre.
- **W5** Suivi des tokens par jour, alerte si budget mensuel dépassé.

## Phase 0 : Cadrage (local)
- [x] Canal d'alerte : Telegram.
- [x] LLM : Claude Haiku au départ, remplacé par DeepSeek (appel HTTP, 2026-10-19).
- [x] `git init`, `.gitignore`.
- [ ] Créer le bot via BotFather, récupérer le chat id.
- [x] Budget mensuel : 2 € (limite côté fournisseur), alerte W5 à 100 000 tokens.

## Phase 1 : Infra Oracle
- [ ] Créer la VM Always Free (Ubuntu, ARM Ampere), clé SSH, ports 22/80/443 uniquement (Security List **et** pare-feu OS).
- [ ] Installer Docker + docker-compose.
- [ ] Déployer n8n avec `deploy/docker-compose.yml`, `restart: unless-stopped`, `GENERIC_TIMEZONE` et `TZ` fixés.
- [ ] HTTPS via Caddy + domaine (ou DuckDNS) ; auth n8n activée.
- [ ] Sauvegarde quotidienne (volume n8n + export workflows + clé de chiffrement) ; test de restauration.
- [ ] Vérifier : redémarrer la VM, n8n revient seul.

## Phase 2 : Bases n8n (sans LLM)
- [ ] W0 Error handler global.
- [ ] « Hello cron » : Schedule Trigger → Telegram ; PC éteint, il s'exécute.
- [ ] Apprendre : Schedule vs Cron, timezone, retry on fail, pin data, sous-workflows, expressions.

## Phase 3 : Suivi des actions
- [ ] W1 Collecte & calcul (valider la source de données).
- [ ] W2 Analyste Haiku (budget tokens, saut si calme).
- [ ] W3 Digest Telegram.
- [ ] W5 Suivi des tokens + alerte budget.

## Phase 4 : Garde-fous (actions critiques)
- [ ] W4 : sous-workflow d'approbation réutilisable (send-and-wait), action simulée.
- [ ] Limites : plafond de dépense, kill-switch (variable « pause globale »).

## Phase 5 : Agents orchestrés (optionnel)
- [ ] 2e agent (ex. alertes intelligentes) seulement si valeur démontrée ; sinon rester déterministe.

## Phase 6 : Durcissement
- [ ] Mises à jour n8n planifiées, healthcheck externe (UptimeRobot), rotation des secrets.

## Exercices suivants (hors fil rouge)
Surveillance de prix/disponibilité, tri d'emails → résumé hebdo, rapport de santé de la VM.

## Points ouverts
- Source de données définitive (fiabilité des tickers, limites).
- Seuils d'alerte (3 % / 8 %) à ajuster.
