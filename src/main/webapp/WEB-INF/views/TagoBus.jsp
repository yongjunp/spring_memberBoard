<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>타고버스페이지</title>
<link href="${pageContext.request.contextPath}/resources/css/main.css"
	rel="stylesheet">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f27f610181c7185c2861db20210a1bd5"></script>
	<script src="https://kit.fontawesome.com/65020fc203.js" crossorigin="anonymous"></script>
<style>
.disnone {
	display: none;
}

#mapInfo {
	display: flex;
}
#leftInfo{
	box-sizing: border-box;
}
#busSttnArea {
	border: 3px solid black;
	margin-left: 3px;
	padding: 5px;
	width: 200px;
	height: 286px;
	overflow: scroll;
	overflow-x: hidden;
	font-size: 13px;
	border-radius: 10px;
	    padding-right: 0px;
}
#busSttnArea::-webkit-scrollbar {
    width: 10px;
  }
  #busSttnArea::-webkit-scrollbar-thumb {
    background-color: #2f3542;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  #busSttnArea::-webkit-scrollbar-track {
    background-color: none;
    border-radius: 10px;
  }
.busSttn {
	border: 1px solid black;
	border-radius: 10px;
	padding: 5px;
	text-align: center;
	margin-bottom: 3px;
}

.busSttn:hover {
	background-color: wheat;
}
#busArrInfo{
	border:2px solid black;
	border-radius: 10px;
	width: 614px;
	box-sizing:border-box;
	padding: 5px;
	margin-top: 5px;
	height: 147px;
	overflow: scroll;
	overflow-x: hidden;
	padding-right: 0px;
}
#busArrInfo::-webkit-scrollbar {
    width: 10px;
  }
  #busArrInfo::-webkit-scrollbar-thumb {
    background-color: #2f3542;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  #busArrInfo::-webkit-scrollbar-track {
    background-color: none;
    border-radius: 10px;
  }
.arrInfo{
	display:flex;
	border:1px solid black;
	border-radius: 10px;
	padding:5px;
	margin-bottom:3px;
}
.arrInfo:hover {
	background-color: wheat;
}
#map{
	border: 3px solid black;
	border-radius: 10px;
	box-sizing:border-box;
}
#TagoBus{
	display:flex;
}
#busLocInfo{
	border:3px solid black;
	border-radius: 10px;
	width: 400px;
	box-sizing:border-box;
	padding: 5px;
	margin-top: 0px;
	overflow: scroll;
	overflow-x: hidden;
	margin-left: 3px;
	height: 454px;
	    padding-right: 0px;
}
#busLocInfo::-webkit-scrollbar {
    width: 10px;
  }
  #busLocInfo::-webkit-scrollbar-thumb {
    background-color: #2f3542;
    border-radius: 10px;
    background-clip: padding-box;
    border: 2px solid transparent;
  }
  #busLocInfo::-webkit-scrollbar-track {
    background-color: none;
    border-radius: 10px;
  }
.busLocArea{
	border:2px solid black;
	border-radius: 10px;
	padding: 5px;
	margin-bottom:3px;
}
.busLocArea:hover {
	background-color: wheat;
}
.nowBus{
	border:5px solid red !important;
}
.nowBusSttn{
	background-color: black;
	color: white;
}
.select{
	background-color: bisque;
}
</style>
</head>

