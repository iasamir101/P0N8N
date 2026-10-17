---
description: Affiche l'avancement du projet (phases et sous-étapes) depuis BACKLOG.md
allowed-tools: Read, Edit
---

Lis `BACKLOG.md` et `PLAN.md`. Réponds en français, de façon concise :

1. Progression globale (x/y tâches `done`, pourcentage).
2. Pour **chaque phase** (0 à 6), une ligne d'en-tête `Phase N : titre (x/y, %)` suivie de ses sous-étapes, une par ligne :
   - `✅` done · `🔄` doing · `⛔` blocked · `⬜` todo
   - Les sous-étapes viennent de `BACKLOG.md` (ID + tâche + statut) ; pour une phase sans tâche dans le backlog, reprends les cases `- [ ]` / `- [x]` de `PLAN.md`.
3. Tâches `doing` et `blocked` (avec raison).
4. Les 3 prochaines tâches `todo` recommandées, dans l'ordre du plan.

Si `$ARGUMENTS` contient un ID et un statut (ex. `1.1 done`), mets à jour la ligne correspondante dans `BACKLOG.md` avant d'afficher. Si l'ID n'existe pas, signale-le sans rien modifier. N'ouvre aucun autre fichier.
