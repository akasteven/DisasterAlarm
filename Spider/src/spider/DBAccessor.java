package spider;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBAccessor {

	//Database connection constants
	public final static String driver="com.mysql.jdbc.Driver";
	public final static String url="jdbc:mysql://localhost:3306/disaster_info";
	public final static String username="root";
	public final static String password="creolophus";
	
	//Database connection variables
	public  static Connection conn=null;
	public  static Statement stmt=null;
	public  static ResultSet rs=null;
	
	//Connect database
	public static void connect() {
		if(null==conn) {
			try {
				Class.forName(driver).newInstance();
				conn=DriverManager.getConnection(url,username,password);
				stmt=conn.createStatement();
				if(!conn.isClosed())
					System.out.println("Database connected successfully!");				
			} catch (Exception e) {
				System.out.println("Shit!");
				e.printStackTrace();
			}		
		}
	}
	
	//Close database
	public static void close() {
		try{
			if(null!=conn){
				stmt.close();
				conn.close();
				stmt=null;
				conn=null;
			}
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	//Query database  
	public static ResultSet query(String sql) {
		if(conn==null) {
			connect();
		} 	

		try {
			rs=stmt.executeQuery(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rs;
	}
	
	
	//insert records database
	public static boolean insert(String sql) {
		if(conn==null) {
			connect();
		}
		
		if(sql == "")
			return false;
		
		try {
			stmt.execute(sql);
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
}
