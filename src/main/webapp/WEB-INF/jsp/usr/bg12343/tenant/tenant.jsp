<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="TENANT DETAIL"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>



<!-- 세입자 수정 ajax -->
<script>
	// 버튼 토글 함수
	function toggleModifybtn(tenantId) {
		console.log('tenantId:' + tenantId);

		$('#modify-btn-' + tenantId).hide();
		$('#save-btn-' + tenantId).show();

		// 해당 row에 있는 모든 태그를 input으로 변경(class 사용)
		var existingCells = document.querySelectorAll('.existing-cell-'
				+ tenantId);
		var inputFields = document.querySelectorAll('.input-field-' + tenantId);

		existingCells.forEach(function(cell) {
			$(cell).hide(); // jQuery의 hide() 메서드 사용
		});
		inputFields.forEach(function(field) {
			$(field).show(); // jQuery의 show() 메서드 사용
		});

	}

	// 수정 함수
	function doModifyTenant(tenantId) {

		// 해당 tenanttId를 가진 form 요소를 선택합니다.
		var form = $('#modify-form');

		// 수정할 데이터를 가져옵니다.
		var tenantName = form.find('input[name="tenantName-' + tenantId + '"]')
				.val();
		var tenantPhone = form.find(
				'input[name="tenantPhone-' + tenantId + '"]').val();
		var tenantCarNum = form.find(
				'input[name="tenantCarNum-' + tenantId + '"]').val();

		// 공백 체크
		if (String(tenantName).trim() === ''
				|| String(tenantPhone).trim() === ''
				|| String(tenantCarNum).trim() === '') {
			alert('공백을 채워주세요');
			return;
		}

		$.post({
			url : '/usr/bg12343/tenant/doTenantModifyAjax',
			type : 'POST',
			data : {
				tenantId : tenantId,
				tenantName : tenantName,
				tenantPhone : tenantPhone,
				tenantCarNum : tenantCarNum
			},
			success : function(data) {
				$('#modify-btn-' + tenantId).show();
				$('#save-btn-' + tenantId).hide();

				// 데이터를 성공적으로 가져왔다면 각 요소에 데이터를 그려줍니다.(id 사용)
				$('#existing-cell-' + tenantId + '-tenantName').text(
						data.tenantName);
				$('#existing-cell-' + tenantId + '-tenantPhone').text(
						data.tenantPhone);
				$('#existing-cell-' + tenantId + '-tenantCarNum').text(
						data.tenantCarNum);

				// 입력값 박스 숨김(class 사용)
				var inputFields = document.querySelectorAll('.input-field-'
						+ tenantId);
				inputFields.forEach(function(field) {
					$(field).hide();

					// 수정된 데이터 보여주기(id 사용)
					$('#existing-cell-' + tenantId + '-tenantName').show();
					$('#existing-cell-' + tenantId + '-tenantPhone').show();
					$('#existing-cell-' + tenantId + '-tenantCarNum').show();

				});

			},
			error : function(xhr, status, error) {
				alert('수정에 실패했습니다: ' + error);
			}
		});
	}
</script>

<section class="mt-2 text-xl px-4">
	<a class="btn btn-sm btn-outline ${0 == param.bldgId ? 'btn-active' : '' }" href="../tenant/tenant?bldgId=0"> 전체보기</a>
	<!-- 건물 카테고리 버튼 -->
	<div>
		<c:forEach var="building" items="${buildings }">
			<a class="btn btn-sm btn-outline ${building.id == param.bldgId ? 'btn-active' : '' }"
				href="../tenant/tenant?bldgId=${building.id }"
			>${building.bldgName }</a>
		</c:forEach>
	</div>

	<!-- 세입자표 -->
	<div class="mx-auto overflow-x-auto">
		<div class="badge badge-outline">${tenantsCnt }명</div>
		<form onsubmit="return false;" method="POST" id="modify-form" action="/usr/bg12343/tenant/doTenantModifyAjax">
			<table class="table-box-1" border="1">
				<thead>
					<tr>
						<th>건물명</th>
						<th>호실</th>
						<th>세입자명</th>
						<th>세입자휴대폰</th>
						<th>세입자차량</th>
						<th>임대형태</th>
						<th>보증금</th>
						<th>월세</th>
						<th>관리비</th>
						<th>계약시작일</th>
						<th>계약만료일</th>
						<th>보증금납부일</th>
						<th>납부일</th>
						<th>메모</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="tenant" items="${tenants }">
						<tr class="hover">
							<td>${tenant.bldgName }</td>
							<td>${tenant.roomNum }</td>

							<td id="existing-cell-${tenant.id}-tenantName" class="existing-cell-${tenant.id}">${tenant.tenantName}</td>
							<td class="input-field-${tenant.id}" style="display: none;">
								<input size="3" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantName-${tenant.id}"
									value="${tenant.tenantName}"
								/>
							</td>
							<td id="existing-cell-${tenant.id}-tenantPhone" class="existing-cell-${tenant.id}">${tenant.tenantPhone}</td>
							<td class="input-field-${tenant.id}" style="display: none;">
								<input size="6" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantPhone-${tenant.id}"
									value="${tenant.tenantPhone}"
								/>
							</td>
							<td id="existing-cell-${tenant.id}-tenantCarNum" class="existing-cell-${tenant.id}">${tenant.tenantCarNum}</td>
							<td class="input-field-${tenant.id}" style="display: none;">
								<input size="4" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantCarNum-${tenant.id}"
									value="${tenant.tenantCarNum}"
								/>
							</td>


							<td>${tenant.leaseType }</td>
							<td>${tenant.deposit }</td>
							<td>${tenant.rent }</td>
							<td>${tenant.maintenanceFee }</td>
							<td>${tenant.contractStartDate }</td>
							<td>${tenant.contractEndDate }</td>
							<td>${tenant.depositDate }</td>
							<td>${tenant.rentDate }</td>
							<td>#</td>
							<td>
								<button onclick="toggleModifybtn('${tenant.id}');" id="modify-btn-${tenant.id}" style="white-space: nowrap"
									class="btn btn-xs btn-outline"
								>수정</button>
								<button onclick="doModifyTenant('${tenant.id}');" style="white-space: nowrap; display: none"
									id="save-btn-${tenant.id}" class="btn btn-xs btn-outline"
								>저장</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</form>
	</div>

	<div class="btns mt-5">
		<a class="btn btn-outline" href="../tenant/tenantModify?bldgId=${param.bldgId }">전체 수정</a>
		<a class="btn btn-outline" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" href="#">삭제</a>
	</div>
	<a class="btn btn-outline" href="/usr/bg12343/tenant/tenantAdd"> 세입자 추가(todo)</a>

</section>










<%@ include file="../../common/foot.jspf"%>