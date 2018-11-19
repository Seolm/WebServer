<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>동 단위 행정구역별 메시지 보내기</title>
<!-- Bootstrap core CSS -->
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
	var markerImage = new google.maps.MarkerImage(
			/* "newmarker.png", */
			"icon.png",
		    null,null,null,
		    new google.maps.Size(10, 10)
		);
	var carImage = new google.maps.MarkerImage(
			"sports-car.png",
		    null,null,null,
		    new google.maps.Size(30, 30)
		);
	function initialize() {
		/* map = new google.maps.Map(document.getElementById('map-canvas'), {
			center : new google.maps.LatLng(37.551047990317834,
					126.99372496797264),
			zoom : 11,
			mapTypeId : google.maps.MapTypeId.ROADMAP
		}); */
		var latlng = new google.maps.LatLng(37.56017787685811,
				126.98316778778997);
		var mapOptions = {
				zoom : 11.35,
				center : latlng,
				//draggable : false,
				scaleControl : true,
				mapTypeId : google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		current = new google.maps.LatLng(37.5640, 126.9751);
		marker = new Array();
		
		script = document.createElement('script');
        var url = ['https://www.googleapis.com/fusiontables/v1/query?'];
        url.push('sql=');
        var query = 'SELECT EMD_KOR_NM, geometry, EMD_ENG_NM FROM ' +
            '10pRI5kjOiqTtr7rm-vgt5_rnEOATsu2sj9vEzcMb';
        var encodedQuery = encodeURIComponent(query);
        url.push(encodedQuery);
        url.push('&callback=drawMap');
        url.push('&key=AIzaSyAm9yWCV7JPCTHCJut8whOjARd7pwROFDQ');
        script.src = url.join('');
        body = document.getElementById('map-canvas');
        body.appendChild(script);
		
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
	}
	
	var countries = new Array(3);
	countries[0] = new Array(25);
	countries[1] = new Array(25);
	countries[2] = new Array(25);
	
	function drawMap(data) {
        /* var rows = data['rows']; */
        var rows = data.rows;
        for (var i in rows) {
          var newCoordinates = [];
          countries[0][i] = rows[i][0];
			countries[2][i] = rows[i][2];
			/* var geometries = rows[i][1];
			if (geometries) {
				newCoordinates.push(constructNewCoordinates(geometries));
			} */
          var geometries = rows[i][1]['geometries'];
          if (geometries) {
            for (var j in geometries) {
              newCoordinates.push(constructNewCoordinates(geometries[j]));
            }
          } else {
            newCoordinates = constructNewCoordinates(rows[i][1]['geometry']);
          }
          countries[1][i] = new google.maps.Polygon({
            id : i,
        	paths: newCoordinates,
            strokeColor: '#FF0000',
            strokeOpacity: 0,
            strokeWeight: 1,
            fillColor: '#FF0000',
            fillOpacity: 0
          });
          google.maps.event.addListener(countries[1][i], 'mouseover', function() {
            this.setOptions({fillOpacity: 0.6});
          });
          google.maps.event.addListener(countries[1][i], 'mouseout', function() {
            this.setOptions({fillOpacity: 0});
          });
          google.maps.event.addListener(countries[1][i], 'click', function() {
				openDialog(countries[0][this.id], countries[2][this.id]);
		  });
			
		  countries[1][i].setMap(map);
        }
      }

      function constructNewCoordinates(polygon) {
    	  /* var newCoordinates = [];
  		var comma = 0;
  		var lat=[];
  		var lang=[];
  		var tempLat="";
  		var tempLang="";
  		var two = 0;
  		var check = true;
  		for(var i in polygon) {
  			if(two==1){ two=2; continue; }
  			if(parseInt(i) >= polygon.length-57) break;
  			else {
  				if(polygon[parseInt(i)+51] == ',') {
  					comma++;
  					if(comma%2!=0) {
  						lang.push(parseFloat(tempLang));
  						tempLang = "";
  					}
  					else {
  						check = !check;
  						lat.push(parseFloat(tempLat));
  						tempLat = "";
  					}
  					continue;
  				}
  				if(comma%2==0) {
  					if(comma >= 2) {
  						if(!check) {
  							switch(two) {
  								case 0: two = 1; break;
  								case 2: two = 0; break;
  							}
  							if(two==1) continue;
  							check = !check;
  						}
  					}
  					tempLang += polygon[parseInt(i)+51];
  				}
  				else {
  					tempLat += polygon[parseInt(i)+51];
  				}
  			}	
  		}
  		for(var k in lat) {
  			newCoordinates.push(new google.maps.LatLng(lat[k], lang[k]));
  			console.log("test"+k);
  		}
  		return newCoordinates; */
        var newCoordinates = [];
        var coordinates = polygon['coordinates'][0];
        for (var i in coordinates) {
          newCoordinates.push(
              new google.maps.LatLng(coordinates[i][1], coordinates[i][0]));
        }
        return newCoordinates;
      }
      
      function openDialog(geo1, geo2) {
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
  					var msg = document.getElementById("test").value;
  					var test = geo2+","+msg;
  					
  					$.ajax({
  						type : "POST",
  						url : "http://"+address+":8080/WebServer/DataController?type=district&pubmsg=" + test,
  						data: test,
  						dataType:"text",
  						success : function(data) {
  							$.blockUI({ 
					            //message: $('div.growlUI'),
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
  						},
  						error : function(request, status, error) {
  							/* alert("code:" + request.status + "\n" + "message:"
  									+ request.responseText + "\n" + "error:" + error); */
  						}
  					});
  				},
  				"취소" : function() {
  					$(this).dialog("close");
  				}
  			}
  		});
  		$("#dialog").data('name', geo1).dialog('open');
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
					<li class="nav-item"><a class="nav-link active" href="<c:url value='/MainController?param=neighborhood'/>">
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
			<div id="map-canvas" class="col-md-10"></div>
		</div>
	</div>
	<div id="dialog" title="메시지 보내기" style="display:none">
		<form id="form" method="post">
			<span></span><br><br>
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