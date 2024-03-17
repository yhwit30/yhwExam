<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="BUILDING DETAIL"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>



<h1 style="text-align: center; background-color: pink;">전체 건물 목록</h1>
<section class="mt-2 text-xl px-4">
	<div class="mx-auto overflow-x-auto flex justify-around">
		<table class="table-box-1 mr-5">
			<thead>
				<tr class="bgc">
					<th>번호</th>
					<th>등록날짜</th>
					<th>건물명</th>
					<th>건물주소</th>
					<th>전체호실수</th>
					<th>건물메모</th>
					<th>수정</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="building" items="${buildings }">
					<tr style="${building.id == param.bldgId ? 'background-color: #ff8c00' : '' }">
						<td>${building.id }</td>
						<td>${building.regDate.substring(0,10) }</td>
						<td>${building.bldgName }</td>
						<td>${building.bldgAdd }</td>
						<td>${building.roomTotal }</td>
						<td>#</td>
						<td>
							<a class="btn btn-sm btn-outline" href="../building/buildingModify?bldgId=${building.id }">수정</a>
							<a class="btn btn-sm btn-outline"
								onclick="if(confirm('건물과 호실정보가 모두 삭제됩니다.\n정말 삭제하시겠습니까?') == false) return false;"
								href="../building/doBuildingDelete?bldgId=${building.id}"
							>삭제</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

<!-- 지도 보이기 -->
<div id="map" style="width: 300px; height: 200px;"></div>
	</div>

<!-- 지도api -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62&libraries=services"></script>

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




	<div class="mt-2" style="text-align: left">
		<a class="btn btn-m btn-outline" href="/usr/bg12343/building/buildingAdd"> 건물 추가</a>
	</div>

	<br />

	<!-- 건물 카테고리 버튼 -->
	<div>
		<c:forEach var="building" items="${buildings }">
			<a class="btn btn-sm btn-outline ${building.id == param.bldgId ? 'btn-active' : '' }"
				href="building?bldgId=${building.id }"
			>${building.bldgName }</a>
		</c:forEach>
		호실 목록 1: 전자렌지 2: 냉장고 3: 침대 4: 전기렌지
	</div>

	<div class="badge badge-outline">${roomsCnt }개</div>
	<!-- 호실정보 가져오기 -->
	<div class="mx-auto overflow-x-auto">
		<table class="table-box-1" border="1">
			<thead>
				<tr>
					<th>호실</th>
					<th>형태</th>
					<th>면적(m2)</th>
					<th>기준 보증금</th>
					<th>기준 월세</th>
					<th>기준 전세</th>
					<th>비품(todo)</th>
					<th>메모</th>
				</tr>
			</thead>
			<tbody>

				<c:forEach var="room" items="${rooms }">
					<tr class="hover">
						<td>${room.roomNum }</td>
						<td>${room.roomType }</td>
						<td>${room.roomArea }</td>
						<td>${room.standardDeposit }</td>
						<td>${room.standardRent }</td>
						<td>${room.standardJeonse }</td>
						<td>
							<input class="input input-bordered input-sm max-w-xs w-10" value="1" />
							2
							<input type="checkbox" class="toggle toggle-sm" checked />
							3
							<input type="checkbox" checked="checked" class="checkbox checkbox-sm checkbox-primary" />
							4
							<div class="rating rating-xs">
								<input type="radio" name="rating-5" class="mask mask-star-2 bg-orange-400" checked />
							</div>
						</td>
						<td>#</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>



</section>




<%@ include file="../../common/foot.jspf"%>