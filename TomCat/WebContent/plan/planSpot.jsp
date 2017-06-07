<%@page import="net.plan.db.PlanCityBean"%>
<%@page import="net.plan.db.PlanSouvenirBean"%>
<%@page import="net.plan.db.PlanTravelBean"%>
<%@page import="net.plan.db.PlanCountryBean"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="./assets/css/plan/planSpot.css"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<!--이미지 슬라이드 플러그인 -->
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/fotorama/4.5.1/fotorama.css" type="text/css" />
<script src="http://cdnjs.cloudflare.com/ajax/libs/fotorama/4.5.1/fotorama.js"></script>


<!-- 헤더 -->
<jsp:include page="../inc/header.jsp" />
<%
	//추천장소 정보
	PlanTravelBean ptb = (PlanTravelBean)request.getAttribute("ptb");
	
	//도시이름 가져오기
	PlanCityBean pcb = (PlanCityBean)request.getAttribute("pcb");
	
	//선물리스트 가져오기
	List souvenirList = (List)request.getAttribute("souvenirList");
	
	//아이디 
	String id =(String)session.getAttribute("id");
%>

<script type="text/javascript">
var toggleBtn = 0;
	$(document).ready(function(){

		$('input.month').click(function(){
			$('input.month').css('background-color','#323037');//진한회색	
			$(this).css('background-color','#f32853');//핑크색
			var month=$(this).val();
			//다른 월 선택시 부르기
			$.ajax({
				type:'post',
				url:'./plan/travelStyle.jsp',
				data:{month : month, city_name:'<%=pcb.getName()%>'},
				success:function(data){
					$('div.month_img').empty(data);
					$('div.month_img').append(data);
				},
				error:function(xhr, status, error){
					alert(error);
				}
			});
		});
		$('.blog_Spot').click(function(){
			$('.Spot_epilogue').css('background-color','#323037');
			$(this).css('background-color','#f32853');
			$('#Spot_epilogue').css('display','none');
			$('#daumBlog').css('display','block');
		});
		
		$('.Spot_epilogue').click(function(){
			$('.blog_Spot').css('background-color','#323037');
			$(this).css('background-color','#f32853');
			$('#daumBlog').css('display','none');
			$('#Spot_epilogue').css('display','block');
		
			
		});
		
		$('#writeBtn').click(function(){
			if(toggleBtn==0) {
				$('.reviewWriterDiv').removeClass('animated fadeOutUp').addClass('animated fadeInDown');
				$('.reviewWriterDiv').css('display', 'inline-block');
				
				toggleBtn = 1;
			}else {
				$('.reviewWriterDiv').removeClass('animated fadeInDown').addClass('animated fadeOutUp');
				setTimeout(function(){
					$('.reviewWriterDiv').hide();
				}, 700)
				toggleBtn = 0;
			}
		});
		

		/* 최초 리뷰 리스트 가져오기 */
		$.ajax({
			type: 'post',
			url: './plan/planComment/planSpotCommentList.jsp',
			data : {spot:'<%=ptb.getName()%>'},
			success: function(data) {
				$('div.comment .review_list').empty();
				$('div.comment .review_list').append(data);
			},
			error: function(xhr, status, error) {
				alert(error);
		    } 
		});
		
	});

	/* 처음 화면 */
	$(window).load(function(){
		$(document).ready(function(){
			//처음에 1월 자동선택
			$('input#first').css('background-color','#f32853');
			$('.blog_Spot').css('background-color','#f32853');
			$('#Spot_epilogue').css('display','none');
			$('#daumBlog').css('display','block');
		});
		$.ajax({ //1월 검색값 불러오기(월, 도시이름 넘겨줌)
			type:'post',
			url:'./plan/travelStyle.jsp',
			data:{month:'1월', city_name:'<%=pcb.getName()%>'},
			success:function(data){
				$('div.month_img').append(data);
			},
			error:function(xhr, status, error){
				alert(error);
			}
		});
	});
	
</script>

<!-- include jQuery library -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<!-- include Cycle plugin -->
<script type="text/javascript" src="http://malsup.github.com/jquery.cycle.all.js"></script>




<div class="clear"></div>
<!-- 본문 -->
<section class = "planSpot">
<h2>
	<%=ptb.getName() %><span><%=ptb.getAddress() %></span>

<!-- 찜하기 -->
	<img alt="찜하기" src="./images/Spot/plus.png" title="이장소 찜하기">
	
</h2>


<!-- 장소 이미지(임시 이미지) -->

<div class="img_info">
	<div class="travel_img" >
 		<img alt="임시이미지" src="./images/pic02.jpg" width="450px">
 	</div>
	

<!-- 추가정보(검색설명) -->
<div class="tr_info" style="">지도</div>

</div>

<div class="clear"></div>

<!-- 장소 설명(db에서 받아온 설명) -->
<h1>&nbsp▶&nbsp<%=ptb.getInfo() %></h1>

<!-- 월별 옷차림(검색) -->

<h3>월별 옷차림 &nbsp<span>계절에 맞는 이 지역 코디를 검색해 보세요</span></h3>
<div class="All_mon">
<input type="button"  value="1월" class="month" id="first">
<input type="button" value="2월" class="month">
<input type="button" value="3월" class="month" >
<input type="button" value="4월" class="month" >
<input type="button" value="5월" class="month" >
<input type="button" value="6월" class="month">
<input type="button" value="7월" class="month" >
<input type="button" value="8월" class="month" >
<input type="button" value="9월" class="month">
<input type="button" value="10월" class="month" >
<input type="button" value="11월" class="month">
<input type="button" value="12월" class="month" > 
</div>
<div class="clear"></div>

