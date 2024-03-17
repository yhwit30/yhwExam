<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MEMO ADD"></c:set>
<%@ include file="../../common/head.jspf"%>
<%@ include file="../../common/sidebar.jspf"%>


<section class="mt-8 mb-5 text-lg px-4">
	<div class="mx-auto">
		<form action="../bg12343/memo/doMemoAdd" method="POST">
			<table class="write-box table-box-1" border="1">
				<tbody>
					<tr>
						<th>건물명</th>
						<td>
							<select class="select select-bordered select-sm w-full max-w-xs" name="bldgId">
								<option value=1>건물 가나</option>
								<option value=2>건물 다라</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>호실</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="호실을 입력해주세요" name="roomNum"
							/>
						</td>
					</tr>
					<tr>
						<th>방 형태</th>
						<td>
							<select class="select select-bordered select-sm w-full max-w-xs" name="roomType">
								<option value="상가">상가</option>
								<option value="원룸">원룸</option>
								<option value="1.5룸">1.5룸</option>
								<option value="투룸">투룸</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="제목을 입력해주세요" name="title"
							/>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<input class="input input-bordered input-secondary w-full max-w-xs" autocomplete="off" type="text"
								placeholder="메모내용을 입력해주세요" name="body"
							/>
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