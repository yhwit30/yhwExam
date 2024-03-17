<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="API TEST"></c:set>

<%@ include file="../common/head.jspf"%>

<script>
	
	async function getData() {
		const API_KEY = '%2BczOQiKpEnorU9I8TbELu0DP9c3DNrENiO4%2Fn2%2Fz5h4ecmec6LdcOy2WXWcHP%2F2TCPAQmHpPoCmhv%2FvFogSagQ%3D%3D';
		const url = 'https://apis.data.go.kr/6300000/openapi2022/shard/getshard?serviceKey='+ API_KEY +'&pageNo=1&numOfRows=5';
		const response = await fetch(url);
		const data = await response.json();
		console.log("data", data);
	}
	
	getData();
	
	async function getData2() {
		const API_KEY = '%2BczOQiKpEnorU9I8TbELu0DP9c3DNrENiO4%2Fn2%2Fz5h4ecmec6LdcOy2WXWcHP%2F2TCPAQmHpPoCmhv%2FvFogSagQ%3D%3D';
		const url = 'https://www.yuseong.go.kr/ys_parking/ysparkingList/ORP/getJSONData.do?_wadl&type=json';
		const response = await fetch(url);
		const data = await response.json();
		console.log("data", data);
	}
	
	getData2();
	
	
</script>

<%@ include file="../common/foot.jspf"%>