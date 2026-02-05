import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.Arrays;
import java.util.Locale;
import java.util.Scanner;

public class GenererFichierDat
{
	public static void main(String[] args)
	{
		try
		{
			Scanner sc = new Scanner(new File(args[0]));
			sc.useLocale(Locale.US);

			// 1. Lecture des paramètres de l'instance
			int    nbClients       = sc.nextInt();
			double distanceOptimal = sc.nextDouble();
			int    qMax            = sc.nextInt();

			double[][] coordonnees = new double[nbClients + 1][2];
			int[]      demandes    = new int[nbClients];

			// 2. Lecture des coordonnées et de la demande
			for (int cpt = 0; cpt <= nbClients; cpt++)
			{
				int id = sc.nextInt();

				coordonnees[cpt][0] = sc.nextDouble(); // X
				coordonnees[cpt][1] = sc.nextDouble(); // Y

				int demande = sc.nextInt();
				if (cpt > 0) { demandes[cpt-1] = demande; } // Le dépot ne compte pas
			}

			// 3. Calcul de la matrice des distances
			PrintWriter writer = new PrintWriter(new FileWriter(args[1]));

			Date date = new Date(System.currentTimeMillis());
			writer.println("/*********************************************");
			writer.println(" * OPL 22.1.1.0 Model");
			writer.println(" * Auteur : Groupe 5");
			writer.println(" * Date   : " + date);
			writer.println(" *********************************************/\n");

			writer.println("nbClient   = " + nbClients + ";");
			writer.println("nbDepot    = 1;");
			writer.println("nbVehicule = 10;\n");
			writer.println("qMax       = " + qMax + ";\n");
			writer.println("demande    = " + Arrays.toString(demandes) + ";\n");

			writer.println("distance   =");
			writer.println("[");
			for (int cpt = 0; cpt <= nbClients; cpt++)
			{
				writer.print("\t[");
				for (int cpt2 = 0; cpt2 <= nbClients; cpt2++)
				{
					double distance = Math.sqrt(Math.pow(coordonnees[cpt][0]-coordonnees[cpt2][0], 2)
									+ Math.pow(coordonnees[cpt][1]-coordonnees[cpt2][1], 2));

					writer.printf(Locale.US, "%7.2f", distance);
					if (cpt2 < nbClients) { writer.print(", "); }
				}

				writer.println(cpt == nbClients ? "]" : "],");
			}
			writer.println("];");

			writer.close();
			sc.close();
		}
		catch (Exception e) { e.printStackTrace(); }
	}
}