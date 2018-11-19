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
<link rel="icon" href="logo.png">

<title>실시간 유동인구</title>
<!-- Bootstrap core CSS -->
<!-- <link href="resources/css/bootstrap.min.css" rel="stylesheet"> -->
<!-- <link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous"> -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
	integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
	crossorigin="anonymous"></script>

<!-- Custom styles for this template -->
<!-- <link href="dashboard.css" rel="stylesheet"> -->
<!-- <script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false">
</script> -->
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
<script type="text/javascript">
var selecMarker;
function clearText(y){ 
	if (y.defaultValue==y.value) 
		y.value = "" 
}

function toggleBounce() {
	if(marker.getAnimation() != null) {
		marker.setAnimation(null);
	} else {
		marker.setAnimation(google.maps.Animation.BOUNCE);
	}
}
function toggleHeatmap() {
	/* heatmap.setMap(heatmap.getMap() ? null : map); */
	if(heatmap.getMap()) {
		heatmap.setMap(null);
		toggleFlag = 0;
	} else {
		heatmap.setMap(map);
		toggleFlag = 1;
	}
}
		
var heatmap;
var map;
var toggleFlag = 0;
var heatMapArray = [];
var markers;
var event1;
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
var listeners = [];
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

	// heatmap
	heatmap = new google.maps.visualization.HeatmapLayer({
	      data: heatMapArray,
	      map: map
	});
	
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
				/* heatMapArray[i] = current; */
				if(toggleFlag == 1) {
					if(markers[i]) {
						markers[i].setMap(null);
						heatMapArray[i] = markers[i].getPosition();
					} else {
						heatMapArray[i] = current;
					}
					
				} else {
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
					});
				}
				heatMapArray[i] = markers[i].getPosition();
			}
		},
		error:function(request,status,error){
			/* alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); */
		}
	});
	}, 1000);
	infoWindow = new google.maps.InfoWindow();
	
	image = new google.maps.MarkerImage(
			"crash.svg",
		    null,null,null,
		    new google.maps.Size(25, 25)
		);
	map.addListener('click', function(e) {
		if(event1 != null)
			event1.setMap(null);
		event1 = new google.maps.Marker();
		event1.setPosition(e.latLng);
		event1.setIcon(image);
		event1.setMap(map);
		event1.setTitle("사건");
		event1.setAnimation(google.maps.Animation.BOUNCE);
	});
}

function makeCircle() {
	clientList = [];
	radius = eval(document.getElementById('radius').value);
	people = eval(document.getElementById('people').value);
	msg = selecMarker.getPosition().lat()+","+selecMarker.getPosition().lng()+","+radius+","+people+","+selecMarker.getTitle();
	$.ajax({
		type:"POST",
		url:"http://"+address+":8080/WebServer/DataController?type=knn&pubmsg=" + msg,
		data: msg,
		dataType:"json",
		success:function(data){
			for(var i=0; i<markers.length; i++) {
				for(var j=0; j<data.clients.length; j++)
					if(markers[i].getTitle() == String(data.clients[j]))
						markers[i].setAnimation(google.maps.Animation.BOUNCE);
			}
			for(var k=0; k<data.clients.length; k++) {
				clientList.push(data.clients[k]);
			}
		},
		error:function(request,status,error){
			/* alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); */
		}
	});
	myCircle = new google.maps.Circle({
        strokeColor: '#00FF00',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#00FF00',
        fillOpacity: 0.35,
        map: map,
        center: selecMarker.getPosition(),
        radius: radius,
		editable : false,
		draggable : false
    });
	myCircle.setMap(map);
	google.maps.event.addListener(infoWindow, "closeclick", function(){
		gotoInit();
	});
	map.setZoom(13);
	map.setCenter(selecMarker.getPosition());
	var contentString = '<button onclick="openDialog(clientList)" class="btn btn-primary">메세지 보내기</button>';
	infoWindow.setContent(contentString);
	infoWindow.open(map);
}

