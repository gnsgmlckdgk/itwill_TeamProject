<%@page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="temp.MyPlanBean"%>
<%@page import="net.travel.admin.db.TravelBean"%>
<%@page import="net.myplanBasket.db.MyPlanBasketBean"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<!-- Header -->
<jsp:include page="../inc/header.jsp" />
<!-- 스타일 불러오기 -->
<link rel="stylesheet" href="assets/css/main.css" />
<link rel="stylesheet" href="assets/css/map/myplanModify.css" />
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<head>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
</head>
<script>

</script>
<body>
	<%
		List basketList = (List) request.getAttribute("basketList");
		List goodsList = (List) request.getAttribute("goodsList");
		String id = (String) session.getAttribute("id");

		int plan_nr = Integer.parseInt(request.getParameter("plan_nr"));
		
		String fromDate = (String) request.getParameter("fromDate");
		String toDate = (String) request.getParameter("toDate");
		System.out.println(fromDate);
         
/* 		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

		  Calendar cal = Calendar.getInstance();

		  try {
		   cal.setTime(sdf.parse(fromDate));
		  } catch (Exception e) {
		  }

		  int count = getDiffDayCount(fromDate, toDate);

		  // 시작일부터
		  cal.add(Calendar.DATE, -1);

		  // 데이터 저장
		  ArrayList<String> list = new ArrayList<String>();

		  for (int i = 0; i <= count; i++) {
		   cal.add(Calendar.DATE, 1);

		   list.add(sdf.format(cal.getTime()));
		  }

		  String[] result = new String[list.size()];

		  list.toArray(result);
 		 */
     
		/* 
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		
		Date d1 = df.parse(fromDate);
		Date d2 = df.parse(toDate);
		
		Calendar c1 = Calendar.getInstance();
		Calendar c2 = Calendar.getInstance();
		
		c1.setTime(d1);
		c1.setTime(d2);

		while(c1.compareTo(c2) !=1){
			
			System.out.printf("%tF\n", c1.getTime());
			
			c1.add(Calendar.DATE, 1);
		} 
		*/
		%>

		<!-- <form action="./MyPlanModifyAction.pln" method="post" ></form> -->
		<%-- <input type="text" name="plan_nr" value="<%=plan_nr%>"> --%>
		<div class="wrap">
			<div id="left_box1">
				<!-- box1 -->
				<ul id="left_box1_detail">
					<!-- myplanModify.css -->
					<li>[<%if (plan_nr == 1) {%>일정A<%}%><%if (plan_nr == 2) {%>일정B<%}%>]</li>
					<li><%=fromDate%>~<%=toDate%></li>
					<li>일정전체보기</li>
					<li><%=fromDate%></li>
			
				</ul>
			
				
			</div>
			<div id="left_box2">
				<!-- box2 찜 바구니-->
				<ul id="left_box2_detail">
					<li>1</li>
					<li>2</li>
					<li>3</li>
				</ul>
			</div>
			<div id="right_box">
				<!-- box3 도시 찜 버튼 -->
				<ul id="right_box_detail">
					<li>1</li>
					<li>2</li>
					<li>3</li>
				</ul>
			</div>
		</div>
</body>

<%-- 	
		<table border="1" >
					<tr>
						<td>plan_nr</td>
						<td>item_nr</td>
						<td>name</td>
					</tr>
				
					<%
						for (int i = 0; i < basketList.size(); i++) {
							MyPlanBasketBean mpbb = (MyPlanBasketBean) basketList.get(i);
							TravelBean tb = (TravelBean) goodsList.get(i);
						/* 	if (plan_nr != mpbb.getPlan_nr() & plan_nr != 100)
								continue; */
					%>
					<tr>
						<td><%=mpbb.getPlan_nr()%></td>
						<td><%=mpbb.getItem_nr()%></td>
						<td><%=tb.getName()%></td>
					</tr>
					<%
						}
					%>
		</table> --%>
<%-- <table border="1" class="tg" >
	<%if(plan_nr==1){%>일정A<%} %>
    <%if(plan_nr==2){%>일정B<%} %>
    <%if(plan_nr==3){%>일정C<%} %> 
	<% 	
	for(int i=0;i<basketList.size();i++){
	MyPlanBasketBean mpbb = (MyPlanBasketBean)basketList.get(i);
	TravelBean tb=(TravelBean)goodsList.get(i);
	if(mpbb.getId().equals(id)){
	if(mpbb.getPlan_nr()== plan_nr){
	%>
  	<tr>
    <th class="tg-031e" rowspan="2">
   	<%=mpbb.getDay_nr()%>째날
    </th>
    <th class="tg-031e">낮</th>
    <td class="tg-yw4l"></td>
	<td class="tg-yw4l"></td>
	<td class="tg-yw4l"></td>
	<td class="tg-yw4l"></td>
  	</tr>
 	<tr>
 	<th class="tg-yw4l">밤</th>
    <td class="tg-yw4l"></td>
    <td class="tg-yw4l"></td>
	<td class="tg-yw4l"></td>
	<td class="tg-yw4l"></td>
	</tr>
	<tr><td colspan="7"><input type="submit" value="일정수정">
	<input type="reset" value="다시등록"></td>
	</tr>
 	<%
	}
	}
	}
  	%>
</table> --%>
<div class="clear"></div>
<!-- Footer -->
<jsp:include page="../inc/footer.jsp" />
</html>