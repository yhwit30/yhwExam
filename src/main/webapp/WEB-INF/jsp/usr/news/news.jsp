<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="NEWS"></c:set>
<%@ include file="../common/head.jspf"%>



<h1>news page</h1>

<div class="news_from">daum</div>
<div class="news_box">
	<c:forEach var="daumNews" items="${daumNews }">

${daumNews }

</c:forEach>
</div>

<div class="news_from">naver</div>
<div class="news_box">
	<c:forEach var="naverNews" items="${naverNews }">

${naverNews }

</c:forEach>
</div>

<div class="news_from">google</div>
<div class="news_box">
	<c:forEach var="googleNews" items="${googleNews }">

${googleNews }

</c:forEach>
</div>


<style>
.news_box {
	width: 90%;
	height: 500px;
	border: 1px solid gold;
	margin-right: auto;
	margin-left: auto;
}

.news_from{
	text-align: center;
	background-color: pink;
}
</style>





<%@ include file="../common/foot.jspf"%>

