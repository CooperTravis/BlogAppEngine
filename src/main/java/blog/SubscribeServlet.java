package blog;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.*;
import com.google.appengine.api.datastore.*;

@SuppressWarnings("serial")
public class SubscribeServlet extends HttpServlet {

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException {
	
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String blogName = req.getParameter("blogName");
		Key blogKey = KeyFactory.createKey("Blog", blogName);
		Entity u = new Entity("Users", blogKey);
		u.setProperty("user", user);
		u.setProperty("subscribed", true);
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    datastore.put(u);
		
	
	}
	
	

}
