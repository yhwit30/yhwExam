<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="TENANT MODIFY"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

<section class="mt-2 text-xl px-4">
	<div class="mx-auto overflow-x-auto">
		<div class="badge badge-outline">${tenantsCnt }개</div>


		<form action="../tenant/doTenantModify" method="POST">

			<table class="modify-box table-box-1" border="1">
				<thead>
					<tr>
						<!-- 						<th>세입자관리번호</th> -->
						<th>건물명</th>
						<th>호실</th>
						<th>세입자명</th>
						<th>세입자휴대폰</th>
						<th>세입자차량</th>
						<th>보증금</th>
						<th>월세</th>
						<th>관리비</th>
						<th>계약시작일</th>
						<th>계약만료일</th>
						<th>보증금납부일</th>
						<th>세 납기일</th>
					</tr>
				</thead>

				<tbody>

					<c:forEach var="tenant" items="${tenants }">
						<input type="hidden" name="id" value="${tenant.id }" />
						<tr>
							<%-- 							<td>${tenant.id }</td> --%>
							<td>${tenant.bldgName }
								<input type="hidden" name="bldgName" value="${tenant.bldgName }" />
							</td>
							<td>${tenant.roomNum }
								<input type="hidden" name="roomNum" value="${tenant.roomNum }" />
							<td>
								<input size="2" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantName"
									value="${tenant.tenantName }" />
							<td>
								<input size="9" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantPhone"
									value="${tenant.tenantPhone }" />
							</td>
							<td>
								<input size="4" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantCarNum"
									value="${tenant.tenantCarNum }" />
							</td>
							<!-- 이 아래로 hidden으로 값은 넘겨줬지만 사용은 안했다. 나중에 쓸지도? -->
							</td>
							<td>${tenant.deposit }
								<input type="hidden" name="deposit" value="${tenant.deposit }" />
							</td>
							<td>${tenant.rent }
								<input type="hidden" name="rent" value="${tenant.rent }" />
							</td>
							<td>${tenant.maintenanceFee }
								<input type="hidden" name="maintenanceFee" value="${tenant.maintenanceFee }" />
							</td>
							<td>${tenant.contractStartDate }
								<input type="hidden" name="contractStartDate" value="${tenant.contractStartDate }" />
							</td>
							<td>${tenant.contractEndDate }
								<input type="hidden" name="contractEndDate" value="${tenant.contractEndDate }" />
							</td>
							<td>${tenant.depositDate }
								<input type="hidden" name="depositDate" value="${tenant.depositDate }" />
							</td>
							<td>${tenant.rentDate }
								<input type="hidden" name="rentDate" value="${tenant.rentDate }" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="btns mt-5">
				<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
				<input class="btn btn-info" type="submit" value="수정" />
			</div>
		</form>

	</div>


</section>







<%@ include file="../../common/foot.jspf"%>