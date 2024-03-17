<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="BUILDING DETAIL"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

<script>
	var buildingAdd__submitDone = false;

	function buildingAdd__submit(form) {

		if (buildingAdd__submitDone) {
			alert('이미 처리중입니다');
			return;
		}

		// 빈칸에 대한 유효성 검사 추가
		if (form.bldgName.value.length < 1) {
			alert('건물명을 입력해주세요');
			form.bldgName.focus();
			return;
		}

		if (form.roomTotal.value.length < 1) {
			alert('세대수를 입력해주세요');
			form.roomTotal.focus();
			return;
		}
		if (form.bldgAdd.value.length < 1) {
			alert('건물주소를 입력해주세요');
			form.bldgAdd.focus();
			return;
		}

		// 숫자가 아닌 데이터 체크
		if (isNaN(form.roomTotal.value)) {
			alert('세대수에는 숫자만 입력 가능합니다');
			form.roomTotal.focus();
			return;
		}

		ReplyWrite__submitDone = true;
		form.submit();

	}
</script>




<style>
/* 로그인 디자인 */
.write-box {
	width: 200px; /*이거 안 먹고있음*/
	margin-left: auto;
	margin-right: auto;
	white-space: nowrap;
	border: 1px solid rgba(255, 0, 0, 0.1);
	text-align: center;
	white-space: nowrap;
}

.write-box>thead tr {
	background: linear-gradient(to right, #536976, #292e49);
}

.write-box>thead th {
	color: white;
}

.write-box>tbody th {
	font-size: 14px;
}

.write-box th, td {
	border: 1px solid rgba(255, 0, 0, 0.1);
}

.address {
	text-align: left;
}

.address>input {
	margin-bottom: 5px;
}

section input::placeholder {
	font-size: 14px;
}

section input {
	font-size: 14px;
}
</style>


<section class="mt-8 mb-5 text-lg px-4 flex justify-around">
	<div class="px-4">
		<form action="/usr/bg12343/building/doBuildingSetupAdd" method="POST"
			onsubmit="buildingAdd__submit(this); return false;"
		>
			<table class="write-box" border="1">
				<thead>
					<tr>
						<th colspan="2">BUILDING ADD</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>건물명</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="건물이름을 입력해주세요" name="bldgName"
							/>
						</td>
					</tr>
					<tr>
						<th>세대수</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="세대수를 입력해주세요" name="roomTotal"
							/>
						</td>
					</tr>
					<tr>
						<th>건물주소</th>
						<td class="address">
							<input type="text" id="sample6_postcode" placeholder="우편번호">
							<input class="btn btn-sm btn-outline ml-12" type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
							<br>
							<input type="text" id="sample6_address" placeholder="주소">
							<br>
							<input type="text" id="sample6_detailAddress" placeholder="상세주소">
							<input type="text" id="sample6_extraAddress" placeholder="참고항목">

							<!-- 건물주소값 hidden으로 넘기기 -->
							<input type="hidden" name="bldgAdd" value="" />
							<!-- 주소 위도경고값 hidden으로 넘기기 -->
							<input type="hidden" name="latitude" value="" />
							<input type="hidden" name="longitude" value="" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input class="btn btn-outline btn-info" type="submit" value="완료" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
	<!-- 지도 보이기 -->
	<div id="map" style="width: 500px; height: 350px; display: none"></div>
</section>



<!-- 우편api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 지도api -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=426dd75f75d2eb88e4ae8811cf3bce62&libraries=services"
></script>

<!-- 지도 및 위도경도 변수 선언 -->
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
		center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		level : 3
	// 지도의 확대 레벨
	};

	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
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

                    // 위도, 경도 변수에 저장
                    var latitude = result[0].y;
                    var longitude = result[0].x;

                    // 지도에 표시
                    setCenter(latitude, longitude);
                    
//                     위도/경도 값을 hidden input 태그의 value에 설정하기
                    document.querySelector('input[name="bldgAdd"]').value = addr;
                    document.querySelector('input[name="latitude"]').value = latitude;
                    document.querySelector('input[name="longitude"]').value = longitude;
                    console.log('addr'+addr);
                    console.log('latitude'+latitude);
                    console.log('longitude'+longitude);
                }
            });
            
        }
    }).open();
}

//상세주소 입력이 완료될 때마다 hidden input 태그의 value를 설정합니다.
document.getElementById("sample6_detailAddress").addEventListener("input", function() {
    var detailAddress = this.value;
    document.querySelector('input[name="bldgAdd"]').value = document.getElementById("sample6_address").value + ' ' + detailAddress;
    
});
    
// 주소에서 얻은 위도,경도로 지도 이동 및 마커 추가
function setCenter(lat, lon) {
    // 마커가 표시될 위치를 생성합니다
    var markerPosition   = new kakao.maps.LatLng(lat, lon);

    // 지도를 띄울 div 요소를 지정합니다
    var mapContainer = document.getElementById('map');
    mapContainer.style.display = "block"; 

    // 지도 객체를 생성합니다
    var map = new kakao.maps.Map(mapContainer, {
        center: markerPosition,
        level: 3 // 지도 확대 레벨 설정
    });

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({
        position: markerPosition  ,
    });
 // 마커가 지도 위에 표시되도록 설정합니다
    marker.setMap(map);

    var iwContent = '<div class="info" style="padding:5px; text-align: center;">여기 맞나요!</div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
        iwPosition = new kakao.maps.LatLng(lat, lon); //인포윈도우 표시 위치입니다

    // 인포윈도우를 생성합니다
    var infowindow = new kakao.maps.InfoWindow({
        position : iwPosition, 
        content : iwContent 
    });
      
    // 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
    infowindow.open(map, marker); 
   
    // 인포윈도우가 표시된 후에 스타일 변경을 위한 코드를 추가합니다.
    var infoElement = document.querySelector(".info");
    var grandParentElement = infoElement.parentNode.parentNode;
    grandParentElement.style.width = "110px";

}
</script>





<%@ include file="../../common/foot.jspf"%>