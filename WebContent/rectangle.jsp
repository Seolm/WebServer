<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사용자 지정 구역 메시지 보내기</title>
<link rel="icon" href="logo.png">
<link rel="stylesheet"
		href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDo3Hex6WnJUr6NTdUiwl9pM3CGJs7OvlA"
	type="text/javascript"></script>
<script src="https://code.jquery.com/jquery-1.12.3.min.js"></script>
<script src="//code.jquery.com/ui/1.11.0/jquery-ui.js"></script>
<script src="jquery.blockUI.js"></script>
<script src="main1.js"></script>
<!-- Custom styles for this template -->
<link href="<c:url value="/resources/css/main.css"/>" rel="stylesheet">
<link href="http://fonts.googleapis.com/earlyaccess/notosanskr.css" rel="stylesheet">
<script type="text/javascript">
	var layer_0;
	var map;
	var geo;
	var event1;
	var markerImage = new google.maps.MarkerImage(
			/* "newmarker.png", */
			"icon.png",
		    null,null,null,
		    new google.maps.Size(10, 10)
		    /* new google.maps.Size(17, 24) */
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
				draggable : true,
				scaleControl : true,
				mapTypeId : google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		current = new google.maps.LatLng(37.5640, 126.9751);
		marker = new Array();
		
		layer_0 = new google.maps.FusionTablesLayer({
			query : {
				select : "col0",
				from : "10pRI5kjOiqTtr7rm-vgt5_rnEOATsu2sj9vEzcMb"
			},
			map : map,
			styleId : 2,
			templateId : 2
		});
		timer = setInterval( function () {
			$.ajax({
				type:"POST",
				url:"http://"+address+":8080/WebServer/LocationController",
				success:function(data){
					var latitude, longitude;
					for(var i=0; i<Object.keys(data).length; i++) {
						client_id = eval("data.c"+i+".client_id");
						latitude = eval("data.c"+i+".latitude");
						longitude = eval("data.c"+i+".longitude");
						var current = new google.maps.LatLng(latitude, longitude);
						if(marker[i]) {
							marker[i].setPosition(current);
						} else {
							if (client_id == 'paho000011117') {
								marker[i] = new google.maps.Marker({
									position : current,
									map : map,
									title : client_id,
									animation : google.maps.Animation.DROP,
									icon : carImage
								});
							} else {
								marker[i] = new google.maps.Marker({
									position : current,
									map : map,
									title : client_id,
									animation : google.maps.Animation.DROP,
									icon : markerImage
								});
							}
						}
					}
				},
				error:function(request,status,error){
					/* alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); */
				}
			});
			}, 1000);
		var bounds = {
				north : 37.569,
				south : 37.529,
				east : 127.015,
				west : 126.964
		};
		
		rectangle = new google.maps.Rectangle({
			bounds : bounds,
			editable : true,
			draggable : true
		});
		
		rectangle.setMap(map);
		rectangle.addListener('bounds_changed', showNewRect);
		infoWindow = new google.maps.InfoWindow();
		image = new google.maps.MarkerImage(
					"crash.svg",
				    null,null,null,
				    new google.maps.Size(25, 25)
				);
		layer_0.addListener('click', function(e) {
			if(event1 != null) {
				event1.setMap(null);
			}
			event1 = new google.maps.Marker();
			event1.setPosition(e.latLng);
			event1.setIcon(image);
			event1.setMap(map);
			event1.setTitle("사건");
			event1.setAnimation(google.maps.Animation.BOUNCE);
		});
	}
	
	function showNewRect(event) {
		var ne = rectangle.getBounds().getNorthEast();
		var sw = rectangle.getBounds().getSouthWest();
		geo = ne.lat()+','+ne.lng()+','+sw.lat()+','+sw.lng();
		
		/* var contentString = '<b>Rectangle moved.</b><br>' +
			'New north-east corner : ' + ne.lat() + ', ' + ne.lng() + '<br>' +
			'New south-west corner : ' + sw.lat() + ', ' + sw.lng() + '<br>' +
			geo+'<br>'+
			'<button onclick="openDialog(geo)" class="btn btn-success">메세지 보내기</button>'; */
		var contentString = '<button onclick="openDialog(geo)" class="btn btn-success">메세지 보내기</button>';
		infoWindow.setContent(contentString);
		infoWindow.setPosition(ne);
		
		infoWindow.open(map);
	}
      
      function openDialog(geo) {
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
  					/* +document.getElementById("test").value; */
  					var emergency = "nomal";
  					if(document.getElementById("emergency").checked) {
  						emergency = "emer";
  	  					var eventLat = event1.getPosition().lat();
  	  					var eventLng = event1.getPosition().lng();
  	  					
  	  					msg = msg+emergency+","+eventLat+","+eventLng+","+document.getElementById("test").value;
	  	  				var test = geo+","+msg;
		  					$.ajax({
		  						type : "POST",
		  						url : "http://"+address+":8080/WebServer/DataController?type=locationRec&pubmsg=" + test,
		  						data: test,
		  						dataType:"text",
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
		  							/* event.setMap(null); */
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
  						var test = geo+","+msg;
  	  					$.ajax({
  	  						type : "POST",
  	  						url : "http://"+address+":8080/WebServer/DataController?type=locationRec&pubmsg=" + test,
  	  						data: test,
  	  						dataType:"text",
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
  		$("#dialog").data('name', geo).dialog('open');
  	}
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
					<li class="nav-item"><a class="nav-link active" href="<c:url value='/MainController?param=rectangle'/>"> 
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
					<!-- <li class="nav-item"><a class="nav-link" href="#"> <span
							data-feather="file-text"></span> Current month
					</a></li>
					<li class="nav-item"><a class="nav-link" href="#"> <span
							data-feather="file-text"></span> Last quarter
					</a></li> -->
				</ul>
			</div>
			</nav>
			<div id="map-canvas" class="col-md-10"></div>
		</div>
	</div>
	<div id="dialog" title="메시지 보내기" style="display:none">
		<form id="form" method="post">
			<span></span><br><br>
			<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class="form-check-input" type="checkbox" id="emergency">긴급 상황</p>
			<input id="test" name="test" type="text"/>		
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