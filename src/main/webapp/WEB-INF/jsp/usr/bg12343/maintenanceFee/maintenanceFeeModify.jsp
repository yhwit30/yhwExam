<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MAINTENANCE_FEE MODIFY"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<script>
document.addEventListener('DOMContentLoaded', function() {
	 // 폼의 ID를 사용하여 폼 요소를 가져옵니다.
    const form = document.getElementById('maintenanceFeeModifyForm');

    form.addEventListener('submit', function(event) {
        // 이벤트 기본 동작을 중단합니다.
        event.preventDefault();

        // 필요한 이름으로 입력 필드를 가져옵니다.
        const commonElecInput = form.querySelector('input[name="commonElec"]');
        const commonWaterInput = form.querySelector('input[name="commonWater"]');
        const elevInput = form.querySelector('input[name="elevater"]');
        const internetInput = form.querySelector('input[name="internetTV"]');
        const fireSafetyInput = form.querySelector('input[name="fireSafety"]');
        const waterCostInput = form.querySelector('input[name="waterCost"]');
        const elecCostInput = form.querySelector('input[name="elecCost"]');
        const gasCostInput = form.querySelector('input[name="gasCost"]');

        // 모든 입력 필드를 확인하여 값이 비어 있는지 확인합니다.
        if (commonElecInput.value.trim() === '' ||
            commonWaterInput.value.trim() === '' ||
            elevInput.value.trim() === '' ||
            internetInput.value.trim() === '' ||
            fireSafetyInput.value.trim() === '' ||
            waterCostInput.value.trim() === '' ||
            elecCostInput.value.trim() === '' ||
            gasCostInput.value.trim() === '') {
            // 값이 비어 있는 입력 필드가 있으면 제출을 중단하고 알림을 표시합니다.
            alert('모든 입력칸을 채워주세요.');
            return false; // 폼 제출을 중단합니다.
        }

        // 값이 비어 있지 않으면 폼을 제출합니다.
        form.submit();
    });
});
</script>


<section class="mt-2 text-xl px-4">
	<div class="btns">
		<a class="btn btn-outline" href="../maintenanceFee/maintenanceFee?bldgId=${param.bldgId }">월별 관리비 돌아가기</a>
	</div>
	${param.month }월

	<div class="mx-auto overflow-x-auto">

		<form id="maintenanceFeeModifyForm" action="../maintenanceFee/doMaintenanceFeeModify" method="POST">
			<input type="hidden" name="bldgId" value="${param.bldgId }" />
			<input type="hidden" name="month" value="${param.month }" />
			<table class="table-box-1" border="1">
				<thead>
					<tr>

						<td colspan="4">한번에 입력</td>
						<td>
							<input id="bulkWriteCommonElec" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td>
							<input id="bulkWriteCommonWater" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td>
							<input id="bulkWriteElev" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td>
							<input id="bulkWriteInternet" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td>
							<input id="bulkWriteFireSafety" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td></td>
						<td>
							<input id="bulkWriteWaterCost" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td></td>
						<td></td>
						<td>
							<input id="bulkWriteElecCost" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td></td>
						<td></td>
						<td>
							<input id="bulkWriteGasCost" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>건물명</th>
						<th>호실</th>
						<th>세입자명</th>
						<th>임대형태</th>
						<th>공동전기</th>
						<th>공동수도</th>
						<th>엘레베이터</th>
						<th>인터넷티비</th>
						<th>소방안전</th>
						<th>수도사용</th>
						<th>수도단가</th>
						<th>수도금액</th>
						<th>전기사용</th>
						<th>전기단가</th>
						<th>전기금액</th>
						<th>가스사용</th>
						<th>가스단가</th>
						<th>가스금액</th>
						<th>당월계</th>
						<th>연체료</th>
						<th>납기후 금액</th>
						<th>납부일</th>

					</tr>
				</thead>

				<tbody>

					<c:forEach var="maintenanceFee" items="${maintenanceFee }">
						<input type="hidden" name="tenantId" value="${maintenanceFee.tenantId }" />
						<tr>
							<td>${maintenanceFee.bldgName }</td>
							<td>${maintenanceFee.roomNum }</td>
							<td>${maintenanceFee.tenantName }</td>
							<td>${maintenanceFee.leaseType }</td>
							<td>
								<input class="commonElecInput" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요"
									name="commonElec" value="${maintenanceFee.commonElec }"
								/>
							</td>
							<td>
								<input class="commonWaterInput" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요"
									name="commonWater" value="${maintenanceFee.commonWater }"
								/>
							</td>
							<td>
								<input class="elevInput" size="2" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="elevater"
									value="${maintenanceFee.elevater }"
								/>
							</td>
							<td>
								<input class="internetInput" size="2" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="internetTV"
									value="${maintenanceFee.internetTV }"
								/>
							</td>
							<td>
								<input class="fireSafetyInput" size="2" autocomplete="off" type="text" placeholder="내용을 입력해주세요"
									name="fireSafety" value="${maintenanceFee.fireSafety }"
								/>
							</td>
							<td>
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="waterUse"
									value="${maintenanceFee.waterUse }"
								/>
							</td>
							<td>
								<input class="waterCostInput" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="waterCost"
									value="${maintenanceFee.waterCost }"
								/>
							</td>
							<td>${maintenanceFee.waterBill }</td>
							<td>
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="elecUse"
									value="${maintenanceFee.elecUse }"
								/>
							</td>
							<td>
								<input class="elecCostInput" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="elecCost"
									value="${maintenanceFee.elecCost }"
								/>
							</td>
							<td>${maintenanceFee.elecBill }</td>
							<td>
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="gasUse"
									value="${maintenanceFee.gasUse }"
								/>
							</td>
							<td>
								<input class="gasCostInput" size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="gasCost"
									value="${maintenanceFee.gasCost }"
								/>
							</td>
							<td>${maintenanceFee.gasBill }</td>
							<td>${maintenanceFee.monthlyMaintenanceFee }</td>
							<td>${maintenanceFee.lateFee }</td>
							<td>${maintenanceFee.lateMaintenanceFee }</td>
							<td>
								<input size="1" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="maintenanceFeeDate"
									value="${maintenanceFee.maintenanceFeeDate }"
								/>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div>
				<input class="btn btn-info" type="submit" value="수정" />
			</div>
		</form>

	</div>


