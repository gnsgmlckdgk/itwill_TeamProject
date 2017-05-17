<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<!-- 스타일 추가 -->
<!-- 이클립스에서 서버가 인식을 잘안하는게 불편해서 여기서 다 만들고 따로 외부파일로 만들 예정 -->
<style type="text/css">
	
	div.DBManager a {
		text-decoration: none;
	}

</style>

</head>
<body>
<!-- Header -->
<jsp:include page="../inc/header.jsp" />
	
<!-- Main -->
<section id="main" class="wrapper">
	<div class="container">
		<!-- 서브메뉴 -->
		<jsp:include page="subMenu/memberManager.jsp"/>
		
		<!-- 컨텐츠 -->
		<div class="content DBManager">
			<h2>DB 통합 관리</h2><hr>
			
				<a href = "javascript:countryInput()">국가 DB 관리</a><br>
				
				<a href = "javascript:cityInput()">도시(지역) DB 관리</a><br>
				
				<a href = "javascript:travelInput()">여행지 DB 입력</a><br>
					
			</div>	<!-- content -->	
		</div>	
	
		<!-- 스크립트 추가 -->
		<script type="text/javascript">
			
			function countryInput() {
				window.open("./CountryList.pl", "window", "width=1200, height=800, top=100, left=300");
			}
			
			function cityInput() {
				window.open("./CityList.pl", "window", "width=1400, height=800, top=100, left=200");
			}
			
			function travelInput() {
				window.open("./TravelAdmin.td", "window", "width=1200, height=800, top=100, left=300");
			}
	
		</script>
	
</section>

<!-- Footer -->
<div class="clear"></div>
<jsp:include page="../inc/footer.jsp" />
</body>
</html>