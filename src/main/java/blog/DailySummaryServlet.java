package blog;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.users.User;

import javax.mail.*;
import javax.mail.internet.*;


@SuppressWarnings("serial")
public class DailySummaryServlet extends HttpServlet {
	
	
	private static final String DATE_FORMAT_NOW = "yyyy-MM-dd";
	private static final Logger _logger = Logger.getLogger(DailySummaryServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		try {
		_logger.info("Cron Job has been executed");
		
		//Put your logic here
		//BEGIN
		sendDailySummary();	
		//END
		
		}
		catch (Exception ex) {
		//Log any exceptions in your Cron Job
		}
	}
	
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException {
	
		doGet(req, resp);
	
	}
	
	
	private void sendDailySummary() {
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

		Properties props = new Properties();							// ****
		Session session = Session.getDefaultInstance(props, null);		// ****
		
		try {
			// create new message object
			Message dailySummary = new MimeMessage(session);

			// set sender
			dailySummary.setFrom(new InternetAddress("ctravis096@gmail.com", "CD Blog Daily Summary"));

			
			// ADD ALL RECIPIENTS FROM DATASTORE			
			addRecipients(dailySummary, datastore);
			
			// get current date as string and set subject
			String curr_date = dateAsString();
			dailySummary.setSubject("CD Blog Daily Summarry: "+curr_date);
			
			
			// TODO: SET BODY TEXT
			String msgBody = "";
			boolean status = generateDailySummary(msgBody, datastore);
			dailySummary.setText(msgBody);
			System.out.println(dailySummary.getAllRecipients());
			
			
			if(status)
				Transport.send(dailySummary);	
			
			
		} catch (AddressException e ){
			// TODO Auto-generated catch block
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}


	private boolean generateDailySummary(String msgBody, DatastoreService datastore) {
		boolean status = false;
		msgBody.concat("Dear User,\nThe following is a summary of blog posts from the past 24 hours:\n");
		
		Query query = new Query("Post").addSort("date", Query.SortDirection.DESCENDING);
		Iterable<Entity> posts = datastore.prepare(query).asIterable();
		
		for(Entity e: posts) {
			Date date = (Date) e.getProperty("date");
			Date now = new Date();
			// if post if from  more than 24 hours ago we are finished
			if(now.getTime() - date.getTime() >= 86400000)
				break;
			status = true;
			msgBody.concat("\nFrom: " + (String) e.getProperty("user") + " on " + date.toString() + "\n");
			msgBody.concat((String) e.getProperty("title") + "\n");
			if(e.getProperty("content") instanceof Text) {
				Text t = (Text) e.getProperty("content");
				msgBody.concat(t.getValue() + "\n");
			}
			else {
				msgBody.concat((String) e.getProperty("content") + "\n");
			}
			

			
		}
		
		msgBody.concat("END OF EMAIL SUMMARY!");
		
		return status;
	}


	private void addRecipients(Message dailySummary, DatastoreService datastore) {
		Filter f = new FilterPredicate("subscribe", FilterOperator.EQUAL, true);
		Query q = new Query("Users").setFilter(f);
		PreparedQuery pq = datastore.prepare(q);			
		for(Entity e: pq.asIterable()) {
			User recipient = (User) e.getProperty("user");
			try {
				dailySummary.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient.getEmail(), recipient.getNickname()));
			} catch (UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (MessagingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		
	}


	private String dateAsString() {
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
		return sdf.format(cal.getTime());
	}
}