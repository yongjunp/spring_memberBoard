<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>메인페이지</title>
        <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f27f610181c7185c2861db20210a1bd5"></script>
            <style>
                .disnone {
                    display: none;
                }
            </style>
    </head>

    <body>
        <div class="mainWrap">
            <div class="header">
                <h1>BusList.jsp</h1>
            </div>

            <%@ include file="/WEB-INF/views/includes/Menu.jsp" %>

                <div class="contents">
                <div id="map" style="width:500px;height:400px;"></div>
                <hr>
                    <h2>버스도착정보</h2>
                        <div id="buttonArray">
                            
                        </div>
                    <hr>
                    <table id="busTable"></table>
                    <hr>
                    <table id="busInfoArr"></table>
                </div>
        </div>
        <script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
        <script type="text/javascript">
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
        mapOption = { 
            center: new kakao.maps.LatLng(37.43881304598, 126.67508465357916), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };

    var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

    // 지도에 클릭 이벤트를 등록합니다
    // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
        
        // 클릭한 위도, 경도 정보를 가져옵니다 
        var latlng = mouseEvent.latLng;
        
        var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
        message += '경도는 ' + latlng.getLng() + ' 입니다';
        
        
        console.log('클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고,경도는 ' + latlng.getLng() + ' 입니다')
        getBusSttnList(latlng.getLat(), latlng.getLng());
        
    });
        </script>
        <script type="text/javascript">
            $(document).ready(function(){
                getBusSttnList(37.43881304598, 126.67508465357916)
            });

            function getBusSttnList(lati, longti){
                $.ajax({
                    type:"get",
                    url:"getBusSttn",
                    data:{
                        "lati": lati,
                        "longti" : longti
                    },
                    dataType : "json",
                    success : function(sttnList){
                        console.log(sttnList);
                        createButton(sttnList);
                    }
                })
            }
        </script>
        <script type="text/javascript">
            function createButton(sttnList){
                let buttonArrayEl = document.getElementById("buttonArray");
                buttonArrayEl.innerText = "";
                for(let sttn of sttnList){
                    let buttonTag = document.createElement("button");
                    buttonTag.innerText = sttn.nodeno + " " + sttn.nodenm;
                    buttonTag.setAttribute("onclick", "getBusArr('"+sttn.nodeid+"','"+sttn.citycode+"')");
                    console.log(buttonTag);
                    buttonArrayEl.appendChild(buttonTag);
                    		
                }
            }
        </script>
        <script type="text/javascript">
            function getBusArr(nodeId, citycode){
                console.log(nodeId);
                $.ajax({
                    type:"get",
                    url:"getBusArr",
                    data:{"nodeId":nodeId, "citycode":citycode},
                    dataType : "json",
                    success : function(arrInfoList){
                        console.log(arrInfoList);
                        printBusArrInfo(arrInfoList, citycode);
                        console.log(arrInfoList.length);
                        console.log("버스번호 : " + arrInfoList[0].routeno);
                        console.log("남은정류장 : " + arrInfoList[0].arrprevstationcnt);
                        console.log("도착예정시간 : "+ arrInfoList[0].arrtime);

                    }
                })

            }
            function printBusArrInfo(arrInfoList, citycode){
    		console.log("hello");
    		let arrListdiv = document.querySelector('#busTable');
    		arrListdiv.innerHTML = "";
    		
    		let trTag = document.createElement("tr");
            
    		let tdTag1 = document.createElement("td");
    		let tdTag2 = document.createElement("td");
    		let tdTag3 = document.createElement("td");
    		tdTag1.innerText = "버스번호";
    		trTag.appendChild(tdTag1);
            tdTag2.innerText = "남은정류장";
            trTag.appendChild(tdTag2);
            tdTag3.innerText = "남은 시간";
            trTag.appendChild(tdTag3);
            arrListdiv.appendChild(trTag);
			
			for(let arrList of arrInfoList){
			
			let arrdiv = document.createElement('tr');
			arrdiv.classList.add('arrdiv');
			
			<%--
			let routeno = document.createElement('td');
			routeno.classList.add("routeno");
			routeno.innerText = arrList.routeno + "번";
			arrdiv.appendChild(routeno);
			--%>
			
			let bttnTag = document.createElement("button");
			bttnTag.setAttribute("onclick", "getBusId('"+arrList.routeid+"','"+citycode+"')");
			bttnTag.setAttribute("style", "width:80px")
			bttnTag.innerText = arrList.routeno + "번";
			arrdiv.appendChild(bttnTag);
			
			let arrprev = document.createElement('td');
			arrprev.classList.add("arrprev");
			arrprev.innerText = arrList.arrprevstationcnt + "번째전"
			arrdiv.appendChild(arrprev);
			
			let arrtime = document.createElement('td');
			arrtime.classList.add("arrtime");
			arrtime.innerText = arrList.arrtime + "초"
			arrdiv.appendChild(arrtime);
			
			arrListdiv.appendChild(arrdiv);
				
			}
    	}
        </script>
        <script type="text/javascript">
        function getBusId(routeid, citycode){
        	console.log("차량아이디 :" + routeid);
        	console.log("도시코드 :" + citycode);
        	$.ajax({
        		type:"get",
        		url:"getBusLocation",
        		data:{"routeid":routeid, "citycode":citycode},
        		dataType:"json",
        		success: function(busLocationList){
        			console.log(busLocationList);
        			busInfoArr(busLocationList);
        			
        		}
        	})
        }
        </script>
        <script type="text/javascript">
        	function busInfoArr(busList){
        		let busarrListdiv = document.querySelector('#busInfoArr');
        		busarrListdiv.innerHTML = "";
        		
        		let trTag = document.createElement("tr");
                
        		let tdTag1 = document.createElement("td");
        		let tdTag2 = document.createElement("td");
        		let tdTag3 = document.createElement("td");
        		tdTag1.innerText = "버스번호";
        		trTag.appendChild(tdTag1);
                tdTag2.innerText = "현재 정류장";
                trTag.appendChild(tdTag2);
                tdTag3.innerText = "버스번호판";
                trTag.appendChild(tdTag3);
                busarrListdiv.appendChild(trTag);
    			
    			for(let bus of busList){
    			
    			let arrdiv = document.createElement('tr');
    			arrdiv.classList.add('arrdiv');
    			
    			<%--
    			let routeno = document.createElement('td');
    			routeno.classList.add("routeno");
    			routeno.innerText = arrList.routeno + "번";
    			arrdiv.appendChild(routeno);
    			--%>
    			
    			let routenm = document.createElement("td");
    			routenm.innerText = bus.routenm + "번";
    			arrdiv.appendChild(routenm);
    			
    			let arrprev = document.createElement('td');
    			arrprev.classList.add("arrprev");
    			arrprev.innerText = bus.nodenm + "정류장"
    			arrdiv.appendChild(arrprev);
    			
    			let arrtime = document.createElement('td');
    			arrtime.classList.add("arrtime");
    			arrtime.innerText = bus.vehicleno

    			arrdiv.appendChild(arrtime);
    			
    			busarrListdiv.appendChild(arrdiv);
    				
        	}
        	}
        </script>
        <script type="text/javascript">
            let msg = "${msg}";
            if (msg.length > 0) {
                alert(msg);
            }
        </script>
    </body>

    </html>