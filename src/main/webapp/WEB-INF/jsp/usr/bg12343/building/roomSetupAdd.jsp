<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="ROOM SETUP"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<!-- 입력값 유효성 검사 -->
<script>
	var roomAdd__submitDone = false;

	function roomAdd__submit(form) {
		if (roomAdd__submitDone) {
			alert('이미 처리중입니다');
			return;
		}

		for (var i = 0; i < form.roomNum.length; i++) {
			var roomNumField = form.roomNum[i];
			var roomTypeField = form.roomType[i];
			var roomAreaField = form.roomArea[i];
			var standardDepositField = form.standardDeposit[i];
			var standardRentField = form.standardRent[i];
			var standardJeonseField = form.standardJeonse[i];

			 // 숫자가 아닌 데이터 체크
            if (isNaN(roomNumField.value)) {
                alert('호실에는 숫자만 입력 가능합니다');
                roomAreaField.focus();
                return;
            }

			 if (isNaN(roomAreaField.value)) {
                alert('방 면적에는 숫자(소수점가능)만 입력 가능합니다');
                roomAreaField.focus();
                return;
            }

            if (isNaN(standardDepositField.value)) {
                alert('기준 보증금에는 숫자만 입력 가능합니다');
                standardDepositField.focus();
                return;
            }

            if (isNaN(standardRentField.value)) {
                alert('기준 월세에는 숫자만 입력 가능합니다');
                standardRentField.focus();
                return;
            }

            if (isNaN(standardJeonseField.value)) {
                alert('기준 전세에는 숫자만 입력 가능합니다');
                standardJeonseField.focus();
                return;
            }
			
			// 빈칸에 대한 유효성 검사 추가
			if (roomNumField.value.length < 1) {
				alert('호실을 입력해주세요');
				roomNumField.focus();
				return;
			}

			if (roomTypeField.value === "") {
				alert('방 형태를 선택해주세요');
				roomTypeField.focus();
				return;
			}

			if (roomAreaField.value.length < 1) {
				alert('면적을 입력해주세요');
				roomAreaField.focus();
				return;
			}

			if (standardDepositField.value.length < 1) {
				alert('기준 보증금을 입력해주세요');
				standardDepositField.focus();
				return;
			}

			if (standardRentField.value.length < 1) {
				alert('기준 월세를 입력해주세요');
				standardRentField.focus();
				return;
			}

			if (standardJeonseField.value.length < 1) {
				alert('기준 전세를 입력해주세요');
				standardJeonseField.focus();
				return;
			}
		}

		roomAdd__submitDone = true;
		form.submit();

	}
</script>






<section class="mt-8 mb-5 text-lg px-4">
	<div class="mx-auto">
		<form action="/usr/bg12343/building/doRoomAdd" method="POST" onsubmit="roomAdd__submit(this); return false;">
			<table class="table-box-1" border="1">
				<thead>
					<tr>
						<th>번호</th>
						<th>등록날짜</th>
						<th>건물명</th>
						<th>건물주소</th>
						<th>전체호실수</th>
						<th>건물메모</th>
					</tr>
				</thead>
				<tbody>

					<tr class="hover">
						<td>${addedBuilding.id }</td>
						<td>${addedBuilding.regDate.substring(0,10) }</td>
						<td>${addedBuilding.bldgName }</td>
						<td>${addedBuilding.bldgAdd }</td>
						<td>${addedBuilding.roomTotal }</td>
						<td>#</td>
					</tr>
				</tbody>
			</table>

			<br />

			<div class="badge badge-outline">${addedBuilding.roomTotal }개</div>
			<table class="table-box-1" border="1">
				<thead>
					<tr>
						<th>번호</th>
						<th>호실</th>
						<th>방 형태</th>
						<th>방 면적(m2)</th>
						<th>기준 보증금</th>
						<th>기준 월세</th>
						<th>기준 전세</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="i" begin="1" end="${addedBuilding.roomTotal }">
						<input type="hidden" name="bldgId" value="${addedBuilding.id }" />
						<tr>
							<td>${i }</td>
							<td>
								<input size="1" autocomplete="off" type="text" placeholder="호실을 입력해주세요" name="roomNum" />
							</td>
							<td>
								<select class="select select-bordered select-sm w-20 max-w-xs" name="roomType">
									<option value="상가">상가</option>
									<option value="원룸" selected>원룸</option>
									<option value="1.5룸">1.5룸</option>
									<option value="투룸">투룸</option>
								</select>
							</td>
							<td>
								<input size="2" autocomplete="off" type="text" placeholder="면적을 입력해주세요" name="roomArea" />
							</td>
							<td>
								<input size="6" autocomplete="off" type="text" placeholder="기준 보증금을 입력해주세요" name="standardDeposit" />
							</td>
							<td>
								<input size="6" autocomplete="off" type="text" placeholder="기준 월세를 입력해주세요" name="standardRent" />
							</td>
							<td>
								<input size="6" autocomplete="off" type="text" placeholder="기준 전세을 입력해주세요" name="standardJeonse" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		<input class="btn btn-outline btn-info" type="submit" value="완료" />
		</form>
		<div class="btns">
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>






<%@ include file="../../common/foot.jspf"%>