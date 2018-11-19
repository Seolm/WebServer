<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>DashBoard Page</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="icon" href="logo.png">
<link href="<c:url value="/resources/css/main.css"/>" rel="stylesheet">
<link href="<c:url value="/resources/css/dashboard.css"/>" rel="stylesheet">
<link href="http://fonts.googleapis.com/earlyaccess/notosanskr.css" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<script src="main1.js"></script>
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- bootstrap -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<!-- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
   integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
   crossorigin="anonymous"></script> -->
<!-- moment.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.js"></script>
<!-- Chart.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<!-- daterangepicker -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<script>
var COLORS = [
	   '#51574a', '#447c69','#74c493','#8e8c6d','#e4bf80',
	   '#e9d78e','#F2F26F','#e2975d','#f19670','#e16552',
	   '#c94a53','#be5168','#a34974','#993767','#65387d',
	   '#4e2472','#9163b6','#e279a3','#e0598b','#7c9fb0',
	   '#355C7D','#5698c4','#89C0ED','#9abf88','#95CFB7'
	   ];
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
               <li class="nav-item"><a class="nav-link"
                  href="<c:url value='/MainController?param=main'/>"> <span
                     data-feather="home"></span> 실시간 유동인구
               </a></li>
   
               <li class="nav-item"><a class="nav-link"
                  href="<c:url value='/MainController?param=district'/>"> <span
                     data-feather="home"></span> 구 단위 메시지 보내기
               </a></li>
   
               <li class="nav-item"><a class="nav-link"
                  href="<c:url value='/MainController?param=neighborhood'/>"> <span
                     data-feather="home"></span> 동 단위 메시지 보내기
               </a></li>
   
               <li class="nav-item"><a class="nav-link"
                  href="<c:url value='/MainController?param=rectangle'/>"> <span
                     data-feather="users"></span> 관리자 지정 구역 메시지 보내기 [사각형]
               </a></li>
   
               <li class="nav-item"><a class="nav-link"
                  href="<c:url value='/MainController?param=circle'/>"> <span
                     data-feather="users"></span> 관리자 지정 구역 메시지 보내기 [원]
               </a></li>
            </ul>
   
            <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
               <span>Retrieve LBS Data Report</span>
            </h6>
   
            <ul class="nav flex-column mb-2">
               <li class="nav-item"><a class="nav-link active" href="<c:url value='/MainController?param=dashboard'/>"> <span data-feather="bar-chart-2"></span> DashBoard
               </a></li>
   
               <li class="nav-item"><a class="nav-link" href="<c:url value='/MainController?param=tracking'/>"> <span
							data-feather="layers"></span> Tracking-Clients
					</a></li>
            </ul>
         </div>
         </nav>
   
         <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <!-- <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
              <h1 class="h2">Dashboard</h1>
            </div> -->
            
            <table id="table1" style="width:100%">
               <tr>
                  <td><!-- real-time line chart -->
                  	<div class="row">
                    	<div class="col-sm-4"><h4>Real-time</h4></div>
                     	<div class="col-sm-4"></div>
                     	<div class="col-sm-4" style="text-align: right"><button type="button" class="btn btn-link" onclick="onDistrictBtnClicked()">Select District</button></div>
                  	</div>
                  	<div id="checkbox1"></div>
                  	<canvas id="districtLineChart" width="200" height="130"></canvas>
                  	<div id="legend1" style="text-align: center"></div>
                  </td>
                  <td><!-- one day pie chart -->
                    <div class="row">
                     	<div class="col-sm-4"><h4>One day</h4></div>
                     	<div class="col-sm-8"><input type="text" class="form-control" name="date" value="05/31/2018" /></div>
                  	</div>
                  	<canvas id="districtPieChart"></canvas>
               </td>
               </tr>
               <tr>
                  <td colspan='2'><!-- duration line chart -->
                     <div class="row">
                     	<div class="col-sm-3"><h4>Duration</h4></div>
                     	<div class="col-sm-3"><input type="text" class="form-control" name="daterange" value="05/23/2018 - 06/01/2018" /></div>
                     	<div class="col-sm-6"></div>
                  	</div>
                    <div id="checkbox2"></div>
                    <canvas id="districtDurationLineChart"></canvas>
                  </td>
               </tr>
            </table>
         </main>
      </div>
   </div>
   <!-- Icons -->
   <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
   <script>
      feather.replace()
   </script>
   
   <script>
   var korNameData;
   var intervalArray = new Array(25);
   var datasets = [];
   //checkbox
   $.ajax({
      url : 'https://www.googleapis.com/fusiontables/v1/query?sql=SELECT SIG_ENG_NM, SIG_KOR_NM FROM 1z5lxrRhhii6yGgw6aLm8VYN8RxJLDqjiubddrLBl ORDER BY SIG_KOR_NM ASC&key=AIzaSyAm9yWCV7JPCTHCJut8whOjARd7pwROFDQ',
       success : function(data) {
         korNameData = data.rows;
         for (var i in korNameData) {
            //checkbox1
            $("#checkbox1").append("<label class='checkbox-inline'><input type='checkbox' class='municipalities' onchange='check1Changed(this)' value='"+ i +"'>"+ korNameData[i][1]+ "</label>");
            $("#legend1").append("<span id='li"+ i +"' style='color:"+ COLORS[i] +"; display:none;'> &#9644;"+ korNameData[i][1]+ "</span>");
            
            var obj = { label : korNameData[i][1], data : [], hidden:true, borderColor: COLORS[i], fill: false,};
            datasets.push(obj);
            //checkbox2
            $("#checkbox2").append("<label class='checkbox-inline'><input type='radio' name='municipalities2' value='"+ i +"' checked>"+ korNameData[i][1]+ "</label>");
            //line1
            config1.data.datasets.push(datasets[i]);
            //pie2
            config2.data.labels.push(korNameData[i][1]);
            config2.data.datasets[0].backgroundColor.push(COLORS[i]);
         }
         lineChartDistrict.update();
         pieChartDistrict.update();
      },
      error : function(data) {
         console.error([ 'error', data ]);
      }
   });

   //-----------------------------------------------------------line chart1
   var ctx1 = document.getElementById("districtLineChart");
   var config1 = {
      type: 'line',
       data: {
         labels: [],
         datasets: []
      },
      options: {
         title: {
            display: true,
            text: 'Real-time',
           },
           hover: {
               mode:'nearest'
           },
         scales: {
        	 yAxes: [{
        	        ticks: {
        	          beginAtZero: true,
        	          callback: function(value) {if (value % 1 === 0) {return value;}}
        	        }
        	      }],
               xAxes: [{
                   type: "time",
                   time: {
                      format: "YYYY/MM/DD HH:mm:ss a",
                       //unit: 'minutes',
                       //unitStepSize: 0.5,
                  round: 'second',
                       tooltipFormat: "YYYY/MM/DD HH:mm:ss a",
                   }
            }]
         }
      }
   };
            
   Chart.defaults.global.legend.display = false;
   var lineChartDistrict = new Chart(ctx1, config1);
   function onDistrictBtnClicked(){
	      var x = document.getElementById("checkbox1");
	       if (x.style.display === "none") {
	           x.style.display = "block";
	       } else {
	           x.style.display = "none";
	       }
	}
   
   function check1Changed(checkbox) {
      if (checkbox.checked) {
         addDataset1(checkbox); 
         document.getElementById("li"+checkbox.value).style.display = "inline";
      } else {
         deleteDataset1(checkbox);
         document.getElementById("li"+checkbox.value).style.display = "none";
      }
   }
         
   function addDataset1(checkbox){
      config1.data.datasets[checkbox.value].hidden = false;
            
      //var district = korNameData[checkbox.value][0];
      var district = korNameData[checkbox.value][0];
              
      intervalArray[checkbox.value] = setInterval(function(){
         $.ajax({
            url : "http://"+address+":8080/WebServer/DataController?type=realtime&pubmsg=" + district,
            success : function(data) {
               if(config1.data.datasets[checkbox.value].data.length > 10){
                  config1.data.datasets[checkbox.value].data.shift();
               }
               if(config1.data.labels.length > 10){
                  config1.data.labels.shift();
               }
               config1.data.labels.push(moment());
               config1.data.datasets[checkbox.value].data.push({
                  x: moment(),
                  y: data,
               });
               lineChartDistrict.update();
               console.log(config1.data.datasets[checkbox.value].label+":"+data);
            },
               error : function(data) {
               console.error([ 'error', data ]);
            }
         });
      }, 1000);
      lineChartDistrict.update();
   } 
   
   function deleteDataset1(checkbox){
      config1.data.datasets[checkbox.value].hidden = true;
      config1.data.datasets[checkbox.value].data = [];
      if(isEmtyCheck())
         config1.data.labels=[];
      lineChartDistrict.update();
      clearInterval(intervalArray[checkbox.value]);
   }
         
   function isEmtyCheck(){
      for(var i=0; i<korNameData.length; i++){
         if(config1.data.datasets[i].hidden == false)
      return false;
      }
      return true;
   }
         
   //-----------------------------------------------------------pie chart1
   $(function() {
      $('input[name="date"]').daterangepicker({
          singleDatePicker: true,
          showDropdowns: true,
      }, function(start, end, label) {
         //console.log(moment(start).format('YYYYMMDD'));
         onPieDateClicked(moment(start).format('YYYYMMDD'));
      });
   });
   
   var ctx2 = document.getElementById('districtPieChart').getContext('2d');
   var config2 = {
      type: 'pie',
      data: {
         datasets: [{
            data: [],
            backgroundColor: [],
            label: 'Dataset 1'
         }],
            labels: []
      },
      options: {
         responsive: true
      }
   };
         
   var pieChartDistrict = new Chart(ctx2, config2);
   //onPieDateClicked("20180509")
   function onPieDateClicked(date) {
      
      //var msg = moment().format('YYYYMMDD');
      $.ajax({
         url : "http://"+address+":8080/WebServer/DataController?type=oneday&pubmsg=" + date,
          success : function(data) {
            config2.data.datasets[0].data = [];
            config2.data.datasets[0].data = JSON.parse(data);
            pieChartDistrict.update();
         },
         error : function(data) {
            console.error([ 'error', data ]);
         }
      });
   }
   
   //-----------------------------------------------------------line chart3
   /*
   $(function() {
       $('input[name="daterange"]').daterangepicker({
       }, function(start, end, label) {
            var startdate = start.format('YYYYMMDD');
            var enddate = end.format('YYYYMMDD');
            console.log(startdate+" "+enddate);
            var id = getRadioValue();
            if(id != -1)
            	addDataset3(id, startdate, enddate);
       });
   });
   */
   
   $('input[name="daterange"]').daterangepicker();
   $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
	   var start = picker.startDate.format('YYYYMMDD');
	   var end = picker.endDate.format('YYYYMMDD');
	   var id = getRadioValue();
	   if(id != -1)
       	addDataset3(id, start, end);
   });
   
   function getRadioValue(){
      var radios = document.getElementsByName('municipalities2');
      for (var i = 0, length = radios.length; i < length; i++)
      {
       if (radios[i].checked)
       {
         return radios[i].value;
       }
      }
      return -1;
   }
   var ctx3 = document.getElementById("districtDurationLineChart");
   var config3 = {
      type: 'line',
       data: {
         labels: [],
         datasets: [{
             data: [],
             label: 'Dataset 1',
             borderColor: 'rgb(113, 91, 164)',
             backgroundColor: 'rgba(113, 91, 164, 0.2)',
          }],
      },
      options: {
         title: {
            display: true,
            text: 'Duration',
           },
           hover: {
               mode:'nearest'
           },
         scales: {
        	 yAxes: [{
        	        ticks: {
        	          beginAtZero: true,
        	          //suggestedMax: 10,
        	          callback: function(value) {if (value % 1 === 0) {return value;}}
        	        }
        	      }],
               xAxes: [{
                   type: "time",
                   time: {
                      format: "YYYY/MM/DD HH:mm:ss a",
                       //unit: 'minutes',
                       //unitStepSize: 0.5,
                  round: 'second',
                       tooltipFormat: "YYYY/MM/DD HH:mm:ss a",
                   }
            }]
         }
      }
   };
   
   var lineChartDurationDistrict = new Chart(ctx3, config3);

   function addDataset3(id, startdate, enddate){
      
	  var start = moment(startdate);
      var end = moment(enddate);
      var daysCount = end.diff(start, 'days') + 1;
      //console.log(daysCount);
      
      config3.data.labels = [];
      for(var i = 0; i < daysCount*2; i++ )
         config3.data.labels.push(moment(startdate).add(12*i,'hours').format("YYYY/MM/DD HH"));
      //console.log(config3.data.labels);
      var msg = korNameData[id][0] + "," + startdate + ","+ enddate;
      //console.log(msg);
      console.log("hihi");
      $.ajax({
         url : "http://"+address+":8080/WebServer/DataController?type=duration&pubmsg=" + msg,
          success : function(data) {
             config3.data.datasets[0].data = [];
             config3.data.datasets[0].data = JSON.parse(data);
             //console.log(msg);
             console.log(data);
            lineChartDurationDistrict.update();
         },
         error : function(data) {
            console.error([ 'error', data ]);
         }
      });
   }       
   </script>
</body>
</html>