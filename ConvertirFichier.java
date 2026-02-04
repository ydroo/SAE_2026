import java.util.Locale;
import java.util.Scanner;

import java.io.File;
import java.io.PrintWriter;

public class ConvertirFichier
{
	public static void main(String[] args)
	{
		String fichierSource = "tai75a.txt";
		String fichierCplex  = "SAE_2026.dat";

		try
		{
			Scanner sc = new Scanner(new File(fichierSource));

			// 1. Lecture des entêtes
			int    n        = sc.nextInt();
			double capacite = sc.nextDouble();
			int    Qmax     = sc.nextInt();

			double[] x = new double[n + 1];
			double[] y = new double[n + 1];

			int[]    demande = new int[n + 1];

			// 2. Lecture des lignes de données (ID, X, Y, Demande)
			for (int i = 0; i <= n; i++)
			{
				sc.nextInt(); // Sauter l'ID

				x[i]       = sc.nextDouble();
				y[i]       = sc.nextDouble();
				demande[i] = sc.nextInt();
			}

			// 3. Calcul de la matrice de distance (Euclidienne)
			double[][] dist = new double[n + 1][n + 1];
			for (int i = 0; i <= n; i++)
			{
				for (int j = 0; j <= n; j++)
				{
					dist[i][j] = Math.sqrt(Math.pow(x[i] - x[j], 2) + Math.pow(y[i] - y[j], 2));
				}
			}

			// 4. Écriture du fichier .dat pour OPL
			PrintWriter writer = new PrintWriter(fichierCplex);

			writer.println("n = " + (n + 1) + ";");
			writer.println("m = " + n + ";"      );
			writer.println("V = 10;"             );
			writer.println("Qmax = " + Qmax + ";");

			// Écriture du tableau de demande
			writer.print("demande = [");
			for (int i = 1; i <= n; i++)
			{
				writer.print(demande[i] + (i == n ? "" : ", "));
			}

			writer.println("];");

			// Écriture de la matrice de distance
			writer.println("distance = [");
			for (int i = 0; i <= n; i++)
			{
				writer.print("  [");
				for (int j = 0; j <= n; j++)
				{
					writer.printf(Locale.US, "%.2f%s", dist[i][j], (j == n ? "" : ", "));
				}

				writer.println("]" + (i == n ? "" : ","));
			}

			writer.println("];");
			writer.close();

			System.out.println("Fichier " + fichierCplex + " généré !");
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}
