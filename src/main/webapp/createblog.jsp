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
	<title>Create A Post</title>
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
%>
<!-- ********************************************************** -->


<form action="/create" method="post">
  <div class="form-group">
    <label for="exampleFormControlInput1">Post Title:</label>
    <input name="title" type="text" class="form-control" placeholder="Title" required>
  </div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">Post Content:</label>
    <textarea name="content" class="form-control" id="exampleFormControlTextarea1" rows="20" required></textarea>
  </div>
<!-- </form>

<form action="/create" method="post">
	<div class="form-group">
		<label>Post Title:</label>
		<textarea name="title" rows="1" cols="60">Title</textarea>
	</div>
	<div class="form-group">
		<label>Post Content:</label>
		<textarea name="content" rows="30" cols="60">Content</textarea>
	</div> -->
	<div class="form-group">
		<button class="btn btn-primary" type="submit">Post Blog</button>
	</div>
	<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
</form>

	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

</div>
</body>
</html>