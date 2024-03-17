<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="CONTRACT ADD"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

<!-- 건물을 선택할 때 해당 호실을 불러오기 -->
<script>
	// 페이지 로드 시 기본값으로 bldgId를 1로 설정하고 호실 목록을 가져옴
	window.onload = function() {
		var defaultBldgId = 1;
		buildingSelect(defaultBldgId);
	};

	function buildingSelect(bldgId) {
		console.log('bldgId:' + bldgId);

		$.post({
			url : '/usr/bg12343/contract/getRoomsForContract',
			type : 'POST',
			data : {
				bldgId : bldgId
			},
			success : function(data) {
				console.log(data);

				// 기존 option태그 초기화
				var roomSelect = document.getElementById("roomNum");
				roomSelect.innerHTML = "";

				// 가져온 호실데이터를 option 태그로 그려주기
				data.forEach(function(room) {
					var option = document.createElement("option");
					option.value = room.id;
					option.text = room.roomNum;
					roomSelect.appendChild(option);
				});
			},
			error : function(xhr, status, error) {
				alert('수정에 실패했습니다: ' + error);
			}
		});
	}
</script>




<section class="mt-8 mb-5 text-lg px-4">
	<div class="mx-auto">
		<table class="table-box-1" border="1">
			<thead>
				<tr>
					<th>건물명</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<select class="select select-bordered select-sm w-20 max-w-xs" name="bldgId" onchange="buildingSelect(this.value)">
							<c:forEach var="building" items="${buildings }">
								<option value="${building.id }">${building.bldgName }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</tbody>
		</table>


		<br />

		<form action="../contract/doContractAdd" method="POST" onsubmit="contractAdd__submit(this); return false;">
			<table class="table-box-1 table" border="1">
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
					<tr>
						<td>
							<!-- 호실 선택 -->
							<select class="select select-bordered select-sm w-20 max-w-xs" name="roomId" id="roomNum">
								<!--ajax에서 option 태그를 그려준다 -->
							</select>
						<td>
							<select class="select select-bordered select-sm w-20 max-w-xs" name="leaseType">
								<option value="월세">월세</option>
								<option value="전세">전세</option>
								<option value="반전세">반전세</option>
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