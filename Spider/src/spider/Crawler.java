package spider;

import java.net.HttpURLConnection;
import java.net.URL;

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
	private final String inserthead = "INSERT INTO earthquake (magnitude,datetime,latitude,longitude,depth,location) VALUES (";
	private String insertstring = "";

	//Parse pages and store records 
	public void crawl()
	{
		try{		
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
			
			//Every record consists of texts in six nodes
			int recordCount = nodeCount / 6 ; 
			
			//Store records into database
			DBAccessor.connect();
			for( int i = 0 ; i < recordCount ; i ++ )
			{
				insertstring = inserthead ;
				for( int j = 0 ; j < 6 ; j ++ )
				{
					Node textNode = (Node) nl.elementAt( i* 6 + j );
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
	
//	public static void main(String[] args)
//	{
//		Crawler spider = new Crawler();
//		spider.crawl();
//	}
	
}