function gotoInit() {
	myCircle.setMap(null);
	for(var i=0; i<markers.length; i++) {
		if(markers[i].getAnimation() != null)
			markers[i].setAnimation(null);
	}
	map.setZoom(11.35);
	map.setCenter(new google.maps.LatLng(37.56017787685811,126.98316778778997));
}
k=0;
function showWindow(marker) {
	console.log(k++);
	selecMarker = marker;
	/* var contentString = "<form name='myForm'>"+
					"<table><tr><td>&nbsp;</td></tr><tr><td align='center'>"+
					"<span>반경 : </span></td><td><input id='radius' name='radius' type='text' class='form-control form-control-sm' value='미터 단위' onFocus='clearText(this)'/>&nbsp;<span><b>M</b></span></td></tr>"+
					"<tr><td><span>사람 수 : </span></td><td><input id='people' name='people' type='text' class='form-control form-control-sm' value='가까운 K명 선택' onFocus='clearText(this)'/>"+
					"&nbsp;<span><b>명</b></span></td></tr><tr><td>&nbsp;</td></tr><tr><td colspan='2' align='center'><input type='button' value='선택' onclick='makeCircle()'/></td></tr>"+
					"<tr><td>&nbsp;</td></tr></table></form>"; */
	var contentString = "<form name='myForm'>"+
					"<div class='form-group'><label for='radius'>반경 : (M)</label><input type='text' class='form-control form-control-sm' id='radius' style='width:150px' placeholder='미터 단위'></div>"+
					"<div class='form-group'><label for='people'>사람 수 : (명)</label><input type='text' class='form-control form-control-sm' id='people' style='width:150px' placeholder='가까운 K명 선택'></div>"+
					"<input type='button' value='선택' onclick='makeCircle()' class='btn btn-danger'/></form>";
	infoWindow.setContent(contentString);
	infoWindow.setPosition(marker.getPosition());
	infoWindow.open(map);
}

function openDialog(clientList) {
		var clientView = "";
		for(var k=0; k<clientList.length; k++) {
			if(k+1 != clientList.length)
				clientView += clientList[k] + "<br>";
			else clientView += clientList[k];
		}
		$("#dialog").dialog({
			autoOpen : false,
			modal : true,
			resizable : false,
			show : 'slide',
			hide : 'slide',
			position:{
              my:"left top",
              at:"left top",
              of:"#map-canvas" 
              },
          open: function() {
          	$(this).find("span").eq(0).html($(this).data("name"));
          },
			buttons : {
				"메시지 전송" : function() {
					var msg = "sp,";
						/* document.getElementById("test").value; */
					var emergency = "nomal";
  					if(document.getElementById("emergency").checked) {
  						emergency = "emer";
  	  					var eventLat = event1.getPosition().lat();
  	  					var eventLng = event1.getPosition().lng();
  	  					
  	  					msg = msg+emergency+","+eventLat+","+eventLng+","+document.getElementById("test").value;
	  	  				var test = msg+","+clientList.length+","+clientList.join(",");
						$.ajax({
							type : "POST",
							url : "http://"+address+":8080/WebServer/DataController?type=publishKnn&pubmsg=" + test,
							data: test,
							dataType: "text",
							success : function(data) {
								$.blockUI({ 
					            message: $("#block"),
					            fadeIn: 700, 
					            fadeOut: 700, 
					            timeout: 2000, 
					            showOverlay: false, 
					            centerY: false, 
					            css: { 
					                width: '350px', 
					                top: '70px', 
					                left: '', 
					                right: '10px', 
					                border: 'none', 
					                padding: '5px', 
					                backgroundColor: '#000', 
					                '-webkit-border-radius': '10px', 
					                '-moz-border-radius': '10px', 
					                opacity: .6, 
					                color: '#fff' 
					            } 
					        });
								$("#dialog").dialog("close");
								gotoInit();
								infoWindow.open(null);
								if(event1 != null) {
	  								event1.setMap(null);
	  								event1 = null;
	  							}
							},
							error : function(request, status, error) {
								/* alert("code:" + request.status + "\n" + "message:"
										+ request.responseText + "\n" + "error:" + error); */
							}
						});
  					}
  					else {
  						msg = msg+emergency+","+document.getElementById("test").value;
  						var test = msg+","+clientList.length+","+clientList.join(",");
  						$.ajax({
  							type : "POST",
  							url : "http://"+address+":8080/WebServer/DataController?type=publishKnn&pubmsg=" + test,
  							data: test,
  							dataType: "text",
  							success : function(data) {
  								$.blockUI({ 
  					            message: $("#block"),
  					            fadeIn: 700, 
  					            fadeOut: 700, 
  					            timeout: 2000, 
  					            showOverlay: false, 
  					            centerY: false, 
  					            css: { 
  					                width: '350px', 
  					                top: '70px', 
  					                left: '', 
  					                right: '10px', 
  					                border: 'none', 
  					                padding: '5px', 
  					                backgroundColor: '#000', 
  					                '-webkit-border-radius': '10px', 
  					                '-moz-border-radius': '10px', 
  					                opacity: .6, 
  					                color: '#fff' 
  					            } 
  					        });
  								$("#dialog").dialog("close");
  								gotoInit();
  								infoWindow.open(null);
  								if(event1 != null) {
	  								event1.setMap(null);
	  								event1 = null;
	  							}
  							},
  							error : function(request, status, error) {
  								/* alert("code:" + request.status + "\n" + "message:"
  										+ request.responseText + "\n" + "error:" + error); */
  							}
  						});
  					}
				},
				"취소" : function() {
					$(this).dialog("close");
				}
			}
		});
		$("#dialog").data('name', clientView).dialog('open');
	}

