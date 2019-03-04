package blog;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;
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
		
		Properties props = new Properties();							// ****
		Session session = Session.getDefaultInstance(props, null);		// ****
		
		try {
			// create new message object
			Message dailySummary = new MimeMessage(session);
			// set sender *******ADD REAL WEBSITE ADDRESS*******
			dailySummary.setFrom(new InternetAddress("admin@ee461lhw6blog.appspot.com", "CD Blog Admin"));
			// ADD ALL RECIPIENTS FROM DATASTORE WITH dailySummary.addRecipient();
			// TODO
			// get current date as string and set subject
			String curr_date = dateAsString();
			dailySummary.setSubject("CD Blog Daily Summarry: "+curr_date);
			
			
			// TODO: SET BODY TEXT
			
			
			
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


	private String dateAsString() {
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
		return sdf.format(cal.getTime());
	}
}