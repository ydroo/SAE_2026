/*********************************************
 * OPL 22.1.1.0 Model
 * Auteur : Groupe 5
 * Date   : 02/02/2026
 *********************************************/

// Paramètres globaux
int n = ...;     // Nombre total de sommets (dépôt + clients)
int m = ...;     // Nombre de clients
int V = ...;     // Nombre de véhicules
int Qmax = ...;  // Capacité maximale des véhicules

// Ensembles
range Nodes = 0..n-1;     // 0 = dépôt, 1..m = clients
range Clients = 1..m;     // clients
range Vehicules = 1..V;    // véhicules

// Données
float distance[Nodes][Nodes] = ...;
int demande[Clients] = ...;

// Variables de décision
dvar boolean x[Nodes][Nodes][Vehicules]; // 1 si véhicule v passe de i à j
dvar int+ Q[Nodes][Vehicules];           // charge transportée après i
dvar boolean y[Vehicules];               // 1 si le véhicule est utilisé
dvar int+ nbrVehicules;

// Objectif : minimiser distance totale
minimize
	sum(v in Vehicules, i in Nodes, j in Nodes : i != j)
		distance[i][j] * x[i][j][v];

// Contraintes
subject to {

  // Chaque client est visité exactement une fois
  forall(i in Clients)
    sum(v in Vehicules, j in Nodes: j != i) x[j][i][v] == 1;

  // Conservation des flux pour chaque client
  forall(v in Vehicules, i in Clients)
    sum(j in Nodes: j != i) x[i][j][v] == sum(j in Nodes: j != i) x[j][i][v];

  // Chaque véhicule quitte le dépôt et y revient
  forall(v in Vehicules)
    sum(i in Clients) x[0][i][v] == sum(j in Clients) x[j][0][v];

  // MTZ / capacité
  forall(v in Vehicules)
    Q[0][v] == 0;  // départ du dépôt

  forall(v in Vehicules, i in Nodes, j in Clients: i != j)
    Q[j][v] >= Q[i][v] + demande[j] - Qmax * (1 - x[i][j][v]);

  // Capacité maximale
  forall(v in Vehicules, i in Nodes)
    Q[i][v] <= Qmax;

  // Lier l’utilisation d’un véhicule à sa sortie du dépôt
  forall(v in Vehicules)
    sum(i in Clients) x[0][i][v] <= m * y[v];

  // Nombre total de véhicules utilisés
  nbrVehicules == sum(v in Vehicules) y[v];
}

// Paramètres CPLEX
execute {
  cplex.tilim = 120;
  cplex.epgap = 0.01;
}

// Affichage des résultats
execute {
  writeln("Affichage des résultats");

  for(var v in Vehicles) {
    var current = 0; // départ dépôt
    var hasClient = false;

    write("• Véhicule ", v, " : Dépôt");

    while (true) {
      var next = -1;
      for(var j in Nodes) {
        if (j != current && x[current][j][v].solutionValue > 0.5) {
          next = j;
          break;
        }
      }

      if (next == -1 || next == 0) break; // retour dépôt ou pas d’arc
      write(" → C", next);
      current = next;
      hasClient = true;
    }

    if (hasClient) writeln(" → Dépôt");
    else writeln(); // véhicule inutilisé
  }
}

