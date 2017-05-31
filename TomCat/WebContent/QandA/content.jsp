<%@page import="net.QandA.db.QandADAO"%>
<%@page import="net.QandA.db.QandABean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 
 <script type="text/javascript">
 function func1(){alert("정말 삭제하시겠습니까?");}

 
 </script>
   
<!-- Header -->
<jsp:include page="../inc/header.jsp" />
<link rel="stylesheet" href="./assets/css/QandA/content.css"/>	
<%
String id = (String)session.getAttribute("id");			// 아이디
String nick = (String)session.getAttribute("nick");	// 닉네임
QandABean qb = (QandABean) request.getAttribute("qb");
QandADAO qdao=new QandADAO();
int num=((Integer)request.getAttribute("num")).intValue();
String pageNum = request.getParameter("pageNum");

qdao.updateReadCount(num);//조회수 1증가 시켜주는 메소드 호출~

//엔터키 \r\n => <br>로 바꾸기
String content=qb.getContent();
if(content!=null){
content=qb.getContent().replace("\r\n","<br>");
}

%>

<h1>Q&A</h1>

<table>
<tr><td><%=qb.getSubject() %></td><td><%=qb.getNick() %></td><td><%=qb.getDate() %></td></tr>
<tr><td colspan="3"><%=qb.getContent() %></td></tr>
<tr><td colspan="3">
		<%if(qb.getNick().equals(nick)){%>	
	<input type="button" value="글수정" onclick="location.href='./QandAUpdate.qna?num=<%=qb.getNum()%>&pageNum=<%=pageNum%>'">
				<form action="./QandADeleteAction.qna" method="post" name="fr" onclick="func1()">					
					<input type="hidden" value="<%=num%>" name="num"> 															
					<input type="hidden" value="<%=pageNum%>" name="pageNum">					
					<input type="submit" value="글삭제">
				</form>
<%} %>
<input id="listbutton" type="button" value="글목록 " onclick="location.href='./QandAList.qna?pageNum=<%=pageNum%>'">		
		<%if(nick!=null){%>	

<input type="button" value="답글" 
onclick="location.href='./QandAReplyWrite.qna?pageNum=<%=pageNum%>&num=<%=num%>&re_ref=<%=qb.getRe_ref()%>&re_lev=<%=qb.getRe_lev()%>&re_seq=<%=qb.getRe_seq()%>'">

<%
System.out.println("ref의 값"+qb.getRe_ref());
		} %>

</td></tr>
</table>
	
<!-- Footer -->
<jsp:include page="../inc/footer.jsp" />