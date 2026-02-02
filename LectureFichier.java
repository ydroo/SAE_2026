import java.io.FileInputStream;

import java.util.Scanner;

public class LectureFichier
{
	public static String lireFichier(String cheminFichier)
	{
		try
		{
			String  txt = "";
			Scanner sc  = new Scanner(new FileInputStream(cheminFichier), "UTF8");

			String ligne;
			while (sc.hasNextLine())
			{
				ligne = sc.nextLine();
				txt  += ligne + "\n";
			}

			sc.close();
			return txt;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return "";
	}
}