<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="CONTRACT MODIFY"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

<section class="mt-2 text-xl px-4">
	<form action="../contract/doContractModify" method="POST">
	<input type="hidden" name="bldgId" value="${param.bldgId }" />
		<div class="mx-auto overflow-x-auto">
			<div class="badge badge-outline">${contractsCnt }개</div>

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
						<th>보증금 납기일</th>
						<th>월세 납기일</th>
						<th>계약메모</th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="contract" items="${contracts }">
						<input type="hidden" name="id" value="${contract.id }" />
						<tr class="hover">
							<td>${contract.id }</td>
							<td>${contract.regDate.substring(0,10) }</td>
							<td>${contract.updateDate.substring(0,10) }</td>
							<td>${contract.bldgName }</td>
							<td>${contract.roomNum }</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="tenantName"
									value="${contract.tenantName }" />
							</td>
							<td>
								<select class="select select-bordered select-sm w-20 max-w-xs" name="leaseType"	data-value="${contract.leaseType }">
									<option value="월세">월세</option>
									<option value="전세">전세</option>
									<option value="반전세">반전세</option>
								</select>
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="deposit"
									value="${contract.deposit }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="rent" value="${contract.rent }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="maintenanceFee"
									value="${contract.maintenanceFee }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="contractStartDate"
									value="${contract.contractStartDate }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="contractEndDate"
									value="${contract.contractEndDate }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="depositDate"
									value="${contract.depositDate }" />
							</td>
							<td>
								<input size="5" autocomplete="off" type="text" placeholder="내용을 입력해주세요" name="rentDate"
									value="${contract.rentDate }" />
							</td>
							<td>#</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<div class="btns mt-5">
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
			<input class="btn btn-info" type="submit" value="수정" />
		</div>
	</form>


</section>



<%@ include file="../../common/foot.jspf"%>