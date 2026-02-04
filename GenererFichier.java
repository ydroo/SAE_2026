import java.io.FileInputStream;

import java.util.Scanner;

public class GenererFichier
{
	public static String lireFichier(String cheminFichier)
	{
		try
		{
			String txt = "";
			Scanner scanner = new Scanner(new FileInputStream(cheminFichier), "UTF8");

			String ligne;
			while (scanner.hasNextLine())
			{
				ligne = scanner.nextLine();
				txt += ligne + "\n";
			}

			scanner.close();
			return txt;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return "";
	}
}