import java.io.IOException;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class pbdJdbc { 

	private static Connection conexion = null ; 

	public boolean dbConectar() {
		
		System.out.println("---dbConectar---");
		
		String driver = "oracle.jdbc.OracleDriver";
		// Crear la conexion a la base de datos 
        String servidor = "localhost"; // Direccion IP
		String puerto = "1521";
		String sid = "xe"; // Identificador del servicio o instancia
        String url = "jdbc:oracle:thin:@//" + servidor + ":" + puerto + "/" + sid;
		String usuario = "system"; // usuario 
        String contrasena = "12345"; // contrasena 
		
		try { 
		     System.out.println("---Conectando a Oracle---");
   		     Class.forName (driver); // Cargar el driver JDBC para Oracle
             conexion = DriverManager.getConnection (url, usuario, contrasena); 
             System.out.println ("Conexion realizada a la base de datos " + conexion); 
             return true; 
         } catch (ClassNotFoundException e) { 
             // Error. No se ha encontrado el driver de la base de datos 
             e.printStackTrace(); 
             return false; 
         } catch (SQLException e) { 
             // Error. No se ha podido conectar a la BD 
             e.printStackTrace(); 
             return false; 
         } 
	}
	
     /* ------------------------------------------------------------------ */	

	public boolean dbDesconectar() {
		System.out.println("---dbDesconectar---");

		try {
			conexion.commit();
			conexion.close();
			System.out.println("Desconexión realizada correctamente");
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/* ------------------------------------------------------------------ */
	
	static String readEntry(String prompt) { 
		try { 
			StringBuffer buffer = new StringBuffer(); 
			System.out.print(prompt); 
			System.out.flush(); 
			int c = System.in.read(); 
			while(c != '\n' && c != -1) { 
				buffer.append((char)c); 
				c = System.in.read(); 
			} 
			return buffer.toString().trim(); 
		} catch (IOException e) { 
			return ""; 
		} 
	} 
	
	/* ------------------------------------------------------------------ */	
	
	public void dbObtenerPersonajes1() {
		PreparedStatement ps;
		String IDobjetivo;
		
		System.out.println("---dbObtenerPersonajes1---");
		
		try {
			ps = conexion.prepareStatement("SELECT NOMBRE, CP, SEXO, PATRIMONIO, CLASE FROM PERSONAJES WHERE ID = ?");
			
			// Por ejemplo, buscar Personajes con ID 987
			IDobjetivo = readEntry("Introduce ID de Personajes: ");
			ps.clearParameters();
			ps.setString(1,IDobjetivo);
			ResultSet rset = ps.executeQuery();

			if (rset.next()) {
				 System.out.println("Nombre: "+rset.getString(1));
				 //...
				 //////////////////////////////////////////////////////////////
				 System.out.println("Código postal: "+rset.getString(2));
				 System.out.println("Sexo: "+rset.getString(3));
				 System.out.println("Patrimonio: "+rset.getFloat(4));
				 
				 //////////////////////////////////////////////////////////////
				 System.out.println("Clase: "+rset.getInt(5));
		    }
			rset.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	/* ------------------------------------------------------------------ */
	
	public void dbObtenerPersonajes2() {
		Statement ps;
		String consulta;
		
		System.out.println("---dbObtenerPersonajes2---");
		
		try {
			ps = conexion.createStatement();
			
			// Por ejemplo, buscar Personajes con ID 987
			consulta = readEntry("Introduce ID de Personajes: ");
			String result = "SELECT NOMBRE, CP, SEXO, PATRIMONIO, CLASE FROM Personajes WHERE ID = '" + consulta + "'";
			ResultSet rset = ps.executeQuery(result);
			
			System.out.println(result);
			
			if (rset.next()) {
				System.out.println("Nombre: "+rset.getString(1));
				 
				 //////////////////////////////////////////////////////////////
				 System.out.println("Código postal: "+rset.getString(2));
				 System.out.println("Sexo: "+rset.getString(3));
				 System.out.println("Patrimonio: "+rset.getFloat(4));
				 
				 //////////////////////////////////////////////////////////////
				 System.out.println("Clase: "+rset.getInt(5));
				 System.out.println("--------------------------------------");
		    }
			rset.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	/* ------------------------------------------------------------------ */
	
	public void dbConsultarPersonajes() {
		Statement ps;
		String consulta;
		
		System.out.println("---dbConsultarPersonajes---");
		
		try {
			ps = conexion.createStatement();
			consulta = "SELECT ID, NOMBRE, FECHANAC, CP, SEXO, PATRIMONIO, CLASE FROM PERSONAJES";
			ResultSet rset = ps.executeQuery(consulta);
			
			System.out.println(consulta);
			
			while (rset.next()) {
				System.out.println("ID: "+rset.getString(1));
				System.out.println("Nombre: "+rset.getString(2));
				 //...
				 //////////////////////////////////////////////////////////////
				 System.out.println("FechaNac: "+rset.getString(3));
				 System.out.println("CP: "+rset.getString(4));
				 System.out.println("Sexo: "+rset.getString(5));
				 System.out.println("Ingresos: "+rset.getFloat(6));
				 
				 //////////////////////////////////////////////////////////////
				 System.out.println("Clase: "+rset.getInt(7));
				 System.out.println("--------------------------------------");
			}
			
			rset.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
/* ------------------------------------------------------------------ */
	
	public void dbConsultarClases() {
		Statement ps;
		String consulta;
		
		
		System.out.println("---dbConsultarClases---");
		
		try {
			ps = conexion.createStatement();
			
			consulta = "SELECT COD, NOMBRE, INGRESOS FROM CLASES";
			ResultSet rset = ps.executeQuery(consulta);
			
			System.out.println(consulta);
			
			while (rset.next()) {
				System.out.println("Codigo Clase: "+rset.getInt(1));
				 
				 System.out.println("Nombre Clase: "+rset.getString(2));
				 
				 System.out.println("Ingresos Clase: "+rset.getFloat(3));
				 System.out.println("--------------------------------------");
			}
			rset.close();
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
		
/* ------------------------------------------------------------------ */
	
	public void dbInsertarClases() {
		Statement ps;
		String consulta;
		String codigo, nombre;
		int resultado;
		int ingresos;
		
		System.out.println("---dbInsertarClases---");
		
		try {
			ps = conexion.createStatement();
			
			codigo = readEntry("Codigo clase: ");// por ejemplo 0
			nombre = readEntry("Nombre Clase: ");
			ingresos = 0;
		
			
			consulta ="INSERT INTO CLASES VALUES ('" + codigo + "', '" + nombre + "','"  + ingresos + "' )";
			// OJO: Las cadenas en el insert deben ir entre comillas simples ''
			System.out.println(consulta);
			resultado = ps.executeUpdate(consulta);
			
			
			System.out.println("Numero de filas afectadas: "+resultado);
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}

	/* ------------------------------------------------------------------ */
	
	public void dbModificarClases() {
		Statement ps;
		String consulta;
		String nombre;
		int resultado;
		
		System.out.println("---dbModificarClases---");
		
		try {
			ps = conexion.createStatement();
			
			nombre = "Desconocido";// Cambiar el nombre por 'Desconocido'
			
			consulta ="UPDATE CLASES SET NOMBRE = '"+nombre+"' WHERE COD=0";
			// OJO: Las cadenas en el insert deben ir entre comillas simples ''
			resultado = ps.executeUpdate(consulta);
			
			System.out.println(consulta);
			System.out.println("Numero de filas afectadas: "+resultado);
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}

	/* ------------------------------------------------------------------ */
	
	public void dbBorrarClases() {
		Statement ps;
		String consulta;
		int resultado, numero;
		
		System.out.println("---dbBorrarClases---");
		
		try {
			ps = conexion.createStatement();
			
			numero = 0;// Borrar el sector 0
			
			consulta ="DELETE FROM CLASES WHERE COD="+numero+"";
			resultado = ps.executeUpdate(consulta);
			
			System.out.println(consulta);
			System.out.println("Numero de filas afectadas: "+resultado);
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
		
	/* ------------------------------------------------------------------ */

	public static void main(String[] args){ 
         pbdJdbc cliente = new pbdJdbc();
		 System.out.println("---Programa principal---");
		 
    	 if (!cliente.dbConectar()) 
             System.out.println("Error: Conexion no realizada.");
    	 
    	 cliente.dbObtenerPersonajes1();
		 cliente.dbObtenerPersonajes2();
				 
		 cliente.dbConsultarPersonajes();
		 cliente.dbConsultarClases();
				
		 cliente.dbInsertarClases();
		 cliente.dbConsultarClases();
				 
		 cliente.dbModificarClases();
		 cliente.dbConsultarClases();

		 cliente.dbBorrarClases();
		 cliente.dbConsultarClases();			
			
		if (!cliente.dbDesconectar())
			System.out.println("Desconexión no realizada");
			
		System.out.println("---Fin de programa---");
        
	}
	     
 } 