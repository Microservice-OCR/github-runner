# github-runner

## Description
Ce module sert à éxécuter localement les github actions de votre repository github.

## Prérequis
- Docker
- Un compte github avec un repository contenant des actions github

## Utilisation
1. Créer un fichier .env à la racine du repository avec les variables suivantes:
```
GH_TOKEN=<votre_token>
GH_OWNER=<votre_pseudo_github>
GH_REPOSITORY=<le_nom_de_votre_repository>
```
2. Démarrer le conteneur : `docker compose up`
3. Votre runner est maintenant prêt à éxécuter vos actions github

## Supprimer le runner
1. Supprimer le runner sur github en utilisant la commande suivante:
```
docker exec <conteneur_id> /bin/bash -c "/home/docker/actions-runner/config.sh remove --unattended --token ${GH_TOKEN}"
```
2. Arrêter le conteneur docker
3. Supprimer le conteneur docker