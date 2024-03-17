<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REPORT BUSINESS"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

 pdf 출력기능 추가


<section class="mt-2 text-xl px-4">
	<!-- 건물 카테고리 버튼 -->
	<div>
		<c:forEach var="building" items="${buildings }">
			<a class="btn btn-sm btn-outline ${building.id == param.bldgId ? 'btn-active' : '' }"
				href="../dashboard/reportBusiness?bldgId=${building.id }"
			>${building.bldgName }</a>
		</c:forEach>
	</div>

	<!-- 연도 버튼 -->
	<a class="btn btn-sm btn-outline ${param.year == nowYear -1 ? 'btn-active' : '' }"
		href="reportBusiness?bldgId=${param.bldgId }&year=${nowYear -1}"
	>전년도 보기</a>
	<a class="btn btn-sm btn-outline ${param.year == nowYear ? 'btn-active' : '' }"
		href="reportBusiness?bldgId=${param.bldgId }&year=${nowYear}"
	>올해(${nowYear}) 보기</a>

	<!-- 사업장 현황신고표 -->
	<div class="mx-auto overflow-x-auto">
		<table class="table-box-1" border="1">
			<c:forEach var="rentStatus" items="${rentStatus }">
				<thead>

					<tr>
						<th>호실</th>
						<th>호실형태</th>
						<th>임대료</th>
						<th>1월</th>
						<th>2월</th>
						<th>3월</th>
						<th>4월</th>
						<th>5월</th>
						<th>6월</th>
						<th>7월</th>
						<th>8월</th>
						<th>9월</th>
						<th>10월</th>
						<th>11월</th>
						<th>12월</th>
						<th>비고</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td rowspan="2">${rentStatus.roomNum }</td>
						<td rowspan="2">${rentStatus.roomType }</td>
						<c:choose>
							<c:when test="${rentStatus.leaseType eq '전세'}">
								<td>전세 보증금</td>
							</c:when>
							<c:when test="${rentStatus.leaseType eq '반전세'}">
								<td>반전세 보증금</td>
							</c:when>
							<c:when test="${rentStatus.leaseType eq null}">
								<td rowspan="2">공실</td>
							</c:when>
							<c:otherwise>
								<td>월세 보증금</td>
							</c:otherwise>
						</c:choose>

						<!-- 월별 납부보증금 -->
						<c:forEach var="month" begin="1" end="12">
							<c:set var="paymentStatusVar" value="paymentStatus${month}" />

							<td>
								<c:if test="${not empty rentStatus[paymentStatusVar]}">
									<span>${rentStatus.deposit}</span>
								</c:if>
							</td>
						</c:forEach>
						<td>#</td>
					</tr>
					<tr>
						<c:choose>
							<c:when test="${rentStatus.leaseType eq '전세'}">
								<td>전세</td>
							</c:when>
							<c:when test="${rentStatus.leaseType eq null}">
							</c:when>
							<c:otherwise>
								<td>납부 월세</td>
							</c:otherwise>

						</c:choose>

						<!-- 월별 납부월세 -->
						<c:forEach var="month" begin="1" end="12">
							<c:set var="paymentStatusVar" value="paymentStatus${month}" />
							<td>
								<c:if test="${not empty rentStatus[paymentStatusVar]}">
									<span>${rentStatus.rent}</span>
								</c:if>
							</td>
						</c:forEach>
						<td>#</td>
					</tr>


					<!-- 세입자 정보 -->
					<c:if test="${rentStatus.leaseType != null}">
						<tr>
							<td>세입자 정보</td>
							<td>${rentStatus.tenantName }</td>
							<td>${rentStatus.tenantPhone }</td>

						</tr>
					</c:if>
				</tbody>
				<tr>
					<td colspan="16">
						<br>
						<!-- 단위별로 줄바꿈 -->
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</section>



<%@ include file="../../common/foot.jspf"%>