<body>
	<div class="mainWrap">
		<div class="header">
			<h1>TagoBus.jsp</h1>
		</div>

		<%@ include file="/WEB-INF/views/includes/Menu.jsp"%>

		<div class="contents">
			<div id="TagoBus">
				<div id="leftInfo">
					<div id="mapInfo">
						<!-- 지도 -->
						<div id="map" style="width: 400px; height: 300px;"></div>
						<!-- 정류소 목록 / 버스 정류소조회_API -->
						<div id="busSttnArea"></div>
					</div>
					<div id="busArrInfo">
						<!-- 도착예정 버스 정보 -->
					</div>
				</div>
				<div id="busLocInfo">
					<!-- 버스 노선 정보 -->
				</div>
			</div>
	<button onclick="createMarker('37.43883338837699', '126.67515520771632')">처음위치로</button>
		</div>
	</div>
	<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script type="text/javascript">
		oldPath = null;
		function getBusLocList(routeid, citycode){
			console.log("버스 위치 정보 조회 기능 호출")
			//1. 버스 노선 정보 - 경유정류장 목록조회
			let nodeList = null; // 정류소 목록
			let locList = null;	 // 버스 위치 목록
			$.ajax({
				type:"get",
				url: "getBusNodeList",
				data: {"citycode": citycode, "routeid":routeid},
				dataType:"json",
				async : false,
				success: function(nodeResult){
					nodeList = nodeResult;
					// 선을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 선을 표시합니다
					let linePath = [];
					let i = 0
					for(let loc of nodeResult){
					    linePath[i] = new kakao.maps.LatLng(loc.gpslati, loc.gpslong); 
						i++;
					}
					// 지도에 표시할 선을 생성합니다
					var polyline = new kakao.maps.Polyline({
					    path: linePath, // 선을 구성하는 좌표배열 입니다
					    strokeWeight: 5, // 선의 두께 입니다
					    strokeColor: '#FFAE00', // 선의 색깔입니다
					    strokeOpacity: 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
					    strokeStyle: 'solid' // 선의 스타일입니다
					});
					if(oldPath != null){
						oldPath.setMap(null);						
					}
					// 지도에 선을 표시합니다 
					polyline.setMap(map);  
					oldPath = polyline;
				}
			})
			//2.버스 위치 정보
			$.ajax({
				type:"get",
				url:"getBusLocList",
				data:{"citycode":citycode, "routeid": routeid},
				dataType:"json",
				async : false,
				success:function(rs){
					locList= rs;
				}
			})
			//3. 정류소 목록 출력 <div id = "busLocInfo">
			let busNodeArr = document.querySelector("#busLocInfo");
			busNodeArr.innerHTML = "";
			
			let locNodeIdList = [];
			for(let loc of locList){
				locNodeIdList.push(loc.nodeid);
			}
			for(let node of nodeList){
				let locDiv = document.createElement("div");
				locDiv.classList.add("busLocArea");
				
				if(locNodeIdList.includes(node.nodeid)){
					locDiv.classList.add('nowBus');
				}
				
				if(busSttn == node.nodeid){
					locDiv.classList.add("nowBusSttn");
					locDiv.setAttribute("tabindex", "0");
					locDiv.setAttribute("id", "focusNode");
					locDiv.innerHTML = "<i class='fa-solid fa-bus'></i>"+node.nodenm;
				}else{
					locDiv.innerText = node.nodenm						
				}
				
				locDiv.addEventListener('click', function(){
					createMarker(node.gpslati, node.gpslong)
				})
				
				busNodeArr.appendChild(locDiv);
				
			}
			document.querySelector("#focusNode").focus();
			}	
	</script>
	
	<%-- 정류소 도착정보 기능 스크립트 --%>
	<script type="text/javascript">
				function getBusArrInfo(nodeid, citycode) {
					$.ajax({
						type: "get",
						url: "getBusArrInfo",
						data: { "nodeid": nodeid, "citycode": citycode },
						dataType: "json",
						success: function (rs) {
							let busArrInfoDiv = document.querySelector("#busArrInfo");
							busArrInfoDiv.innerHTML="";
							
							for(let arrInfo of rs){
								let arrInfoDiv = document.createElement('div');
								arrInfoDiv.classList.add('arrInfo');
								arrInfoDiv.innerText = arrInfo.routeno + "번 "+arrInfo.arrprevstationcnt+"정거장 전 "+arrInfo.arrtime+"초 후 도착예정";
								arrInfoDiv.addEventListener('click', function(e){
									if(document.querySelector(".select") != null){
										document.querySelector(".select").classList.remove("select");
									}
									e.target.classList.add("select");
									console.log("버스 선택!");
									//버스 위치 정보 조회 기능호출
									getBusLocList(arrInfo.routeid, citycode);
								})
								busArrInfoDiv.appendChild(arrInfoDiv);
							}
						}
					})
				}
			</script>

	<%-- 정류소 정보 받아오는 스크립트 --%>
	<script type="text/javascript">
					let oldMarker = null;
					let busSttn = null;
					function getBusSttnList(latitude, longtitude) {
						$.ajax({
							type: "get",
							url: "getBusSttnList",
							data: {
								"latitude": latitude,
								"longtitude": longtitude
							},
							dataType: "json",
							success: function (rs) {
								let bsaEl = document.getElementById("busSttnArea");
								bsaEl.innerHTML = "";
								for (let Sttn of rs) {
									let busSttnTag = document.createElement("div");
									busSttnTag.classList.add("busSttn");
									busSttnTag.innerText = Sttn.nodeno + " " + Sttn.nodenm;
									busSttnTag.addEventListener('click', function(e){
										if(document.getElementById("selectBusSttn") != null){
											document.getElementById("selectBusSttn").classList.remove("select");
											document.getElementById("selectBusSttn").removeAttribute("id");										
											}

											e.target.setAttribute("id", "selectBusSttn");
											e.target.classList.add("select");
										
										busSttn = Sttn.nodeid;
										createMarker(Sttn.gpslati, Sttn.gpslong)
										getBusArrInfo(Sttn.nodeid , Sttn.citycode)
									})
									bsaEl.appendChild(busSttnTag);
								}

							}
						})
					}
				</script>
	<%-- 마커를 생성하는 스크립트 --%>
	<script type="text/javascript">
	function createMarker(lati, longti){
		var moveLatLon = new kakao.maps.LatLng(lati, longti);
		map.panTo(moveLatLon);
		
		var markerPosition  = new kakao.maps.LatLng(lati, longti); 
		var marker = new kakao.maps.Marker({
		    position: markerPosition
		});
		if(oldMarker != null){
			// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
			oldMarker.setMap(null);    											
		} 
			// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		oldMarker = marker;
	}
	</script>
	<%-- 맵 클릭이벤트 등록하기 --%>
	<script type="text/javascript">
						var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
							mapOption = {
								center: new kakao.maps.LatLng(37.4388512841691, 126.67510993153681), // 지도의 중심좌표
								level: 3
								// 지도의 확대 레벨
							};

						var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

						// 지도에 클릭 이벤트를 등록합니다
						// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
						kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
							var latlng = mouseEvent.latLng;
							console.log('클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, 경도는 '+ latlng.getLng() + ' 입니다');
								<%--버스 정류장 목록 불러오기 기능 호출 --%>
								getBusSttnList(latlng.getLat(), latlng.getLng())
						});
					</script>
</body>

</html>