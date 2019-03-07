<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Text" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	<title>Blog</title>
</head>

<body>
<div class="container">

<!-- Web page image -->
	<h1><img align="right" src="/pictures/austin-texas-state-capitol-panorama-paul-velgos.jpg" width="100%"></h1>

<!-- TITLE CONTAINER -->
	<div>
		<h4>CDBlog - The latest on local events in Austin Area!</h4>
	</div>


<!-- ********************************************************** -->
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
<!-- ********************************************************** -->



<p align="right">
	Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign out</a>.)</p>

<%-- <form method="get" action="<%=userService.createLogoutURL(request.getRequestURI())%>">
	<button class="btn btn-primary">Sign Out</button>
</form> --%>

<div align="right">
<form action="/subscribe" method="post" style="display:inline-block;">
	<div align="right">
		<button class ="btn btn-primary" title="subscribe to receive a daily summary of blog posts">Subscribe</button>
	</div>
	<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
</form>

<form action="/createblog.jsp" style="display:inline-block;">
	<div align="right">
		<button class ="btn btn-primary" type="submit">Create a Post</button>
	</div>
</form>
</div>


<!-- ********************************************************** -->
<%
	} else{
%>
<!-- ********************************************************** -->


<p align="right">Hello!
<a href="<%=userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to create your own blog entries.</p>



<!-- ********************************************************** -->
<%
	}

	// Setting up the datastore
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key blogKey = KeyFactory.createKey("Blog", blogName);
	
	String showAll = request.getParameter("showAll");
	if(showAll == null){
		showAll = "False";
	}
	pageContext.setAttribute("showAll", showAll);
	
	if(showAll == "False"){
	
	
	// Queries the blog posts so you it will only show the 5 most recent
	// Make a function from a button that changes the variable of withLimit?
		Query query = new Query("Post", blogKey).addSort("date", Query.SortDirection.DESCENDING);
		List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
		if(posts.isEmpty()){
%>
<!-- ********************************************************** -->



	<p>The blog is empty.  Click 'Create a Post' to write the first blog!</p>			
			
			
			
<!-- ********************************************************** -->
<%
		}
		else{
%>
<!-- ********************************************************** -->

			
<!-- ********************************************************** -->			
<%
			for(Entity post: posts){
				pageContext.setAttribute("post_title", post.getProperty("title"));
				String content = "";
				if(post.getProperty("content") instanceof Text){
					Text t = (Text) post.getProperty("content");
					content = t.getValue();
				}
				else{
					content = (String) post.getProperty("content");
				}
				pageContext.setAttribute("post_content", content);
				pageContext.setAttribute("post_user", post.getProperty("user"));
				pageContext.setAttribute("post_time", post.getProperty("date"));
%>
<!-- ********************************************************** -->


				
			<div class="container">
				<h3>${fn:escapeXml(post_title)}</h3>
				<p>Posted by: ${fn:escapeXml(post_user)} on ${fn:escapeXml(post_time)}</p>
				<p>${fn:escapeXml(post_content)}</p>
			</div>		
				
<!-- ********************************************************** -->				
<%
			}			
%>
<!-- ********************************************************** -->



			<form action="/landingpage.jsp">
				<div align="center">
					<button class="btn btn-primary" type="submit">Show All Posts</button>
				</div>
				<input type="hidden" name="showAll" value="True"/>
			</form>
			
			
<!-- ********************************************************** -->
<% 
			
		}
	}
	else{
		Query query = new Query("Post", blogKey).addSort("date", Query.SortDirection.DESCENDING);
		List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5000));
		if(posts.isEmpty()){
%>
<!-- ********************************************************** -->


			<p>${fn:escapeXml(blogName)} has no posts.</p>


<!-- ********************************************************** -->
<%
		}
		else{
%>
<!-- ********************************************************** -->


			<p>Recent posts in ${fn:escapeXml(blogName)}.</p>
			
			
<!-- ********************************************************** -->			
<%
			for(Entity post: posts){
				pageContext.setAttribute("post_title", post.getProperty("title"));
				String content = "";
				if(post.getProperty("content") instanceof Text){
					Text t = (Text) post.getProperty("content");
					content = t.getValue();
				}
				else{
					content = (String) post.getProperty("content");
				}
				pageContext.setAttribute("post_content", content);
				pageContext.setAttribute("post_user", post.getProperty("user"));
				pageContext.setAttribute("post_time", post.getProperty("date"));
%>
<!-- ********************************************************** -->


			<div class="container">
				<h3>${fn:escapeXml(post_title)}</h3>
				<p>Posted by: ${fn:escapeXml(post_user)} on ${fn:escapeXml(post_time)}</p>
				<p>${fn:escapeXml(post_content)}</p>
			</div>	

				<%-- <p><b>${fn:escapeXml(post_title)}</b></p>
				<p>${fn:escapeXml(post_user)}</p>
				<p>${fn:escapeXml(post_time)}</p>
				<p>${fn:escapeXml(post_content)}</p> --%>
				
				
<!-- ********************************************************** -->
<%
			}
%>
<!-- ********************************************************** -->


			
			<form action="/landingpage.jsp">
				<div align="center">
					<button class="btn btn-primary" type="submit">Show Less</button>
				</div>
			</form>
			
			

<!-- ********************************************************** -->			
<%
		}		
	}
%>
<!-- ********************************************************** -->


	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</div>
</body>
</html>