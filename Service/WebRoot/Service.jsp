<%@ page language="java" contentType="text/html; charset=GB2312"
    pageEncoding="GB2312"%>
<%@ page import="java.io.*" %>
<%@ page import="servant.QueryService" %>
	<jsp:useBean id="load" class="servant.QueryService" scope="request"></jsp:useBean>
	<% 			
		load.init(response);
		load.getInfo();
		out.clear();
		out=pageContext.pushBody();
	%>
