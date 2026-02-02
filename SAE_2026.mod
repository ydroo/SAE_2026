/*********************************************
 * OPL 22.1.1.0 Model
 * Auteur : Groupe 5
 * Date   : 02/02/2026
 *********************************************/

// Définition des paramètres globaux
int n = ...; // Nombre total de sommets (dépôt + clients)
int m = ...; // Nombre de clients
int V = ...; // Nombre de véhicules

int Qmax = ...; // Capacité maximale des véhicules

// Définir les ensembles pour les indices
range Nodes    = 0..n-1; // Tous les sommets (0 = dépôt, 1..m = clients)
range Clients  = 1..m;   // Seulement les clients
range Vehicles = 1..V;   // Les véhicules disponibles

// Données du problème (à définir dans un fichier de données)
float distance[Nodes][Nodes] = ...; // Matrice des distances
int   demande[Clients]       = ...; // Demande de chaque client

// Variables de décision
dvar boolean x[Nodes][Nodes][Vehicles]; // x[i][j][v] = 1 si le véhicule v passe de i à j
dvar int+    Q[Nodes][Vehicles];        // Capacité restante du véhicule v au nœud i
dvar int+    nbrVehicules;              // Nombre de véhicules utilisés

// Fonction objectif : minimiser la distance totale parcourue
minimize
	sum(v in Vehicles, i in Nodes, j in Nodes : i != j)
		distance[i][j] * x[i][j][v];

// Contraintes
subject to
{
	// Chaque véhicule quitte le dépôt et y revient
	forall(v in Vehicles)
		sum(i in Clients) x[0][i][v] == sum(j in Clients) x[j][0][v];

	// Chaque client est visité exactement une fois
	forall(i in Clients)
		sum(v in Vehicles, j in Nodes : j != i) x[j][i][v] == 1;

	// Conservation des flux pour chaque nœud
	forall(v in Vehicles, i in Clients)
		sum(j in Nodes : j != i) x[i][j][v] == sum(j in Nodes : j != i) x[j][i][v];

	// La capacité des véhicules ne peut être dépassée
	forall(v in Vehicles, i in Clients)
		Q[i][v] >= demande[i];

	// Mise à jour de la capacité restante
	forall(v in Vehicles, i in Nodes, j in Clients : i != j)
		Q[j][v] >= Q[i][v] - demande[j] - (1 - x[i][j][v]) * Qmax;

	// Nombre de véhicules utilisés
	nbrVehicules == sum(v in Vehicles, i in Clients) x[0][i][v];

	// Élimination des sous-tours (MTZ)
	forall(v in Vehicles, i in Clients, j in Clients : i != j)
		Q[j][v] >= Q[i][v] + demande[j] - Qmax * (1 - x[i][j][v]);
}

// Paramètres CPLEX
execute
{
	cplex.tilim = 120;  // Temps limite
	cplex.epgap = 0.01; // Tolérance d'écart
}