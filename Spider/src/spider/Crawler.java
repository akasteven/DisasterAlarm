package spider;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.htmlparser.Node;
import org.htmlparser.NodeFilter;
import org.htmlparser.Parser;
import org.htmlparser.filters.HasAttributeFilter;
import org.htmlparser.filters.HasParentFilter;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.util.NodeList;

public class Crawler {

	//Data source web page url
	private final String url = "http://www.ceic.ac.cn/";
	
	//SQL for insert a single record
	private final String inserthead = "INSERT IGNORE INTO earthquake (magnitude,datetime,latitude,longitude,depth,location) VALUES (";
	private String insertstring = "";

	//Formatter for converting String into Date 
	public final static DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); 
	
	//Store the most recent date of the records proceed
	private static Date mostrecent = null;
	
	//Parse pages and store records 
	public void crawl()
	{

		try{		
//			mostrecent = sdf.parse("2013-09-20 20:24:41");
			
			Parser parser=new Parser((HttpURLConnection)(new URL(url)).openConnection());
			
			//Filter td nodes whose parent node is a table of class "news-table"
			NodeFilter parentClass = new HasAttributeFilter("class", "news-table");
			NodeFilter parent = new HasParentFilter(parentClass,true);
			NodeFilter tag = new TagNameFilter("td");
			NodeFilter target = new AndFilter(parent, tag);			
			NodeList nl = parser.extractAllNodesThatMatch(target);
			
			int nodeCount = nl.size();
			if( nodeCount % 6 != 0)
			{
				System.out.println("Error: format error form source page, please check: http://www.ceic.ac.cn");
				System.out.println("Node counts:" + nodeCount);
			}			

			store(nl);

			mostrecent = sdf.parse(nl.elementAt(1).toPlainTextString());
			
		} catch(Exception e){
			e.toString();
		}
	}
	
	
	//Test if the date of a new record is more recent than all that in database
	private boolean isMoreRecent(String dt)
	{
		if( mostrecent == null)
			return true;
		
		Date recorddate = new Date();

		try{		
			 recorddate = sdf.parse(dt);
			 
		} catch (Exception e) {   
		    e.printStackTrace();   
		}		
		return recorddate.after(mostrecent);
	}
	
	
	//Store acquired data
	public void store(NodeList nodelist)
	{
		try{
			
			//A single record contains 6 nodes 
			int count = nodelist.size() / 6 ; 
			DBAccessor.connect();
			for( int i = 0 ; i < count ; i ++ )
			{
				String recorddate = nodelist.elementAt( i* 6 + 1 ).toPlainTextString();

				if(!isMoreRecent(recorddate))
					continue;
				
				insertstring = inserthead ;
				for( int j = 0 ; j < 6 ; j ++ )
				{
					Node textNode = (Node) nodelist.elementAt( i* 6 + j );
					insertstring += "'" + textNode.toPlainTextString() + "'";
					if( j != 5 )
						insertstring += ",";
				}
				insertstring +=");";
				
				DBAccessor.insert(insertstring);
			}
			DBAccessor.close();
			
		} catch(Exception e){
			e.toString();
		}
	}
	
	
	public static void main(String[] args)
	{
		Crawler spider = new Crawler();
		spider.crawl();
	}
	
}
