package servant;

import java.sql.*;
import javax.servlet.http.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class QueryService {

	public HttpServletResponse response;
	
	public void init(HttpServletResponse response){
		this.response=response;
	}
		
	//Create a JSON array with the queried data
	private void creatJson(JSONArray json,String sql){
		
		try{
			 ResultSet rs=DBAccess.query(sql);			 			 
			 ResultSetMetaData rsmd=rs.getMetaData();	
			 
			while(rs.next()){			
				 int columnsCount=rsmd.getColumnCount();
				 JSONObject obj=new JSONObject();
				 
				 for(int i=1;i<=columnsCount;i++){
					 String column_name=rsmd.getColumnName(i);	
					 
					 if(rsmd.getColumnType(i)==java.sql.Types.INTEGER) {
							obj.put(column_name, rs.getInt(column_name)); 
					 }
					 else if(rsmd.getColumnType(i)==java.sql.Types.FLOAT){
							obj.put(column_name, rs.getFloat(column_name)); 
					 }
					 else if(rsmd.getColumnType(i)==java.sql.Types.VARCHAR){
							obj.put(column_name, rs.getNString(column_name)); 
					 }
					 else if(rsmd.getColumnType(i)==java.sql.Types.TINYINT){
							obj.put(column_name, rs.getInt(column_name)); 
					 }
					 else if(rsmd.getColumnType(i)==java.sql.Types.TIMESTAMP){
							obj.put(column_name, rs.getString(column_name)); 
					 }
					 else{ 
							obj.put(column_name, rs.getObject(column_name)); 
					 }
				 
				 }
				 json.add(obj);
			 }
			 rs.close();
			 DBAccess.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	//Fill the response content with a string converted from the JSON array
	public void getInfo()
	{
		try{		
			JSONArray json = new JSONArray();
			String sql = "SELECT magnitude,datetime,latitude,longitude,depth,location FROM earthquake ORDER BY datetime DESC LIMIT 20";
			this.creatJson(json, sql);
			String jsonstring = json.toString();
			//System.out.println(jsonstring);
			
			 if(response==null)
					System.out.println("response is null");	
			 response.setContentType("application/json");
			 response.getOutputStream().write(jsonstring.getBytes("unicode"));
			 response.getOutputStream().flush();
			 response.getOutputStream().close();	
			
		} catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
	//Test program
/*	public static void main(String[] args){

		QueryService qs = new QueryService();
		qs.getInfo();
	}*/
	
}
