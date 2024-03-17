<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="BUILDING MODIFY"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>



<script>
	var buildingModify__submitDone = false;

	function buildingModify__submit(form) {
		if (buildingModify__submitDone) {
			alert('이미 처리중입니다');
			return;
		}

		var bldgIdField = form.querySelector('input[name="bldgId"]');
		var bldgNameField = form.querySelector('input[name="bldgName"]');
		var bldgAddField = form.querySelector('input[name="bldgAdd"]');
		var roomNumFields = form.querySelectorAll('input[name="roomNum"]');
		var roomAreaFields = form.querySelectorAll('input[name="roomArea"]');
		var standardDepositFields = form
				.querySelectorAll('input[name="standardDeposit"]');
		var standardRentFields = form
				.querySelectorAll('input[name="standardRent"]');
		var standardJeonseFields = form
				.querySelectorAll('input[name="standardJeonse"]');

		// 건물 ID 체크
		if (bldgIdField.value.length < 1) {
			alert('건물 ID를 입력해주세요');
			bldgIdField.focus();
			return;
		}

		// 건물명 체크
		if (bldgNameField.value.length < 1) {
			alert('건물명을 입력해주세요');
			bldgNameField.focus();
			return;
		}

		// 건물 주소 체크
		if (bldgAddField.value.length < 1) {
			alert('건물 주소를 입력해주세요');
			bldgAddField.focus();
			return;
		}

		for (var i = 0; i < roomNumFields.length; i++) {
			var roomNumField = roomNumFields[i];
			var roomAreaField = roomAreaFields[i];
			var standardDepositField = standardDepositFields[i];
			var standardRentField = standardRentFields[i];
			var standardJeonseField = standardJeonseFields[i];

			if (roomNumField.value.length < 1) {
				alert('호실을 입력해주세요');
				roomNumField.focus();
				return;
			}

			// 숫자가 아닌 데이터 체크
			if (isNaN(roomAreaField.value)) {
				alert('방 면적에는 숫자만 입력 가능합니다');
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

		buildingModify__submitDone = true;
		form.submit();
	}
</script>


<section class="mt-2 text-xl px-4">
	<form action="../building/doBuildingModify" method="POST" onsubmit="buildingModify__submit(this); return false;">
		<div class="mx-auto overflow-x-auto">
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
					<tr>
						<td>${buildingRd.id }
							<input type="hidden" name="bldgId" value="${buildingRd.id }" />
						</td>
						<td>${buildingRd.regDate.substring(0,10) }</td>
						<td>
							<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="bldgName"
								value="${buildingRd.bldgName }" />
						</td>
						<td>
							<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="bldgAdd"
								value="${buildingRd.bldgAdd }" />
						</td>
						<td>${buildingRd.roomTotal }
							<input type="hidden" name="roomTotal" value="${buildingRd.roomTotal }" />
						</td>
						<td>
							<!-- 							<input size="30" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="bldgMemo" value="#" /> -->
							#
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<br />
		<!-- 호실정보 가져오기 -->
		<div class="mx-auto overflow-x-auto">
			<table class="table-box-1 table" border="1">
				<thead>
					<tr>
						<th>호실</th>
						<th>형태</th>
						<th>면적(m2)</th>
						<th>기준 보증금</th>
						<th>기준 월세</th>
						<th>기준 전세</th>
						<th>메모</th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="room" items="${rooms }">
						<input type="hidden" name="roomId" value="${room.id }" />
						<tr class="hover">
							<td>
								<input size="1" autocomplete="off" type="text" name="roomNum" value="${room.roomNum }" />
							</td>
							<td>
								<%-- 							<input size="1" autocomplete="off" type="text" name="roomType" value="${room.roomType }" /> --%>
								<select class="select select-bordered select-sm w-20 max-w-xs" name="roomType" data-value="${room.roomType }">
									<option value="상가">상가</option>
									<option value="원룸">원룸</option>
									<option value="1.5룸">1.5룸</option>
									<option value="투룸">투룸</option>
								</select>
							</td>
							<td>
								<input size="3" autocomplete="off" type="text" name="roomArea" value="${room.roomArea }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" name="standardDeposit" value="${room.standardDeposit }" />
							</td>
							<td>
								<input size="4" autocomplete="off" type="text" name="standardRent" value="${room.standardRent }" />
							</td>
							<td>
								<input size="6" autocomplete="off" type="text" name="standardJeonse" value="${room.standardJeonse }" />
							</td>
							<td>#</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<div>
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
			<input class="btn btn-info" type="submit" value="수정" />
		</div>
	</form>




</section>










<%@ include file="../../common/foot.jspf"%>