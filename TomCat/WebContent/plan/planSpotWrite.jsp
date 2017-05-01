<%@page import="com.sun.xml.internal.bind.v2.runtime.Location"%>
<%@page import="sun.nio.cs.HistoricallyNamedCharset"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");

	String id = (String) session.getAttribute("id");
	String nick = (String) session.getAttribute("nick");
	String region = (String) request.getParameter("region");
	Date now = new Date();
%>
<!-- Header -->
<jsp:include page="../inc/header.jsp" />

<!-- Banner -->
<section id="banner">
	<h2><%=region%>의 맛집, 관광지, 숙소를 추천하는 공간입니다.
	</h2>
	<p>
		세션값 확인하고 회원만 들어올 수 있도록 할 것. 현재는 비회원은 null으로. <br> 현재 session의 id는
		<%=id%>, nick은
		<%=nick%>입니다.<br>
		가게명만으로 위치값을 구글맵에 정확히 뿌릴 수 있는가?
	</p>
	<br>

	<!-- 입력란 들어갈 곳. -->
	<form action="./PlanSpotWriteAction" method="post" enctype="multipart/form-data">
		<table
			style="width: 80%; margin: auto; background-color: white; opacity: 0.85; border-radius: 20px;">
			<tr>
				<td>작성자 : <input type="text" value="<%=nick%>" name="nick"
					readonly="readonly" /></td>
				<td>작성일 : <input type="text" value="<%=now%>" name="date"
					readonly="readonly" /></td>
				<td>작성시간 : <input type="text" value="<%if(region!=null){ %><%=region%><%} else {} %>"
					name="region" readonly="readonly" /></td>
			</tr>
			
			<tr>
				<td>국가 : <select name="nation">
					<option value="kr">한국 kr 맞는가??</option>
					<option value="jp">일본 jp 맞는가?</option>
				</select></td>
				<td>지역 : <select name="region">
					<option value="test">test</option>
				</select></td>
				<td>
					분류 : <select name="type">
						<option value="맛집">맛집</option>
						<option value="관광지">관광지</option>
						<option value="숙소">숙소</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<td colspan="3">가게명 같은게 있어야 하지 않을까? 현재 db에 없음.<input type="text" name="test"></td>
			</tr>
			
			<tr>
				<td colspan="3">메인 이미지 : <input type="file" name="file1"></td>
			</tr>
			<tr>
				<td colspan="3">이미지 2 : <input type="file" name="file2"></td>
			</tr>
			<tr>
				<td colspan="3">이미지 3 : <input type="file" name="file3"></td>
			</tr>
			
			<tr>
				<td colspan="3">작성란<br>
				<textarea rows="10" cols="10"></textarea></td>
			<tr>
		</table>

		<br>


		<ul class="actions">
			<li><input type="submit" value="작성완료" class="button special"></li>
			<li><input type="reset" value="RESET"></li>
		</ul>


	</form>
	<!-- 입력란 들어갈 곳. 끝. -->

</section>




<!-- Footer -->
<jsp:include page="../inc/footer.jsp" />