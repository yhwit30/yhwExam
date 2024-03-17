<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="DASHBOARD"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<style>
.pie-chart {
	position: relative;
	display: inline-block;
	width: 150px;
	height: 150px;
	border-radius: 50%;
	transition: 0.3s;
}

span.center {
	background: #fff;
	display: block;
	position: absolute;
	top: 50%;
	left: 50%;
	width: 70px;
	height: 70px;
	border-radius: 50%;
	text-align: center;
	line-height: 100px;
	font-size: 15px;
	transform: translate(-50%, -50%);
}
</style>


<section class="mt-2 text-xl px-4 flex justify-between">
	<div class="overflow-x-auto">
		<table class="table-box-1" border="1" style="width: 600px;">
			<thead>
				<tr>
					<th>건물명</th>
					<th>세대수</th>
					<th>보증금 합계</th>
					<th>월세 합계</th>
					<th>관리비 합계</th>
					<th>수익률(연)</th>
					<th>입주율</th>

				</tr>
			</thead>
			<tbody>

				<c:forEach var="dashboard" items="${dashboard }">
					<tr style="${dashboard.bldgId == param.bldgId ? 'background-color: #ff8c00' : '' }">
						<td>${dashboard.bldgName }</td>
						<td>${dashboard.roomTotal }</td>
						<td>${dashboard.depositSum }</td>
						<td>${dashboard.rentSum }</td>
						<td>${dashboard.maintenanceFeeSum }</td>
						<td>#</td>
						<td>#</td>
					</tr>
				</c:forEach>

			</tbody>
		</table>

	</div>

	<div class="pie-chart pie-chart1 mr-5">
		<span class="center">입주율${occupancyRate}%</span>
	</div>
	<!-- 지도 보이기 -->
	<div class="mr-5" id="map" style="width: 200px; height: 200px;"></div>
	<div
		style="width: 200px; border-radius: 10px; text-align: left; background: linear-gradient(to right, rgba(79, 195, 247, 0.6), rgba(0, 147, 196, 0.6));"
	>
		<div>건물: '${buildingRd.bldgName }'의 날씨</div>
		<div class="temp"></div>
		<div class="place"></div>
		<div class="desc"></div>
		<img class="weatherIcon" />
	</div>

</section>

<br />


<section class="mt-2 text-xl px-4">
	<!-- 건물 카테고리 버튼 -->
	<div>
		<c:forEach var="building" items="${buildings }">
			<a class="btn btn-sm btn-outline ${building.id == param.bldgId ? 'btn-active' : '' }"
				href="../dashboard/dashboard?bldgId=${building.id }"
			>${building.bldgName }</a>
		</c:forEach>

	</div>

	<!-- 대쉬보드 표 -->
	<div class="badge badge-outline">${roomsCnt }개</div>
	<table class="table-box-1" border="1">
		<thead>
			<tr>
				<th>호실</th>
				<th>호실형태</th>
				<th>면적(m2)</th>
				<th>세입자명</th>
				<th>현 보증금</th>
				<th>현 월세</th>
				<th>현 관리비</th>
				<!-- 				<th>비품(여기에도 나타낼지 고민)</th> -->
				<th>호실메모</th>

			</tr>
		</thead>
		<tbody>

			<c:forEach var="room" items="${rooms }">
				<tr class="hover">
					<td>${room.roomNum }</td>
					<td>${room.roomType }</td>
					<td>${room.roomArea }</td>
					<td>${room.tenantName }</td>
					<td>${room.deposit }</td>
					<td>${room.rent }</td>
					<td>${room.maintenanceFee }</td>
					<!-- 					<td> -->
					<!-- 						<input class="input input-bordered input-sm max-w-xs w-10" value="1" /> -->
					<!-- 						2 -->
					<!-- 						<input type="checkbox" class="toggle toggle-sm" checked /> -->
					<!-- 						3 -->
					<!-- 						<input type="checkbox" checked="checked" class="checkbox checkbox-sm checkbox-primary" /> -->
					<!-- 						4 -->
					<!-- 						<div class="rating rating-xs"> -->
					<!-- 							<input type="radio" name="rating-5" class="mask mask-star-2 bg-orange-400" checked /> -->
					<!-- 						</div> -->
					<!-- 					</td> -->
					<td>#</td>

				</tr>
			</c:forEach>
		</tbody>
	</table>
