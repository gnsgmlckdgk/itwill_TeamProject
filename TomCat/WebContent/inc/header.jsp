<%@page import="net.member.db.MemberDAO"%>
<%@page import="net.member.db.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Before you go</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		
		<!-- Scripts -->
		<script src="./assets/js/jquery.min.js"></script>
		<script src="./assets/js/skel.min.js"></script>
		<script src="./assets/js/util.js"></script>
		<script src="./assets/js/main.js"></script>
			
			<!-- RSA -->
			<script type="text/javascript" src="./assets/js/rsa/jsbn.js"></script>
        	<script type="text/javascript" src="./assets/js/rsa/rsa.js"></script>
       		<script type="text/javascript" src="./assets/js/rsa/prng4.js"></script>
       		<script type="text/javascript" src="./assets/js/rsa/rng.js"></script>
        	
		<!-- 스타일 불러오기 -->
		<link rel="stylesheet" href="./assets/css/main.css"/>
		<link rel="stylesheet" href="./assets/css/animate/animate.min.css"/>	<!-- 애니메이트 css -->
		
		<!-- 추가한 css -->
			<!-- member -->
			<link rel="stylesheet" href="./assets/css/member/join.css"/>
			<link rel="stylesheet" href="./assets/css/member/loginPop.css"/>
			<link rel="stylesheet" href="./assets/css/member/memberManager.css?ver=7"/>
			
			<!-- plan -->
			<link rel="stylesheet" href="./assets/css/plan/planMain.css"/>
			
		<!-- 추가한 js(스트립트는 태그 id나 명이 겹칠수 있어서 사용하는 jsp파일에서 외부 스크립트를 불러오게 하는게 좋을거 같아요.) -->
			<!-- member -->
			<script type="text/javascript" src="./assets/js/member/loginPop.js"></script>	<!-- 로그인 스크립트 -->
			<script type="text/javascript" src="./assets/js/member/memberManager.js"></script>	<!-- 정보관리 팝업 스크립트 -->
			
			<!-- plan -->
			<script type="text/javascript" src="./assets/js/plan/planMain.js"></script>
			
	</head>
	
<body>

<%
	// 세션값 가져오기
	String id = (String)session.getAttribute("id");			// 아이디
	String nick = (String)session.getAttribute("nick");	// 닉네임
%>

<!-- Header -->
<header id="header">
	<h1>
		<a href="./Main.me"><strong>Before</strong> you go...</a>
	</h1>
	
	<nav id="nav" style="font-family: '나눔고딕' , '맑은고딕', sans-serif; " >
		<ul>
			<li><a href="generic.html">함께해요</a></li>
			<li><a href="./PlanMain.pl">여행일정플래너</a></li>
			<li><a href="elements.html">여행일정Q&A</a></li>
			<li><a href="elements.html">인생샷그램</a></li>
			<%
			if(id==null){ %>
				<li><a onclick="popupToggle()" class="login_txt">로그인/회원가입</a></li>
			<%}else { %>
					<li><a class="memberInfoMenuTxt login_txt"><%=nick %></a></li>
				<%} %>
		</ul>
	</nav>
</header>

<a href="#menu" class="navPanelToggle"><span class="fa fa-bars"></span></a>


<!-- 로그인 팝업 창 -->
<%
	// 아이디, 비밀번호 입력 후 틀렸을때 다시 팝업창 띄우기 위해 변수 생성
	String loginCheckStr = request.getParameter("loginCheck");
	int loginCheck;
	if(loginCheckStr!=null) {
		loginCheck = Integer.parseInt(loginCheckStr);
	}else {
		loginCheck = 1;
	}
	if(loginCheck==0 || loginCheck==-1) {
		%>
			<script type="text/javascript">
				popupToggle();
			</script>
		<%
	}
%>

<!-- 로그인 팝업창 뜰때 배경 -->
<div id="loginPopContainer" onclick="popupToggle()"></div>
<!-- 로그인 팝업창 -->
<div id="loginPop">
	<form action="./MemberLoginAction.me" post="post" name="login_form" id="login_form" onsubmit="return validateEncryptedLoginForm()">
		
		<input type="email" name="id_login" id="id_login"  placeholder="이메일을 입력하세요." >
		<input type="password" name="pass_login" id="pass_login" placeholder="비밀번호를 입력하세요."><br>

		<input type="submit" class="button special loginBtn" value="로그인" >
		
		<div id="login_txt">
			<a onclick="idFinderPopup();" ><span class="login_txt">아이디 찾기</span></a> || 
			<a onclick="passFinderPopup();"><span class="login_txt">비밀번호 찾기</span></a><br>
		</div>
		
		<br>
		아직 아이디가 없으십니까? <a href="./MemberJoin.me" onclick="popupToggle()">회원가입</a>
		
	</form>	
</div>

<!-- 회원관리/로그아웃 선택 팝업 메뉴 -->
<%
	if(nick!=null) {	// 로그인 되어 있을때만
			MemberDAO mdao = new MemberDAO();
			MemberBean mb = mdao.getMember(id);
			String profile = mb.getProfile();
		%>
		<div class="memberManagerNavPopupToggle" style="display:none;"></div>	<!-- 애니메이트 이벤트 토글 하기 위해 만든것, 화면에 출력 안됨 -->
			<div class="memberManagerNav">
			
			<%
				// 기본 프로필 사진 임시로 일단 이거 쓸게요...
				String profileImage;
				if(profile==null) {	// 설정한 프로필 사진이 없으면
						if(mb.getGender().equals("남")) {
							profileImage = "./images/member/남자 기본 프로필.png";
							
						}else {	// 성별: 여
							profileImage = "./images/member/여자 기본 프로필.png";
						}
					%>
					<img src="<%=profileImage %>"  width="100px" height="100px"><!-- 프로필 사진 -->
					<%
				}else {	// 설정한 프로필 사진이 있으면
					%>
					<img src="http://placehold.it/100x100"  width="100px" height="100px"><!-- 프로필 사진 -->
					<%
				}
			%>
				<ul>
					<li><a href="./MemberInfo.me">정보관리</a></li>
					<li><a href="./MemberLogout.me">로그아웃</a></li>
				</ul>
			</div>
		<%	
	}
%>













