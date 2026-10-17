---
description: Met à jour le journal d'apprentissage et le cahier des compétences
allowed-tools: Read, Edit, Bash(git log:*), Bash(git diff:*)
---

Objectif : tracer ce qui a été appris, avec un minimum de tokens.

1. Identifie ce qui a changé depuis la dernière mise à jour : `git log --oneline -15` et la conversation en cours. $ARGUMENTS peut préciser le sujet.
2. `docs/LEARNINGS.md` : ajoute en haut une entrée datée (concepts compris, pièges évités, commandes utiles), 3 à 6 puces max. Pas de doublon avec les entrées existantes.
3. `docs/COMPETENCES.md` : relève le niveau des compétences réellement pratiquées (preuve = workflow ou doc) ; ne surestime pas, ajoute une ligne si une compétence manque.
4. Mets à jour le statut dans `BACKLOG.md` si une tâche est terminée.
5. Résume en 3 lignes ce qui a été modifié. Ne commite pas (utiliser `/validate-and-commit`).
