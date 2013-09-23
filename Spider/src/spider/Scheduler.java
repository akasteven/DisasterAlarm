package spider;

import java.util.Timer;
import java.util.TimerTask;

public class Scheduler {

	public Scheduler(int seconds)
	{
		Timer timer = new Timer();
		timer.schedule(new Task(), 0, seconds * 1000);
	}
	
	class Task extends TimerTask{
		public void run(){
			Crawler spider = new Crawler();
			spider.crawl();
		}
	}

}


