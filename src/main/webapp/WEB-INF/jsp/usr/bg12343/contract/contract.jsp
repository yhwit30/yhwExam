<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="CONTRACT DETAIL"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>



<!-- 계약 수정 ajax -->
<script>
	// 버튼 토글 함수
	function toggleModifybtn(contractId) {
		console.log('contractId:' + contractId);

		$('#modify-btn-' + contractId).hide();
		$('#save-btn-' + contractId).show();

		// 해당 row에 있는 모든 태그를 input으로 변경(class 사용)
		var existingCells = document.querySelectorAll('.existing-cell-'
				+ contractId);
		var inputFields = document.querySelectorAll('.input-field-'
				+ contractId);

		existingCells.forEach(function(cell) {
			$(cell).hide(); // jQuery의 hide() 메서드 사용
		});
		inputFields.forEach(function(field) {
			$(field).show(); // jQuery의 show() 메서드 사용
		});

	}

	// 수정 함수
	function doModifyContract(contractId) {

		// 해당 contractId를 가진 form 요소를 선택합니다.
		var form = $('#modify-form');

		// 수정할 데이터를 가져옵니다.
		var tenantName = form.find(
				'input[name="tenantName-' + contractId + '"]').val();
		var leaseType = form
				.find('select[name="leaseType-' + contractId + '"]').val();
		var deposit = form.find('input[name="deposit-' + contractId + '"]')
				.val();
		var rent = form.find('input[name="rent-' + contractId + '"]').val();
		var maintenanceFee = form.find(
				'input[name="maintenanceFee-' + contractId + '"]').val();
		var contractStartDate = form.find(
				'input[name="contractStartDate-' + contractId + '"]').val();
		var contractEndDate = form.find(
				'input[name="contractEndDate-' + contractId + '"]').val();
		var depositDate = form.find(
				'input[name="depositDate-' + contractId + '"]').val();
		var rentDate = form.find('input[name="rentDate-' + contractId + '"]')
				.val();

		// 공백 체크
		if (String(tenantName).trim() === '' || String(leaseType).trim() === ''
				|| String(deposit).trim() === '' || String(rent).trim() === ''
				|| String(maintenanceFee).trim() === ''
				|| String(contractStartDate).trim() === ''
				|| String(contractEndDate).trim() === ''
				|| String(depositDate).trim() === ''
				|| String(rentDate).trim() === '') {
			alert('공백을 채워주세요');
			return;
		}

		$.post({
			url : '/usr/bg12343/contract/doContractModifyAjax',
			type : 'POST',
			data : {
				contractId : contractId,
				tenantName : tenantName,
				leaseType : leaseType,
				deposit : deposit,
				rent : rent,
				maintenanceFee : maintenanceFee,
				contractStartDate : contractStartDate,
				contractEndDate : contractEndDate,
				depositDate : depositDate,
				rentDate : rentDate
			},
			success : function(data) {
				$('#modify-btn-' + contractId).show();
				$('#save-btn-' + contractId).hide();

				// 데이터를 성공적으로 가져왔다면 각 요소에 데이터를 그려줍니다.(id 사용)
				$('#existing-cell-' + contractId + '-tenantName').text(
						data.tenantName);
				$('#existing-cell-' + contractId + '-leaseType').text(
						data.leaseType);
				$('#existing-cell-' + contractId + '-deposit').text(
						data.deposit);
				$('#existing-cell-' + contractId + '-rent').text(data.rent);
				$('#existing-cell-' + contractId + '-maintenanceFee').text(
						data.maintenanceFee);
				$('#existing-cell-' + contractId + '-contractStartDate').text(
						data.contractStartDate);
				$('#existing-cell-' + contractId + '-contractEndDate').text(
						data.contractEndDate);
				$('#existing-cell-' + contractId + '-depositDate').text(
						data.depositDate);
				$('#existing-cell-' + contractId + '-rentDate').text(
						data.rentDate);

				// 입력값 박스 숨김(class 사용)
				var inputFields = document.querySelectorAll('.input-field-'
						+ contractId);
				inputFields.forEach(function(field) {
					$(field).hide();

					// 수정된 데이터 보여주기(id 사용)
					$('#existing-cell-' + contractId + '-tenantName').show();
					$('#existing-cell-' + contractId + '-leaseType').show();
					$('#existing-cell-' + contractId + '-deposit').show();
					$('#existing-cell-' + contractId + '-rent').show();
					$('#existing-cell-' + contractId + '-maintenanceFee')
							.show();
					$('#existing-cell-' + contractId + '-contractStartDate')
							.show();
					$('#existing-cell-' + contractId + '-contractEndDate')
							.show();
					$('#existing-cell-' + contractId + '-depositDate').show();
					$('#existing-cell-' + contractId + '-rentDate').show();

				});

			},
			error : function(xhr, status, error) {
				alert('수정에 실패했습니다: ' + error);
			}
		});
	}
