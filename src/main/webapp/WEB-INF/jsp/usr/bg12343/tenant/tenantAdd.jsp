<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="TENANT ADD"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<section class="mt-8 mb-5 text-lg px-4">
	<div class="mx-auto">
		<form action="../tenant/doTenantAdd" method="POST">
			<table class="write-box table-box-1" border="1">
				<tbody>
					<tr>
						<th>세입자명</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="세입자명을 입력해주세요" name="tenantName" />
						</td>
					</tr>
					<tr>
						<th>세입자휴대폰</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="세입자휴대폰을 입력해주세요" name="tenantPhone" />
						</td>
					</tr>
					<tr>
						<th>세입자차량번호</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="세입자차량번호를 입력해주세요" name="tenantCarNum" />
						</td>
					</tr>
					<tr>
						<th></th>
						<td>
							<input class="btn btn-outline btn-info" type="submit" value="완료" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-outline" type="button" onclick="history.back();">뒤로가기</button>
		</div>
	</div>
</section>





<%@ include file="../../common/foot.jspf"%>