<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Test Main Page</title>
<link rel="icon" href="logo.png">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
	
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
	integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
	crossorigin="anonymous"></script>
	
<script src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDo3Hex6WnJUr6NTdUiwl9pM3CGJs7OvlA&libraries=visualization"></script>
<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
<script src="jquery.blockUI.js"></script>
<script src="main1.js"></script>
<link rel="stylesheet"
		href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
<!-- Custom styles for this template -->
<link href="<c:url value="/resources/css/main.css"/>" rel="stylesheet">
<link href="http://fonts.googleapis.com/earlyaccess/notosanskr.css" rel="stylesheet">
<link href="<c:url value="/resources/css/datepicker.min.css"/>" rel="stylesheet" type="text/css">
<script src="datepicker.min.js"></script>

<!-- Include English language -->
<script src="datepicker.en.js"></script>
<style>
.required {
  color:red; 
  font-weight:bold
}
.datepicker{z-index:1151 !important;}
</style>
<script type="text/javascript">
var selecMarker;
function clearText(y){ 
	if (y.defaultValue==y.value) 
		y.value = "" 
}

var map;
var markers;
var checkTitle;
var toggleFlag = 0;
var pathPolyline;
var listeners = [];
var markerImage = new google.maps.MarkerImage(
		"newmarker.png",
	    null,null,null,
	    new google.maps.Size(17, 24)
	);
var carImage = new google.maps.MarkerImage(
		"sports-car.png",
	    null,null,null,
	    new google.maps.Size(30, 30)
	);