</section>



<script>

//공통 전기 값 변경
const bulkWriteCommonElecInput = document.getElementById('bulkWriteCommonElec');
const commonElecInputs = document.querySelectorAll('.commonElecInput');

bulkWriteCommonElecInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 commonElecInput 입력 필드에 같은 값을 설정
    commonElecInputs.forEach(input => input.value = value);
});

// 공통 수도 값 변경
const bulkWriteCommonWaterInput = document.getElementById('bulkWriteCommonWater');
const commonWaterInputs = document.querySelectorAll('.commonWaterInput');

bulkWriteCommonWaterInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 commonWaterInput 입력 필드에 같은 값을 설정
    commonWaterInputs.forEach(input => input.value = value);
});

// 엘리베이터 값 변경
const bulkWriteElevInput = document.getElementById('bulkWriteElev');
const elevInputs = document.querySelectorAll('.elevInput');

bulkWriteElevInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 elevInput 입력 필드에 같은 값을 설정
    elevInputs.forEach(input => input.value = value);
});

// 인터넷 값 변경
const bulkWriteInternetInput = document.getElementById('bulkWriteInternet');
const internetInputs = document.querySelectorAll('.internetInput');

bulkWriteInternetInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 internetInput 입력 필드에 같은 값을 설정
    internetInputs.forEach(input => input.value = value);
});

// 소방 안전 값 변경
const bulkWriteFireSafetyInput = document.getElementById('bulkWriteFireSafety');
const fireSafetyInputs = document.querySelectorAll('.fireSafetyInput');

bulkWriteFireSafetyInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 fireSafetyInput 입력 필드에 같은 값을 설정
    fireSafetyInputs.forEach(input => input.value = value);
});

// 수도 비용 값 변경
const bulkWriteWaterCostInput = document.getElementById('bulkWriteWaterCost');
const waterCostInputs = document.querySelectorAll('.waterCostInput');

bulkWriteWaterCostInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 waterCostInput 입력 필드에 같은 값을 설정
    waterCostInputs.forEach(input => input.value = value);
});

// 전기 비용 값 변경
const bulkWriteElecCostInput = document.getElementById('bulkWriteElecCost');
const elecCostInputs = document.querySelectorAll('.elecCostInput');

bulkWriteElecCostInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 elecCostInput 입력 필드에 같은 값을 설정
    elecCostInputs.forEach(input => input.value = value);
});

// 가스 비용 값 변경
const bulkWriteGasCostInput = document.getElementById('bulkWriteGasCost');
const gasCostInputs = document.querySelectorAll('.gasCostInput');

bulkWriteGasCostInput.addEventListener('input', function() {
    const value = this.value;
    // 모든 gasCostInput 입력 필드에 같은 값을 설정
    gasCostInputs.forEach(input => input.value = value);
});

  
</script>







<%@ include file="../../common/foot.jspf"%>