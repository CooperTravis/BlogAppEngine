package blog;

// Data Store imports
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class CreateBlogPost extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws IOException{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		
		// NEWEST UPDATE
		String blogName = req.getParameter("blogName");
		Key blogKey = KeyFactory.createKey("Blog", blogName);
		Text content = new Text(req.getParameter("content"));
		String title = req.getParameter("title");
		Date date = new Date();
		Entity blogPost = new Entity("Post", blogKey);
		blogPost.setProperty("user", user.getNickname());
		blogPost.setProperty("date", date);
		blogPost.setProperty("title", title);
		blogPost.setProperty("content", content);
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		datastore.put(blogPost);
		
	
		resp.sendRedirect("/landingpage.jsp?blogName=" + blogName);
		
	}

}
