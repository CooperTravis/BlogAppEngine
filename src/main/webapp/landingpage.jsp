<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
<meta charset="UTF-8">
<title>Blog</title>
</head>
<body>
<%
	
	/*
	Setting the name of our blog?
	*/
	String blogName = request.getParameter("blogName");
	if(blogName == null){
		blogName = "CDBlog";
	}
	pageContext.setAttribute("blogName", blogName);

	
	
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if(user != null){
		pageContext.setAttribute("user", user);
		
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign out</a>.)</p>
<form action="/subscribe" method="post">
	<div><input type="submit" value="Subscribe"></div>
</form>
<%
	} else{
%>
<p>Hello!
<a href="<%=userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to create your own blog entries.</p>
<%
	}
%>

<%

	// Setting up the datastore
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key blogKey = KeyFactory.createKey("Blog", blogName);
	
	// Queries the blog posts so you it will only show the 5 most recent
	// Make a function from a button that changes the variable of withLimit?
	Query query = new Query("Post", blogKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	if(posts.isEmpty()){
		%>
		<p>${fn:escapeXml(blogName)} has no posts.</p>
		<%
	}
	else{
		%>
		<p>Recent posts in ${fn:escapeXml(blogName)}.</p>
		<%
		for(Entity post: posts){
			pageContext.setAttribute("post_title", post.getProperty("title"));
			pageContext.setAttribute("post_content", post.getProperty("content"));
			pageContext.setAttribute("post_user", post.getProperty("user"));
			pageContext.setAttribute("post_time", post.getProperty("date"));
			%>
			<p><b>${fn:escapeXml(post_title)}</b></p>
			<p>${fn:escapeXml(post_user)}</p>
			<p>${fn:escapeXml(post_time)}</p>
			<p>${fn:escapeXml(post_content)}</p>
			<%
		}
	}
		
%>

<!-- Need this to be the blog creation link -->
<form action="/create" method="post">
	<div><textarea name="title" rows="1" cols="60">Title</textarea></div>
	<div><textarea name="content" rows="30" cols="60">Content</textarea></div>
	<div><input type="submit" value="Post Blog"></div>
	<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
</form>


</body>
</html>