<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="API TEST3"></c:set>

<%@ include file="../common/head.jspf"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>지도 생성하기</title>

</head>
<body>
	<!-- 지도를 표시할 div 입니다 -->
	<div id="map" style="width: 100%; height: 350px;"></div>

	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62"></script>
	<script>
		async function getData2() {
			const API_KEY = '%2BczOQiKpEnorU9I8TbELu0DP9c3DNrENiO4%2Fn2%2Fz5h4ecmec6LdcOy2WXWcHP%2F2TCPAQmHpPoCmhv%2FvFogSagQ%3D%3D';
			const url = 'https://www.yuseong.go.kr/ys_parking/ysparkingList/ORP/getJSONData.do?_wadl&type=json';
			const response = await fetch(url);
			const data = await response.json();
			console.log("data", data);
		}

		getData2();

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			level : 3
		// 지도의 확대 레벨
		};

		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption);
	</script>
</body>
</html>

<%@ include file="../common/foot.jspf"%>