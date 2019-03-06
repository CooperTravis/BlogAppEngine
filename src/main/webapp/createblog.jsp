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
<title>Insert title here</title>
</head>
<body>
<h1>
<img align="right" src="/pictures/austin-texas-state-capitol-panorama-paul-velgos.jpg" width="100%">
</h1>

<h2>CDBlog: A Blog dedicated to local events in and around the Austin Area!</h2>

<%
	
	/*
	Setting the name of our blog?
	*/
	String blogName = request.getParameter("blogName");
	if(blogName == null){
		blogName = "CDBlog";
	}
	pageContext.setAttribute("blogName", blogName);

		
%>

<form action="/create" method="post">
	<div><textarea name="title" rows="1" cols="60">Title</textarea></div>
	<div><textarea name="content" rows="30" cols="60">Content</textarea></div>
	<div><input type="submit" value="Post Blog"></div>
	<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
</form>

</body>
</html>