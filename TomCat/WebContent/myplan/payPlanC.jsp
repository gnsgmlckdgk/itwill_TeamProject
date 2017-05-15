<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- Header -->
<jsp:include page="../inc/header.jsp" />

<!-- Banner -->
<section id="banner">

	<!-- 입력란 들어갈 곳. -->

	<link rel="stylesheet" href="assets/css/myplan/payPlanC.css" />
	<link rel="stylesheet" href="assets/css/main.css" />
	<script src="assets/js/jquery.min.js"></script>



	<%
		String id = (String) session.getAttribute("id");
		String nick = (String) session.getAttribute("nick");

		int gold_price = 97000;
		int discount_price = 0;
		int send_fee = 3000;
	%>

	<h2>결제</h2>
	<form action="./PayAction.pln" method="post">
		<!-- 왼쪽 배송 장소 및 수단 선택 공간. -->

		<div>
			<h4>결제하실 정보</h4>
			<table>
				<tr>
					<th>선택사항</th>
					<th>상품금액</th>
					<th>수량</th>
					<th>할인</th>
					<th>할인금액</th>
					<th>주문금액</th>
					<th>배송정보</th>
				</tr>
				<tr>
					<td>일정C</td>
					<td><%=gold_price%>원</td>
					<td>1</td>
					<td>-</td>
					<td><%=discount_price%>원</td>
					<td><b><%=gold_price - discount_price%>원</b></td>
					<td><%=send_fee%>원</td>
				</tr>
			</table>
			<br>

			<h4>배송 정보</h4>
			<table>
				<tr>
					<th>주문하시는 분</th>
					<td>
						<table class="innerTable">
							<tr>
								<td>이름</td>
								<td><input type="text" name="name" value="db에서받아오는값."
									readonly="readonly"></td>
							</tr>
							<tr>
								<td>이메일</td>
								<td><input type="text" name="email" value="<%=id%>"
									readonly="readonly"></td>
							</tr>
							<tr>
								<td>휴대폰 번호</td>
								<td><input type="text" name="phone_number"
									value="db에서받아오는값." readonly="readonly"></td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<th>받으시는 분</th>
					<td>
						<table class="innerTable">
							<tr>
								<td>이름</td>
								<td><input type="text" name="name"></td>
							</tr>
							<tr>
								<td>휴대폰 번호</td>
								<td><input type="text" name="email"></td>
							</tr>
							<tr>
								<td>받으실 주소</td>
								<td><input type="text" name="address"
									placeholder="배송을 받는 상품이 아닙니다."></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>배송메시지</th>
					<td><input type="text" name="message"
						placeholder="배송비가 이상하다면 글을 남겨주세요."></td>
				</tr>
				<tr>
					<th>총배송비</th>
					<td><%=send_fee%>원</td>
				</tr>
			</table>

			<h4>할인혜택</h4>
			현재 적용 가능한 할인혜택이 없습니다. <br> <br> <br>

			<h4>결제수단</h4>

			<div class="pay_way">
				<div class="pay_way_radio 4u 12u$(xsmall)">
					<!-- radio 버튼으로 구현하고 하는 결제수단 선택 -->

					
					<input id="rdb1" type="radio" name="toggler" value="1" onclick="$('.card').toggle()"/><label	for="rdb1">신용카드</label><br>
					<input id="rdb2" type="radio" name="toggler" value="2" onclick="$('.card').toggle()"/><label	for="rdb2">무통장</label><br>
					<input id="rdb3" type="radio" name="toggler" value="3" onclick="$('.card').toggle()"/><label	for="rdb3">휴대폰 결제</label><br>
					<input id="rdb4" type="radio" name="toggler" value="4" onclick="$('.believe').toggle()"/><label	for="rdb4">믿음</label>

					
				</div>
				
				
				
				<!-- radio 버튼으로 구현하고 하는 결제수단 선택 끝-->

				<div class="pay_way_form">
					<!-- 결제수단에서 선택하면 나올 공간 -->

					<div id="blk-1" style="display: none">
						<span>신용카드 결제</span><br>
						<table>
							<tr>
								<th>카드선택</th>
								<td><select>
										<option>BC카드</option>
										<option>KB카드</option>
								</select></td>
							</tr>
							<tr>
								<th>할부선택</th>
								<td><select>
										<option>일시불</option>
										<option>3개월</option>
								</select></td>
							</tr>
						</table>
					</div>

					<div id="blk-4" style="display: none">

						곧 송금할 것이라 믿습니다.<br>

					</div>

				</div>
				<!-- 결제수단에서 선택하면 나올 공간 끝 -->
			</div>

		</div>

		<script type="text/javascript">
			$("input:radio").click(function() {
				var div ="#blk-1";
				$("div").hide;
				div ="#blk-2";
				$("div").hide;
				div ="#blk-3";
				$("div").hide;
				div ="#blk-4";
				$("div").hide;
				
				div = "#blk-" + $(this).val();
				$(div).show();
			});
		</script>




	</form>
	<!-- 왼쪽 배송 장소 및 수단 선택 공간 끝.-->

	<div class="banner">
		<!-- fix 된 오른쪽 사이드 출력 -->
		<h4>최종 결제 정보</h4>

		<div class="result">
		
			<table>
				<tr>
					<th>상품금액</th>
					<td><%=gold_price%>원</td>
				</tr>
				<tr>
					<th>할인금액</th>
					<td><%=discount_price%>원</td>
				</tr>
				<tr>
					<th>배송비</th>
					<td><%=send_fee%>원</td>
				</tr>
				<tr>
					<th><span> 총 결제금액 </span></th>
					<td><span
				class="final_price"><%=gold_price - discount_price + send_fee%>원</span></td>
				</tr>
			
			</table>
		

		</div>

		<div class="agree_check">
			<input type="checkbox" name="agree" id="agree"><label for="agree">(필수)동의합니다.<br> 주문할
			상품의 상품명, 가격, 배송정보에 동의 하십니까?(전자상거래법 제8조 2항)</label>
		</div>

		<div class="popup_check">
			<span>확인해주세요!</span><br> 설정에서 팝업차단을 해지했는지 확인해 주세요. 팝업창 차단이 설정되어
			있으면 결제가 진행되지 않습니다.
		</div>
		<input type="button" style="width: 100%"
			onclick="location.href='./PayAction.pln?id=<%=id%>'" value="구매하기">
	</div>
	<!-- fix 된 오른쪽 사이드 출력 끝-->

	<!-- 입력란 들어갈 곳. 끝. -->

</section>

<!-- Footer -->
<jsp:include page="../inc/footer.jsp" />