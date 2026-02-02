# SAE_2026

## Description du projet

Ce projet implémente une solution pour le problème de tournées de véhicules (Vehicle Routing Problem - VRP) en utilisant IBM ILOG CPLEX Optimization Studio (OPL).

## Contenu du projet

### Fichiers principaux

- **SAE_2026.mod** : Modèle OPL définissant le problème d'optimisation
  - Formulation mathématique du VRP
  - Variables de décision pour les routes et capacités
  - Contraintes d'élimination des sous-tours (MTZ)
  - Fonction objectif : minimisation de la distance totale parcourue

- **LectureFichier.java** : Classe utilitaire Java pour la lecture de fichiers
  - Méthode `lireFichier(String cheminFichier)` : lit le contenu d'un fichier texte en UTF-8

## Paramètres du modèle

- `n` : Nombre total de sommets (dépôt + clients)
- `m` : Nombre de clients à desservir
- `V` : Nombre de véhicules disponibles
- `Qmax` : Capacité maximale de chaque véhicule
- `distance[][]` : Matrice des distances entre les nœuds
- `demande[]` : Demande de chaque client

## Fonctionnalités

### Contraintes implémentées

1. Chaque véhicule part du dépôt et y revient
2. Chaque client est visité exactement une fois
3. Conservation des flux pour chaque nœud
4. Respect de la capacité maximale des véhicules
5. Élimination des sous-tours (méthode MTZ)

## Utilisation

### Prérequis

- IBM ILOG CPLEX Optimization Studio
- Java Development Kit (JDK) pour l'utilisation de la classe LectureFichier

### Exécution du modèle

1. Préparer un fichier de données (.dat) contenant les valeurs pour les paramètres
2. Charger le modèle SAE_2026.mod dans CPLEX
3. Lancer l'optimisation