google.maps.event.addDomListener(window, 'load', initialize);
</script>
</head>

<body>
	<%-- <nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
		<a class="navbar-brand col-sm-3 col-md-2 mr-0" href="<c:url value='/MainController?param=main'/>">
			<table>
				<tr><td><img src="logo.png" width="50px" height="50px"/></td>
				<td><div align="center">서울시 실시간 유동인구<br>통합메시징 시스템</div></td>
			</table>
		</a> 
		<!-- <input class="form-control form-control-dark w-100" type="text"placeholder="Search" aria-label="Search"> -->
		<!-- <ul class="navbar-nav px-3">
			<li class="nav-item text-nowrap">
				<a class="nav-link" href="#">Sign out</a>
			</li>
		</ul> -->
		<div align="center" class="navbar-brand col-sm-10 col-md-10">서울시 실시간 유동인구 확인(열지도) & KNN</div>
	</nav> --%>

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
					<li class="nav-item"><a class="nav-link active" href="<c:url value='/MainController?param=main'/>">
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
					<li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=tracking'/>"> <span
							data-feather="layers"></span> Tracking-Clients
					</a></li>
					
				</ul>
			</div>
			</nav>
			<div id="floating-panel">
			      <button onclick="toggleHeatmap()" class="btn btn-success">열지도(Toggle)</button>
   			</div>
			<div id="map-canvas" class="col-md-10"></div>
		</div>
	</div>
	<div id="dialog" title="긴급 메시지 보내기" style="display:none">
		<form id="form" method="post">
			<span></span><br><br>
			<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class="form-check-input" type="checkbox" id="emergency">긴급 상황</p>
			<input id="test" name="test" type="text" value="긴급 메시지" onFocus="clearText(this)"/>		
		</form>
	</div>
	<div id="block" style="display:none;">
		<table>
			<tr>
				<td rowspan="2"><img src="check48.png" width="45px" height="45px"/></td>
				<td><h5>&nbsp;&nbsp;<b>메시지를 보내는 중입니다.</b></h5></td>
			</tr>
			<tr>
				<td><h6>Please Wait..</h6></td>
			</tr>
		</table>
	</div>
	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<!-- <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
		integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
		crossorigin="anonymous"></script>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
		integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
		crossorigin="anonymous"></script> -->
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
