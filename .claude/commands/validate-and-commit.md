---
description: Valide les changements puis commit localement, sans push
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*), Read, Grep, mcp__plugin_n8n-as-code_n8n-as-code__validate_n8n_workflow
---

1. `git status` et `git diff` pour voir les changements. Si le dépôt n'est pas initialisé, arrête-toi et demande.
2. Valide : pour chaque workflow modifié, appelle `validate_n8n_workflow` ; corrige ou signale les erreurs et ne commite pas si invalide.
3. Contrôle secrets : cherche dans les fichiers modifiés des clés/tokens/mots de passe (`sk-`, `Bearer`, `password`, `token`, bot Telegram `\d+:AA`). Si trouvé, arrête et signale. Ne jamais ajouter `.env`.
4. Ajoute les fichiers pertinents par nom (pas `git add -A`), puis commit avec un message concis en français au format `type: résumé` (feat, fix, docs, chore). Contexte optionnel : $ARGUMENTS.
5. **Ne fais jamais `git push`.** Termine en affichant le hash et le résumé du commit.