function initialize() {
	var latlng = new google.maps.LatLng(37.56017787685811,
			126.98316778778997);
	var mapOptions = {
			zoom : 11.35,
			center : latlng,
			//scrollwheel : true,
			//draggable : false,
			scaleControl : true,
			mapTypeId : google.maps.MapTypeId.ROADMAP
	}
	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
	
	current = new google.maps.LatLng(37.5640, 126.9751);
	markers = new Array();
	timer = setInterval( function () {
	$.ajax({
		type:"POST",
		url:"http://"+address+":8080/WebServer/LocationController",
		success:function(data){
			/* console.log(heatMapArray.length + "==================== 1"); */
			if(listeners.length != 0) {
				for(var i=0; i<Object.keys(data).length; i++) {
					listeners[i].remove();
				}
			}
			var latitude, longitude;
			for(var i=0; i<Object.keys(data).length; i++) {
				client_id = eval("data.c"+i+".client_id");
				latitude = eval("data.c"+i+".latitude");
				longitude = eval("data.c"+i+".longitude");
				var current = new google.maps.LatLng(latitude, longitude);
				if(toggleFlag == 1) {
					if(markers[i] && checkTitle != markers[i].getTitle()) {
						markers[i].setMap(null);
					}
				}
				else {
					if(markers[i]) {
						if(!markers[i].getMap()) {
							markers[i].setMap(map);
						}
						markers[i].setPosition(current);
					} else {
						if (client_id == 'paho000011117') {
							markers[i] = new google.maps.Marker({
								position : current,
								map : map,
								title : client_id,
								animation : google.maps.Animation.DROP,
								icon : carImage
							});
						} else {
							markers[i] = new google.maps.Marker({
								position : current,
								map : map,
								title : client_id,
								animation : google.maps.Animation.DROP,
								icon : markerImage
							});
						}
					}
					markers[i].addListener('mouseover', function() {
						this.setAnimation(google.maps.Animation.BOUNCE);
					});
					markers[i].addListener('mouseout', function() {
						this.setAnimation(null);
					});
					listeners[i] = markers[i].addListener('click', function() {
						this.setAnimation(null);
						showWindow(this);
						checkTitle = this.getTitle();
					});
				}
			}
		},
		error:function(request,status,error){
			/* alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); */
		}
	});
	}, 1000);
	infoWindow = new google.maps.InfoWindow();
	// Initialization
	myDate = $('#startdate').datepicker({
		startDate : new Date(),
		language : 'en',
		maxDate : new Date(),
		range : true,
		dateFormat : "yyyy/mm/dd",
		multipleDatesSeparator : ' ~ '
	}).data('datepicker');
	
	/* $('#enddate').datepicker({
		startDate : new Date(),
		language : 'en',
		maxDate : new Date(),
		dateFormat : "yyyy/mm/dd"
	}) */
	// Access instance of plugin
	
	/* $('#enddate').data('datepicker') */
	/* $('#myModal').css ('z-index', 0);  */
}
function toggle() {
	toggleFlag = 0;
	map.setZoom(11.35);
	map.setCenter(new google.maps.LatLng(37.56017787685811,126.98316778778997));
	pathPolyline.setMap(null);
}
function getLog() {
	$('#myModal').modal('toggle');
	toggleFlag = 1;
	var dates = myDate.selectedDates;
	var start, end;
	var startHours, startMinute, startMonth, startDate, endHours, endMinute, endMonth, endDate;
	if(dates[0].getHours() == 0 || dates[0].getHours() < 10)
		startHours = "0"+dates[0].getHours();
	else startHours = dates[0].getHours();
	if(dates[0].getMinutes() == 0 || dates[0].getMinutes() < 10)
		startMinute = "0"+dates[0].getMinutes();
	else startMinute = dates[0].getMinutes();
	if(dates[1].getHours() == 0 || dates[1].getHours() < 10)
		endHours = "0"+dates[1].getHours();
	else endHours = dates[1].getHours();
	if(dates[1].getMinutes() == 0 || dates[1].getMinutes() < 10)
		endMinute = "0"+dates[1].getMinutes();
	else endMinute = dates[1].getMinutes();
	if(dates[0].getMonth()+1 < 10)
		startMonth = "0"+(dates[0].getMonth()+1);
	else startMonth = dates[0].getMonth()+1;
	if(dates[0].getDate() < 10)
		startDate = "0"+dates[0].getDate();
	else startDate = dates[0].getDate();
	if(dates[1].getMonth()+1 < 10)
		endMonth = "0"+(dates[1].getMonth()+1);
	else endMonth = dates[0].getMonth()+1;
	if(dates[1].getDate() < 10)
		endDate = "0"+dates[1].getDate();
	else endDate = dates[1].getDate();
	start = dates[0].getFullYear().toString()+startMonth+startDate+startHours+startMinute;
	end =  dates[1].getFullYear().toString()+endMonth+endDate+endHours+endMinute;
	msg = selecMarker.getTitle()+","+start+","+end;
	$.ajax({
		type:"POST",
		url:"http://"+address+":8080/WebServer/DataController?type=tracking&pubmsg=" + msg,
		data: msg,
		dataType:"json",
		success:function(data){
			var latitude, longitude, time;
			var pathArray = [];
			var pathMarkers = [];
			var lineSymbol = {
					path : google.maps.SymbolPath.FORWARD_CLOSED_ARROW
			};
			for(var i=0; i<Object.keys(data).length; i++) {
				latitude = eval("data.d"+i+".latitude");
				longitude = eval("data.d"+i+".longitude");
				time = eval("data.d"+i+".time");
				var tempLatLng = new google.maps.LatLng(latitude, longitude);
				pathArray.push(tempLatLng);
			}
			pathPolyline = new google.maps.Polyline({
			    path: pathArray,
			    geodesic: true,
			    strokeColor: '#FF0000',
			    strokeOpacity: 1.0,
			    strokeWeight: 3,
			    icons : [{
			    	icon : lineSymbol,
			    	offset: '100%'
			    }]
			});
			pathPolyline.setMap(map);
			map.setZoom(13);
			map.setCenter(selecMarker.getPosition());
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}
k=0;
function showWindow(marker) {
	console.log(k++);
	selecMarker = marker;
	var contentString = "<button type='button' class='btn btn-success' data-toggle='modal' data-target='#myModal' onclick='closeWindow()'>"+
						"Start Tracking!!</button>";
	infoWindow.setContent(contentString);
	infoWindow.setPosition(marker.getPosition());
	infoWindow.open(map);
}
function closeWindow() {
	console.log("닫힘");
	infoWindow.close();
}
/* <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
Start Tracking!!
</button> */
google.maps.event.addDomListener(window, 'load', initialize);
</script>
</head>

<body>
	
	<div class="container-fluid">
		<div class="row">
			<nav class="col-md-2 d-none d-md-block bg-light sidebar">
			<div class="sidebar-sticky">
				<!-- title -->	
				<table id="webTitle">
					<tr>
						<td><img src="logo.png" width="50px" height="50px"/></td>
						<td><a href="<c:url value='/MainController?param=main'/>" id="webTitle">서울시 실시간 유동인구<br>통합메시징 시스템</a></td>
					</tr>
				</table>
				<h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
					<span>Publish Msg to Clients</span>
				</h6>
				<ul class="nav flex-column">
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=main'/>">
							<span data-feather="home"></span> 실시간 유동인구
					</a></li>
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=district'/>">
							<span data-feather="home"></span> 구 단위 메시지 보내기
					</a></li>
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=neighborhood'/>">
							<span data-feather="home"></span> 동 단위 메시지 보내기
					</a></li>
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=rectangle'/>"> 
						<span data-feather="users"></span> 관리자 지정 구역 메시지 보내기 [사각형]
					</a></li>
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=circle'/>"> 
						<span data-feather="users"></span> 관리자 지정 구역 메시지 보내기 [원]
					</a></li>
				</ul>

				<h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
					<span>Retrieve LBS Data Report</span>
				</h6>
				
				<ul class="nav flex-column mb-2">
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=dashboard'/>"> <span
							data-feather="bar-chart-2"></span> DashBoard
					</a></li>
					<li class="nav-item"><a class="nav-link active" href="<c:url value='/MainController?param=tracking'/>"> <span
							data-feather="layers"></span> Tracking-Clients
					</a></li>
					
				</ul>
			</div>
			</nav>
			<div id="floating-panel">
			      <button onclick="toggle()" class="btn btn-success">돌아가기</button>
   			</div>
			<div id="map-canvas" class="col-md-10"></div>
		</div>
	</div>

  <!-- The Modal -->
  <div class="modal fade" id="myModal">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
      
        <!-- Modal Header -->
        <div class="modal-header">
          <h4 class="modal-title">Tracking Clients</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        
        <!-- Modal body -->
        <div class="modal-body">
        	<span class="required">추적 시간 설정</span><br><br>
        	<input type="text" data-timepicker="true" data-time-format="hh:ii aa" class="datepicker-here" id="startdate"
        		onFocus='clearText(this)' value="클릭해서 날짜 범위를 지정하세요." style='width:400px'/>
        	<!-- ~
        	<input type="text" data-timepicker="true" data-time-format="hh:ii aa" class="datepicker-here" id="enddate"/> -->
        </div>
        
        <!-- Modal footer -->
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" onclick='getLog()'>확인</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
        
      </div>
    </div>
  </div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
		integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
		crossorigin="anonymous"></script>
	<script src="resources/js/bootstrap.min.js"></script>

	<!-- Icons -->
	<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
	<script>
		feather.replace()
	</script>

</body>
</html>
