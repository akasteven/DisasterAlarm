package servant;

import java.sql.*;


public class DBAccess {

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
	private static void connect() {
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
	
	
	//Update database
	public static boolean update(String sql) {
		if(conn==null) {
			connect();
		}
		try {
			stmt.executeUpdate(sql);
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	// Test program
	
/*	public static void main(String[] args){
		connect();
		query("SELECT magnitude,datetime,latitude,longitude,depth,location FROM earthquake ORDER BY datetime DESC LIMIT 3");
		try {
		while(rs.next()){
				System.out.print(rs.getString(1));
				System.out.print(" "+rs.getString(2));
				System.out.print(" "+rs.getString(3));
				System.out.print(" "+rs.getString(4));
				System.out.print(" "+rs.getString(5));
				System.out.print(" "+rs.getString(6));
				System.out.println();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		close();
	}*/
	
	
	
}