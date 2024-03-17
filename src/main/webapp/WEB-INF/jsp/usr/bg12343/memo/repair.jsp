<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REPAIR"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>

<br /><br /><br />
<div style="text-align : center">
달력! 
</div>
<br />

<section class="mt-2 text-xl px-4">
	<div class="mx-auto overflow-x-auto">
		<div class="badge badge-outline">${memoRepairCnt }개</div>
		<table class="table-box-1" border="1">
			<colgroup>
				<col style="width: 10%" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>제목</th>
					<th>건물</th>
					<th>호실</th>
					<th>세입자</th>
					<th>보수 일자</th>

				</tr>
			</thead>
			<tbody>

				<c:forEach var="memoRepair" items="${memoRepair }">
					<tr class="hover">
						<td>${memoRepair.id }</td>
						<td>${memoRepair.regDate.substring(0,10) }</td>
						<td><a href="repairDetail?id=${memoRepair.id }">${memoRepair.title }</a></td>
						<td>${memoRepair.bldgName }</td>
						<td>${memoRepair.roomNum }</td>
						<td>${memoRepair.tenantName }</td>
						<td>${memoRepair.repairDate }</td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>




</section>





<%@ include file="../../common/foot.jspf"%>