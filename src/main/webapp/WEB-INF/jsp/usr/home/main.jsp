<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="MAIN"></c:set>
<%@ include file="../common/head.jspf"%>


<div class="mainSearch">
	<form action="">
		<input type="hidden" name="boardId" value="${param.boardId }" />

		<select data-value="${param.searchKeywordTypeCode }" class="select select-bordered select-sm max-w-xs"
			name="searchKeywordTypeCode"
		>
			<option value="title">제목</option>
			<option value="extra__writer">작성자</option>
			<option value="body">내용</option>
		</select>
		<input value="${param.searchKeyword }" name="searchKeyword" type="text" placeholder="What is your searchKeyword?"
			class="input-sm input input-bordered w-60 max-w-xs mt-3"
		/>
		<button class="btn btn-primary btn-sm" type="submit">검색</button>
	</form>
</div>



<div class="page mt-10 main-page mx-auto">
	<div>
		<a class="btn btn-outline" href="/usr/bg12343/dashboard/dashboard?bldgId=1"> 임대현황DAHBOARD</a>
		<div class="menu">
			<a class="btn btn-outline" href="/usr/bg12343/building/building?bldgId=1"> 건물 현황</a>
		</div>
		<div class="menu">
			<a class="btn btn-outline" href="/usr/bg12343/dashboard/rentStatus?bldgId=1">수납관리</a>
		</div>
		<div class="menu">
			<a class="btn btn-outline" href="/usr/bg12343/maintenanceFee/maintenanceFee">관리비</a>
		</div>

	</div>
	<div>
		<a class="btn btn-outline" href="/usr/article/list">커뮤니티</a>
		<div class="menu">인기글</div>
		<div class="menu">최신글</div>
		<div class="menu">자유글</div>
	</div>
	<div>
		<a class="btn btn-outline" href="/usr/news/news">뉴스</a>
		<div class="menu">다음</div>
		<div class="menu">네이버</div>
		<div class="menu">구글</div>
	</div>


</div>


<style type="text/css">
.mainSearch {
	text-align: center;
}

.page {
	display: flex;
	border: 5px solid red;
	height: 500px;
	width: 1000px;
	justify-content: space-around;
}

.menu {
	width: 180px;
	height: 80px;
	/* 	border: 3px solid pink; */
	margin-left: auto;
	margin-right: auto;
	margin-bottom: 20px;
	margin-top: 10px;
	border-radius: 5px;
}

.main-page>div {
	text-align: center;
	width: 250px;
	height: 400px;
}

.main-page>div:nth-child(1) {
	border: 3px solid blue;
}

.main-page>div:nth-child(2) {
	border: 3px solid gold;
}

.main-page>div:nth-child(3) {
	border: 3px solid green;
}
</style>



<!-- 페이지 하단 -->
<%@ include file="../common/foot.jspf"%>