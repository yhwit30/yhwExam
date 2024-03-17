<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Add Find TEST"></c:set>
<%@ include file="../common/head.jspf"%>


<input type="text" id="sample6_postcode" placeholder="우편번호">
<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
<br>
<input type="text" id="sample6_address" placeholder="주소">
<br>
<input type="text" id="sample6_detailAddress" placeholder="상세주소">
<input type="text" id="sample6_extraAddress" placeholder="참고항목">


<!-- 지도 보이기 -->
<div id="map" style="width: 800px; height: 350px;"></div>
<p>
	<button onclick="setCenter()">지도 중심좌표 이동시키기</button>
</p>

<!-- 우편api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 지도api -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62&libraries=services"
></script>

<!-- 지도 및 위도경도 변수 -->
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = { 
    center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
var lat; // 위도
var lon; // 경도
</script>

<!-- 주소찾기 및 지도 실행함수 -->
<script>
function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === 'R') {
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== '') {
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample6_extraAddress").value = extraAddr;

            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample6_detailAddress").focus();

            // 위도 및 경도 좌푯값 구하기
            var geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch(data.roadAddress, (result, status) => {
                if (status === kakao.maps.services.Status.OK) {
                    console.log('위도 : ' + result[0].y);
                    console.log('경도 : ' + result[0].x);

                    // 위도, 경도 변수에 저장
                    lat = result[0].y;
                    lon = result[0].x;

                    // 지도에 표시
                    setCenter();
                }
            });
        }
    }).open();
}

// 주소에서 얻은 위도,경도로 지도 이동 및 마커 추가
function setCenter() {
    // 이동할 위도 경도 위치를 생성합니다
    var moveLatLon = new kakao.maps.LatLng(lat, lon);

    // 지도를 띄울 div 요소를 지정합니다
    var mapContainer = document.getElementById('map');

    // 지도 객체를 생성합니다
    var map = new kakao.maps.Map(mapContainer, {
        center: moveLatLon,
        level: 3 // 지도 확대 레벨 설정
    });

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({
        position: moveLatLon,
        map: map
    });
}
</script>






<%@ include file="../common/foot.jspf"%>