</section>


<script>
	$(window).ready(function() {
		draw(${occupancyRate}, '.pie-chart1', '#ff8c00');
// 		draw(50, '.pie-chart2', '#8b22ff');
// 		draw(30, '.pie-chart3', '#ff0');
	});

	function draw(max, classname, colorname) {
		var i = 1;
		var func1 = setInterval(function() {
			if (i <= max) {
				color1(i, classname, colorname);
				i++;
			} else {
				clearInterval(func1);
			}
		}, 10);
	}
	function color1(i, classname, colorname) {
		$(classname).css(
				{
					"background" : "conic-gradient(" + colorname + " 0% " + i
							+ "%, #ffffff " + i + "% 100%)"
				});
	}
</script>



<!-- 날씨 api -->
<script>

const API_KEY = '2d1119c77c14a77fee290dd58e72b536';

const getWeatherByCoordinates = (latitude, longitude) =>{
		console.log("현재 위치는 위도:" + latitude + ", 경도:" + longitude);
		const url = 'https://api.openweathermap.org/data/2.5/weather?lat=' +latitude+ '&lon='+longitude+ '&appid='+API_KEY + '&units=metric&lang=kr';
		console.log(url);
		fetch(url)
		.then(response => response.json())
		.then(data=>{
			console.log(data);
			
			const temperature = data.main.temp;
		    const place = data.name;
		    const description = data.weather[0].description;
		    const weatherIcon = data.weather[0].icon;
		    const weatherIconAdrs = 'http://openweathermap.org/img/wn/' + weatherIcon + '@2x.png';
		      
		    console.log('temperature: ' + temperature);
		    console.log('place: ' + place);
		    console.log('description: ' + description);
		    
		    
		    // html 그리기
		    document.querySelector('.temp').innerText = '온도: ' + temperature + '°C';
		    document.querySelector('.place').innerText = '장소: ' + place;
		    document.querySelector('.desc').innerText = '날씨: ' + description;
		    document.querySelector('.weatherIcon').setAttribute('src', weatherIconAdrs);
		})
		
}

getWeatherByCoordinates(${buildingRd.latitude}, ${buildingRd.longitude});

// const callbackOk = (position) => {
//     console.log(position);
//     const lat = position.coords.latitude; //위도
//     const lon = position.coords.longitude; //경도
//     console.log("현재 위치는 위도:" + lat + ", 경도:" + lon);
// }

// const callbackError= () =>{
//     alert("위치정보를 찾을 수 없습니다.")
// }

// navigator.geolocation.getCurrentPosition(callbackOk, callbackError);

</script>




<!-- 지도api -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62&libraries=services"
></script>

<!-- 지도 및 위도경도 변수 선언 -->
<script>
    var map;
    var mapContainer = document.getElementById('map'); // 지도를 표시할 div 

    function initMap() {
        var mapOption = {
            center : new kakao.maps.LatLng(${buildingRd.latitude}, ${buildingRd.longitude}), // 지도의 중심좌표
            level : 3 // 지도의 확대 레벨
        };

        map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        // 지도에 표시
        setCenter(${buildingRd.latitude}, ${buildingRd.longitude});
    }

    // 주소에서 얻은 위도,경도로 지도 이동 및 마커 추가
    function setCenter(lat, lon) {
        // 마커가 표시될 위치를 생성합니다
        var markerPosition = new kakao.maps.LatLng(lat, lon);

        // 중심 좌표를 변경하여 지도의 중심을 설정합니다
        map.setCenter(markerPosition);

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({
            position : markerPosition,
            map: map // 마커가 지도 위에 표시되도록 설정합니다
        });
    }

    // 페이지 로드 시 initMap 함수를 호출하여 지도를 초기화합니다
    document.addEventListener("DOMContentLoaded", function() {
        initMap();
    });
</script>


<%@ include file="../../common/foot.jspf"%>