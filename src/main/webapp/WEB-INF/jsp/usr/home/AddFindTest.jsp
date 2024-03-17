<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Add Find TEST"></c:set>

<%@ include file="../common/head.jspf"%>


<!-- <div id="wrap" style="border: 1px solid; width: 500px; height: 400px; margin: 5px 0; position: relative"></div> -->

<input type="text" id="sample6_postcode" placeholder="우편번호">
<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
<input type="text" id="sample6_address" placeholder="주소"><br>
<input type="text" id="sample6_detailAddress" placeholder="상세주소">
<input type="text" id="sample6_extraAddress" placeholder="참고항목">

<!-- 지도 보이기 -->
<div id="map" style="width: 100%; height: 350px;"></div>
<p>
	<button onclick="setCenter()">지도 중심좌표 이동시키기</button>
</p>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62&libraries=services"
></script>

<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = { 
    center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
var lat; // 위도
var lon; // 경도


  // 우편번호 찾기 화면을 넣을 element

  const daumPostcode = () => {
    new daum.Postcode({
      oncomplete: data => {
        console.log('도로명주소 : ' + data.roadAddress);
        console.log('지번주소 : ' + data.jibunAddress);
        console.log('우편번호 : ' + data.zonecode);

        // 위도 및 경도 좌푯값 구하기
       var geocoder = new kakao.maps.services.Geocoder();
        geocoder.addressSearch(data.roadAddress, (result, status) => {
          if (status === kakao.maps.services.Status.OK) {
            console.log('위도 : ' + result[0].y);
            console.log('경도 : ' + result[0].x);
            
            // 위도, 경도 변수에 저장
            lat = result[0].y;
			lon = result[0].x;
            
          }
        });
      },
      })
  }

  daumPostcode();

  
  // 주소에서 얻은 위도,경도로 지도이동
  function setCenter() {            
      // 이동할 위도 경도 위치를 생성합니다 
      var moveLatLon = new kakao.maps.LatLng(lat, lon);
      
      // 지도 중심을 이동 시킵니다
      map.setCenter(moveLatLon);
      
      // 마커를 생성합니다
      var marker = new kakao.maps.Marker({
          position: moveLatLon
      });

      // 마커가 지도 위에 표시되도록 설정합니다 (마커가 중복체크되는 점 참고)
      marker.setMap(map);
  }


  
  
  
  

</script>




<%@ include file="../common/foot.jspf"%>