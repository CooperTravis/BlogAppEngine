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
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
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
			//dailySummary.addRecipient(Message.RecipientType.TO, new InternetAddress( "dterral504@gmail.com", "David Terral"));
			addRecipients(dailySummary, datastore);
			
			// get current date as string and set subject
			String curr_date = dateAsString();
			dailySummary.setSubject("CD Blog Daily Summarry: "+curr_date);
			

			
			
			// TODO: SET BODY TEXT
			String msgBody = "";
			
			
			boolean status = false;
			msgBody = msgBody.concat("Dear User,\nThe following is a summary of blog posts from the past 24 hours:\n");
			_logger.info(msgBody);
			
			Key blogKey = KeyFactory.createKey("Blog", "CDBlog");
			
			Query query = new Query("Post", blogKey).addSort("date", Query.SortDirection.DESCENDING);
			PreparedQuery pq = datastore.prepare(query);
			
			_logger.info("Query passed");
			
			
			for(Entity e: pq.asIterable()) {
				Date date = (Date) e.getProperty("date");
				_logger.info("Date was acquired");
				Date now = new Date();
				// if post is from  more than 24 hours ago we are finished
				if(now.getTime() - date.getTime() >= 86400000)
					break;
				status = true;
				
				// Getting user and date
				String u = (String) e.getProperty("user");
				String d = date.toString();
				msgBody = msgBody.concat("\nFrom: " + u + "\n" + d + "\n");
				
				// Getting title of post
				String title = (String) e.getProperty("title");
				msgBody = msgBody.concat("Title: " + title + "\n");
				
				// Gets the content of the post
				Text t = (Text) e.getProperty("content");
				String m = t.getValue();
				msgBody = msgBody.concat("Content: " + m + "\n");			
			}
			_logger.info("Daily summary generated");
			
			msgBody = msgBody.concat("\nEND OF EMAIL SUMMARY");
			
			_logger.info(msgBody);
			dailySummary.setText(msgBody);
			
			if(status) {
				Transport.send(dailySummary);
			}
			
			
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




	private void addRecipients(Message dailySummary, DatastoreService datastore) {
		_logger.info("AddRecipients");
		Filter f = new FilterPredicate("subscribed", FilterOperator.EQUAL, true);
		Key blogKey = KeyFactory.createKey("Blog", "CDBlog");
		Query q = new Query("Users", blogKey).setFilter(f);
		PreparedQuery pq = datastore.prepare(q);			
		for(Entity e: pq.asIterable()) {
			User recipient = (User) e.getProperty("user");
			_logger.info(recipient.getEmail());
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