<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
	<!-- Header -->
	<jsp:include page="../inc/header.jsp" />
	<!-- 스타일 불러오기 -->
	<link rel="stylesheet" href="assets/css/main.css" />
	<link rel="stylesheet" href="./assets/css/map/map.css" />
	<!-- Scripts -->
	<script src="assets/js/jquery.min.js"></script>
	<script src="assets/js/skel.min.js"></script>
	<script src="assets/js/util.js"></script>
	<script src="assets/js/main.js"></script>
</head>

<body>
	<div class="clear"></div>
	<!-- Main -->
	<div class="tit_map">
		<h2>여행일정 한 눈에 보기</h2>
	</div>
	<div id="map"></div>
	<div id="right-panel">
		<div>
			<b>출발지</b> 
			<select id="start">
				<option value="Halifax, NS">Halifax, NS</option>
				<option value="Boston, MA">Boston, MA</option>
				<option value="New York, NY">New York, NY</option>
				<option value="Miami, FL">Miami, FL</option>
			</select><br> 
			<b>경유지</b><br> 
			<select id="waypoints">
				<option value="montreal, quebec">Montreal, QBC</option>
				<option value="toronto, ont">Toronto, ONT</option>
				<option value="chicago, il">Chicago</option>
				<option value="winnipeg, mb">Winnipeg</option>
				<option value="fargo, nd">Fargo</option>
				<option value="calgary, ab">Calgary</option>
				<option value="spokane, wa">Spokane</option>
			</select> <br> 
			<b>도착지</b> 
			<select id="end">
				<option value="Vancouver, BC">Vancouver, BC</option>
				<option value="Seattle, WA">Seattle, WA</option>
				<option value="San Francisco, CA">San Francisco, CA</option>
				<option value="Los Angeles, CA">Los Angeles, CA</option>
			</select> <br> 
			<input type="submit" id="submit" value="여행 경로보기">
			<input type="submit" value="일정에 추가하기">
		</div>
		<div id="directions-panel"></div>
	</div>
	<script>
		function initMap() {
			var directionsService = new google.maps.DirectionsService;
			var directionsDisplay = new google.maps.DirectionsRenderer;
			var map = new google.maps.Map(document.getElementById('map'), {
				zoom : 6,
				center : {
					lat : 41.85,
					lng : -87.65
				}
			});
			directionsDisplay.setMap(map);

			document.getElementById('submit').addEventListener(
				'click',
				function() {
					calculateAndDisplayRoute(directionsService,
							directionsDisplay);
				});
		}

		function calculateAndDisplayRoute(directionsService, directionsDisplay) {
			var waypts = [];
			var checkboxArray = document.getElementById('waypoints');
			for (var i = 0; i < checkboxArray.length; i++) {
				if (checkboxArray.options[i].selected) {
					waypts.push({
						location : checkboxArray[i].value,
						stopover : true
					});
				}
			}

			directionsService.route({
				origin : document.getElementById('start').value,
				destination : document.getElementById('end').value,
				waypoints : waypts,
				optimizeWaypoints : true,
				travelMode : 'DRIVING'
			}, function(response, status) {
				if (status === 'OK') {
					directionsDisplay.setDirections(response);
					var route = response.routes[0];
					var summaryPanel = document
							.getElementById('directions-panel');
					summaryPanel.innerHTML = '';
					// For each route, display summary information.
					for (var i = 0; i < route.legs.length; i++) {
						var routeSegment = i + 1;
						summaryPanel.innerHTML += '<b>Route Segment: '
								+ routeSegment + '</b><br>';
						summaryPanel.innerHTML += route.legs[i].start_address
								+ ' to ';
						summaryPanel.innerHTML += route.legs[i].end_address
								+ '<br>';
						summaryPanel.innerHTML += route.legs[i].distance.text
								+ '<br><br>';
					}
				} else {
					window.alert('Directions request failed due to ' + status);
				}
			});
		}
	</script>
	<script async defer
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAwZMwcmxMBI0VQAUkusmqbMVHy-b4FuKQ&callback=initMap">
	</script>

</body>
<div class="clear"></div>
<!-- Footer -->
<jsp:include page="../inc/footer.jsp" />
</html>