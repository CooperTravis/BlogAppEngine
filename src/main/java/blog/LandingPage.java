package blog;

import java.io.IOException;
import javax.servlet.http.*;

// Includes the login services from Google
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.users.UserService;

@SuppressWarnings("serial")
public class LandingPage extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse resp) 
		throws IOException{
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		if(user != null) {
			
			resp.setContentType("text/plain");
			resp.getWriter().println("Hello " + user.getNickname());
			
		}
		
		else {
			
			resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
			
		}
		
		
	}

}
