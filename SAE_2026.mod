/*********************************************
 * OPL 22.1.1.0 Model
 * Auteur : Groupe 5
 * Date   : 02/02/2026
 *********************************************/

/*--------------------------------------------------------*/
/*                 Définition des données                 */
/*--------------------------------------------------------*/
// Nombre de clients
int nbclient = ...;

// Nombre de dépôts
int nbdepot = ...;

int nbNoeud = nbclient+nbdepot;

// Nombre de véhicules
int nbvehicule = ...;
// Distance entre les noeuds (clients ou dépôt) i et j
float dist[1..nbNoeud][1..nbNoeud] = ...;
// Demande du client i 
float demande[1..nbclient] = ...;
// Capacité du véhicule v 
int qmax = ...;

/*--------------------------------------------------------*/
/*                  Variables de décision                 */
/*--------------------------------------------------------*/

// xijv = 1 si le véhicule v passe directement du noeud i au noeud j, 0 sinon
dvar boolean x[1..nbNoeud][1..nbNoeud][1..nbvehicule];
// Capacité restante du véhicule v au retour au dépôt
dvar int qapresretour[1..nbvehicule];
// Nombre de véhicules utilisés
dvar int+ nbre;
// Variables auxiliaires pour éliminer les sous-tours
dvar int+ u[1..nbNoeud];

/*--------------------------------------------------------*/
/* Fonction objectif : minimiser la distance des tournées */
/*--------------------------------------------------------*/

dexpr float objectif = sum(i in 1..nbNoeud, j in 1..nbNoeud, v in 1..nbvehicule) dist[i][j] * x[i][j][v];
minimize objectif;
/*--------------------------------------------------------*/
/*                      Contraintes                       */
/*--------------------------------------------------------*/
subject to {
	// Un véhicule qui quitte le dépôt, retourne au dépôt à la fin de sa tournée
	forall (v in 1..nbvehicule) {
		sum(j in (nbdepot+1)..nbNoeud) x[j][1][v] == sum (j in (nbdepot+1).. nbNoeud) x[1][j][v];
		sum(j in (nbdepot+1)..nbNoeud) x[j][1][v] <= 1;
	}  
	
	// Un véhicule ne peut pas faire de boucle sur un même noeud
	forall (i in 1..nbNoeud, v in 1..nbvehicule)
		x[i][i][v] == 0;
	  
	// Un client est visité exactement une et une seule fois par un véhicule
	forall (j in (nbdepot+1)..nbNoeud)
		sum(v in 1..nbvehicule, i in 1..nbNoeud) x[i][j][v] == 1;
	
	// Conservation de flux
	forall (j in 1..nbNoeud, v in 1..nbvehicule)
		sum (i in 1..nbNoeud)x[j][i][v] == sum (i in 1..nbNoeud) x[i][j][v];
	
	// Au moins un véhicule est utilisé pour la construction des tournées
	nbre == sum(j in 1..nbNoeud, v in 1..nbvehicule) x[1][j][v];
	nbre >= 1;
	
	// Elimination des sous-tours
	forall (i in (nbdepot+1)..nbNoeud, j in (nbdepot+1)..nbNoeud, v in 1..nbvehicule : i!=j)
		u[j]-u[i] >= demande [j-nbdepot] - qmax*(1-x[i][j][v]);
	forall (i in (nbdepot+1)..nbNoeud){
		demande[i-1] <= u[i];
		u[1] <= qmax;
	}
	
	// La capacité du véhicule ne peut être dépassée
	forall (v in 2..nbvehicule)
		sum(i in 1..nbNoeud, j in (nbdepot+1)..nbNoeud) demande[j-nbdepot]*x[i][j][v] <= qmax;
	
	//Calcul de la capacité restante au retour au dépôt
	forall (v in 1..nbvehicule)
		qapresretour[v] == qmax - sum(i in 1..nbNoeud, j in (nbdepot+1)..nbNoeud) demande [j-nbdepot] * x[i][j][v];
}

/*--------------------------------------------------------*/
/*                 Paramètres d'affichage                 */
/*--------------------------------------------------------*/

execute {
	// Utiliser un tableau scriptable pour suivre les noeuds visités
	var visiter = new Array(nbNoeud + 1);
	for (var v = 1; v <= nbvehicule; v++)
	{
		// Initialiser le tableay visiter pour chaque véhicule
		for (var j = 1; j <= nbNoeud; j++)
			visiter[j] = 0;
  		write ("Vehicule ", String.fromCharCode(122 - nbvehicule + v), " : ");
  		var route = "Dépôt";
  		var i = 1;
  		while(true)
  		{
  			var found = 0;
  			for (var j = 1; j <= nbNoeud; j++)
  			{
  				if ((j <= nbdepot || visiter [j] != 1) && x[i][j][v] == 1) 
  				{
  					visiter[j] = 1;
  					i = j;
  					if (j <= nbdepot)
  						route += " -> Dépôt";
  					else
  						route += " -> C" + (j - nbdepot);
  					found = 1;
  					break;
  				}
  			}
  			if (found != 1) break;
  		}
  		if (route == "Dépôt")
  			//write("Dépôt -> Aucun déplacement effectué.");
  			writeln();
  		else
  		{
  			writeln(route);
  			write("Capacité utilisée : ", (qmax - qapresretour[v]));
  		}
  		writeln();
	}
}