</script>







<section class="mt-2 text-xl px-4">
	<a class="btn btn-sm btn-outline ${0 == param.bldgId ? 'btn-active' : '' }" href="../contract/contract?bldgId=0">
		전체보기</a>
	<!-- 건물 카테고리 버튼 -->
	<div>
		<c:forEach var="building" items="${buildings }">
			<a class="btn btn-sm btn-outline ${building.id == param.bldgId ? 'btn-active' : '' }"
				href="../contract/contract?bldgId=${building.id }">${building.bldgName }</a>
		</c:forEach>
	</div>

	<!-- 계약정보표 -->
	<div class="mx-auto overflow-x-auto">
		<div class="badge badge-outline">${contractsCnt }개</div>
		<!-- 수정기능 -->
		<form onsubmit="return false;" method="POST" id="modify-form" action="/usr/bg12343/contract/doContractModifyAjax">
			<table class="table-box-1" border="1">
				<thead>
					<tr>
						<th>계약번호</th>
						<th>등록일</th>
						<th>갱신일</th>
						<th>건물명</th>
						<th>호실번호</th>
						<th>세입자명</th>
						<th>임대형태</th>
						<th>보증금</th>
						<th>월세</th>
						<th>관리비</th>
						<th>계약시작일</th>
						<th>계약만료일</th>
						<th>보증금 납부일</th>
						<th>월세 납부일</th>
						<th>계약메모</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody>


					<c:forEach var="contract" items="${contracts }">
						<tr class="hover">
							<td>${contract.id }</td>
							<td>${contract.regDate.substring(0,10) }</td>
							<td>${contract.updateDate.substring(0,10) }</td>
							<td>${contract.bldgName }</td>
							<td>${contract.roomNum }</td>

							<!-- 여기부터 수정기능 들어감 -->
							<td id="existing-cell-${contract.id}-tenantName" class="existing-cell-${contract.id}">${contract.tenantName}</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantName-${contract.id}"
									value="${contract.tenantName}"
								/>
							</td>
							<td id="existing-cell-${contract.id}-leaseType" class="existing-cell-${contract.id}">${contract.leaseType}</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<select class="select select-bordered select-sm w-15 max-w-xs" name="leaseType-${contract.id}"
									data-value="${contract.leaseType}"
								>
									<option value="월세">월세</option>
									<option value="전세">전세</option>
									<option value="반전세">반전세</option>
								</select>
							</td>
							<td id="existing-cell-${contract.id}-deposit" class="existing-cell-${contract.id}">${contract.deposit }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="deposit-${contract.id}"
									value="${contract.deposit }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-rent" class="existing-cell-${contract.id}">${contract.rent }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="rent-${contract.id }"
									value="${contract.rent }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-maintenanceFee" class="existing-cell-${contract.id}">${contract.maintenanceFee }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="maintenanceFee-${contract.id}"
									value="${contract.maintenanceFee }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-contractStartDate" class="existing-cell-${contract.id}">${contract.contractStartDate }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="contractStartDate-${contract.id}"
									value="${contract.contractStartDate }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-contractEndDate" class="existing-cell-${contract.id}">${contract.contractEndDate }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="contractEndDate-${contract.id}"
									value="${contract.contractEndDate }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-depositDate" class="existing-cell-${contract.id}">${contract.depositDate }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="depositDate-${contract.id}"
									value="${contract.depositDate }"
								/>
							</td>
							<td id="existing-cell-${contract.id}-rentDate" class="existing-cell-${contract.id}">${contract.rentDate }</td>
							<td class="input-field-${contract.id}" style="display: none;">
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="rentDate-${contract.id}"
									value="${contract.rentDate }"
								/>
							</td>
							<td>#</td>

							<td>
								<button onclick="toggleModifybtn('${contract.id}');" id="modify-btn-${contract.id}" style="white-space: nowrap"
									class="btn btn-xs btn-outline"
								>수정</button>
								<button onclick="doModifyContract('${contract.id}');" style="white-space: nowrap; display: none"
									id="save-btn-${contract.id}" class="btn btn-xs btn-outline"
								>저장</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</form>
	</div>


	<div class="btns mt-5">
		<a class="btn btn-outline" href="../contract/contractAdd">추가</a>
		<a class="btn btn-outline" href="../contract/contractModify?bldgId=${param.bldgId }">전체 수정</a>
		<a class="btn btn-outline" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" href="#">삭제(todo)</a>
	</div>





</section>










<%@ include file="../../common/foot.jspf"%>