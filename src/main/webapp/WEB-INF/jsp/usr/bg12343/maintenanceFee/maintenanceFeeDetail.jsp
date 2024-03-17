<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MAINTENANCE FEE DETAIL"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<section class="mt-2 text-xl px-4">
	<div class="btns">
		<a class="btn btn-outline" href="../maintenanceFee/maintenanceFee?bldgId=${param.bldgId }">월별 관리비 돌아가기</a>
	</div>

	건물: ${building.bldgName } ${param.month }월

	<div class="mx-auto overflow-x-auto">
		<table class="table-box-1" border="1">
			<thead>
				<tr>
					<th>호실</th>
					<th>세입자</th>
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
					<th>고지서 출력</th>

				</tr>
			</thead>
			<tbody>

				<c:forEach var="maintenanceFee" items="${maintenanceFees }">
					<tr class="hover">
						<td>${maintenanceFee.roomNum }</td>
						<td>${maintenanceFee.tenantName }</td>
						<td>${maintenanceFee.leaseType }</td>
						<td>${maintenanceFee.commonElec }</td>
						<td>${maintenanceFee.commonWater }</td>
						<td>${maintenanceFee.elevater }</td>
						<td>${maintenanceFee.internetTV }</td>
						<td>${maintenanceFee.fireSafety }</td>
						<td>${maintenanceFee.waterUse }</td>
						<td>${maintenanceFee.waterCost }</td>
						<td>${maintenanceFee.waterBill }</td>
						<td>${maintenanceFee.elecUse }</td>
						<td>${maintenanceFee.elecCost }</td>
						<td>${maintenanceFee.elecBill }</td>
						<td>${maintenanceFee.gasUse }</td>
						<td>${maintenanceFee.gasCost }</td>
						<td>${maintenanceFee.gasBill }</td>
						<td>${maintenanceFee.monthlyMaintenanceFee }</td>
						<td>${maintenanceFee.lateFee }</td>
						<td>${maintenanceFee.lateMaintenanceFee }</td>
						<td>${maintenanceFee.maintenanceFeeDate }</td>
						<td>
							<c:if test="${maintenanceFee.tenantName != null }">
								<a class="btn btn-sm"
									href="../maintenanceFee/pdfExport?tenantId=${maintenanceFee.tenantId }&bldgId=${param.bldgId }&month=${param.month}"
									target="_blank"
								>PDF</a>
							</c:if>
							<c:if test="${maintenanceFee.tenantName != null }">
								<a class="btn btn-sm" href="../maintenanceFee/csvExport?tenantId=${maintenanceFee.tenantId }&bldgId=${param.bldgId }&month=${param.month}">CSV</a>  <!-- csv는 브라우저가 못 읽어서 새창열기 알됨 -->
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<div class="btns mt-5">
		<a class="btn btn-outline" href="../maintenanceFee/maintenanceFeeModify?bldgId=${param.bldgId }&month=${param.month}">수정</a>
		<a class="btn btn-outline" onclick="if(confirm('정말 삭제하시겠습니까?') == false) return false;" href="#">삭제(todo)</a>
	</div>

</section>




<%@ include file="../../common/foot.jspf"%>