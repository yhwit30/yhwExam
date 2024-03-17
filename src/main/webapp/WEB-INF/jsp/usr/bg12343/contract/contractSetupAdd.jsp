<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="CONTRACT SETUP ADD"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<style>
.hidden-placeholder {
	color: transparent;
}
</style>


<script>
	function contractAdd__submit(form) {
		// 	입력값 유효성 검사 해야함
		form.submit();
	}

	// 미리 0 값을 준비해두고 빈칸인 채로 submit 경우 사용한다.
	// 사용자가 입력한 값이 존재하는 경우에만 값을 유지
	window.onload = function() {
		var inputs = document.querySelectorAll('input[type="text"]');
		inputs.forEach(function(input) {
			if (input.value.trim() === '') {
				input.value = '0';
				input.classList.add('hidden-placeholder');
			}
			input.addEventListener('focus', function() {
				if (input.value === '0') {
					input.value = '';
					input.classList.remove('hidden-placeholder');
				}
			});
			input.addEventListener('blur', function() {
				if (input.value.trim() === '') {
					input.value = '0';
					input.classList.add('hidden-placeholder');
				}
			});
		});
	}
</script>

<section class="mt-8 mb-5 text-lg px-4">
	<div class="mx-auto">
		<table class="table-box-1 table" border="1">
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
		<form action="../contract/doContractSetupAdd" method="POST" onsubmit="contractAdd__submit(this); return false;">
			<table class="table-box-1" border="1">
				<thead>
					<tr>
						<th>호실</th>
						<th>임대형태</th>
						<th>세입자명</th>
						<th>세입자휴대폰</th>
						<th>세입자차량번호</th>
						<th>보증금</th>
						<th>월세</th>
						<th>관리비</th>
						<th>계약시작일</th>
						<th>계약만료일</th>
						<th>보증금납부일</th>
						<th>월세 납부일</th>
					</tr>
				</thead>


				<tbody>
					<c:forEach var="room" items="${rooms }">
						<input type="hidden" name="roomId" value="${room.id }" />
							<tr>
								<td>${room.roomNum }</td>
								<td>
									<select class="select select-bordered select-sm w-20 max-w-xs" name="leaseType">
										<option value="월세">월세</option>
										<option value="전세">전세</option>
										<option value="반전세">반전세</option>
										<option value="0" selected>공실</option>
									</select>
								</td>
								<td>
									<input size="1" autocomplete="off" type="text" placeholder="세입자명을 입력해주세요" name="tenantName" />
								</td>
								<td>
									<input size="1" autocomplete="off" type="text" placeholder="세입자번호를 입력해주세요" name="tenantPhone" />
								</td>
								<td>
									<input size="1" autocomplete="off" type="text" placeholder="세입자번호를 입력해주세요" name="tenantCarNum" />
								</td>
								<td>
									<input size="1" autocomplete="off" type="text" placeholder="보증금을 입력해주세요" name="deposit" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="월세를 입력해주세요" name="rent" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="관리비를 입력해주세요" name="maintenanceFee" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="계약시작일을 입력해주세요" name="contractStartDate" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="계약만료일을 입력해주세요" name="contractEndDate" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="보증금납부일을 입력해주세요" name="depositDate" />
								</td>
								<td>
									<input size="3" autocomplete="off" type="text" placeholder="월세 납부일을 입력해주세요" name="rentDate" />
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