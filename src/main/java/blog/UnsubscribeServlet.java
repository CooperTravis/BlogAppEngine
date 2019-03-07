package blog;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;

@SuppressWarnings("serial")
public class UnsubscribeServlet extends HttpServlet {

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		String blogName = req.getParameter("blogName");
		Key blogKey = KeyFactory.createKey("Blog", blogName);
		
		Filter f = new FilterPredicate("subscribed", FilterOperator.EQUAL, true);
		Query q = new Query("Users", blogKey).setFilter(f);
		PreparedQuery pq = datastore.prepare(q);
		
		for(Entity e : pq.asIterable()) {
			if(e.getProperty("user").equals(user)) {
				Key userKey = e.getKey();
				datastore.delete(userKey);
			}
		}
		
	    resp.sendRedirect("/landingpage.jsp?blogName=" + blogName);
		
	}
}