<div class="month_img">

</div>
<div class="clear"></div>

<!-- 선물리스트(1위 2위 3위)(db에서 받아오기) -->

<h3>선물 리스트</h3>
<!-- <img alt="이전" src="./images/Spot/arrow2.png"> -->

<%
	for(int i=0; i<souvenirList.size();i++){
		PlanSouvenirBean psb = (PlanSouvenirBean)souvenirList.get(i);
	%>
	<div style="">
	
	<table class="souvenir" style="float: left; width: 300px; margin-right: 50px; border: none; height: ">
		
			<tr style="background: none; border: none"><td style="text-align: center;"><%=psb.getName() %></td></tr>
			<tr style="background: none; border: none"><td style="text-align: center;"><img alt="" src="./upload/<%=psb.getImg()%>" width="200" height="200"></td></tr>
			<tr style="background: none; border: none"><td style="text-align: center;"><%=psb.getInfo() %></td></tr>
		
	</table>
	
	</div>
	<%
	}
%>
<!-- <img alt="이후" src="./images/Spot/arrow.png">
 -->


<!-- 장소에 대한 후기 작성(시간나면) -->
<div class="clear"></div>

<div class="blog_epil">
<div class="blog_Spot"><span class="text">블로그 정보</span></div>
<div class="Spot_epilogue"><span class="text"><%=ptb.getName()%> 여행 후기</span></div>
<div class="clear"></div>
<script src="./assets/js/plan/planSpotSearch.js"></script>
<div id="daumForm" style="display: none;">
    	<input id="daumSearch" type="hidden" value="<%=pcb.getName()%> 여행 <%=ptb.getName() %>" onkeydown="javascript:if(event.keyCode == 13) daumSearch.search();"/>
	</div>
	
       <div id="daumBlog" style="display:none;"></div> <!-- 블로그 후기 나타나는 div -->
		
		
		<!-- 후기 작성 추가 -->
		<div id="Spot_epilogue" style="width: 1000px; height: 500px;">
			<div class="comment">
				<div class="comment_right">
					<%
					if(id!=null){
					%>
					<input type="button" value="리뷰쓰기" id="writeBtn" class="button alt writeBtn">
					<%
					}
					%>
					<!-- 숨겨진 공간 -->
				<div class="reviewWriterDiv">
					<form action="javascript:writeComplete()" method="post">
						<select id="eval">
							<option value="-1" style="font-weight: 900; color: #6B66FF">평가하기</option>
							<option value="1" style="color: orange;">좋아요!</option>
							<option value="2" style="color: blue;">괜찮아요.</option>
							<option value="3" style="color: red;">별로에요!</option>
						</select>
						<textarea rows="5" cols="5" maxlength="1000" name="content"></textarea>
						<div class="formBtnDiv">
							<input type="submit" value="작성완료" class="submitBtn"> <input
								type="reset" value="다시쓰기" class="resetBtn">
						</div>

					</form>

				</div>
				<!-- 리뷰작성 div(숨겨진 공간) -->
				
				<%
			if(id==null) {
			%>
			<div class="comment_member">	<!-- 로그인, 회원가입 DIV -->
				<span>도움이 필요하신가요?<br>로그인하여 커뮤니티에 참여해 보세요!</span><br>
				<div class="comment_member_btn">
					<input type="button" value="로그인" onclick="popupToggle()">
					<input type="button" value="회원가입" onclick="location.href='./MemberJoin.me';">
				</div>
			</div>	<!-- .comment_member -->
			<%
			}
			%>	
		</div>	<!-- .comment_right -->
		
	<div class="clear"></div>
	</div>	<!-- .comment -->

			</div>
		<!-- 후기작성 스크립트 -->	
			<script type="text/javascript">

		/* 
			$(document).ready(function(data){
				/* 리뷰 작성 버튼 
				
			});
			 */
			/* 리뷰 작성완료 DB작업 */
			function writeComplete() {
				var con = $('textarea').val();
				var sel = $('#eval').val();
				if(con.length == 0) {
					alert("글을 입력해주세요.");
					return;
				}
				if(sel == -1) {
					alert("평가하기를 해주세요.");
					return;
				}
				
				$.ajax({
					type: 'post',
					url: './plan/planComment/planSpotCommentWrite.jsp',
					data : {spot:'<%=ptb.getName()%>', content : con, eval : sel},
					async: false,
					success: function(data) {
						$('textarea').val('');
						$('.reviewWriterDiv').css('display', 'none');
						toggleBtn = 0;
					},
					error: function(xhr, status, error) {
						alert(error);
				    } 
				});
				
				regionCommentList(1);
			}
			
			/* 페이징 변경이나 다른 작업 후 다시 리뷰 리스트를 로딩할때 */
			function spotCommentList(pageNum) {
				$.ajax({
					type: 'post',
					url: './plan/planComment/planSpotCommentList.jsp',
					data : {spot:'<%=ptb.getName()%>', pageNum : pageNum},
					success: function(data) {
						$('div.comment .review_list').empty();
						$('div.comment .review_list').append(data);
					},
					error: function(xhr, status, error) {
						alert(error);
				    }
				});
			}
			
			</script>
			
			</div>

	<div id="daumBlogScript"></div>





</section>
<div class="clear"></div>

<%-- <!-- footer -->
<jsp:include page="../inc/footer.jsp" /> --%>