<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="WEATHER TEST"></c:set>
<%@ include file="../common/head.jspf"%>


<div>현재 날씨</div>
<div class="temp"></div>
<div class="place"></div>
<div class="desc"></div>


<script>

const API_KEY = '2d1119c77c14a77fee290dd58e72b536';

const callbackOk= (position) =>{
    console.log(position)
    const lat = position.coords.latitude //위도
    const lon = position.coords.longitude //경도
		console.log("현재 위치는 위도:" + lat + ", 경도:" + lon);
		const url = 'https://api.openweathermap.org/data/2.5/weather?lat=' +lat+ '&lon='+lon+ '&appid='+API_KEY + '&units=metric&lang=kr';
		console.log(url);
		fetch(url)
		.then(response => response.json())
		.then(data=>{
			console.log(data);
			
			const temperature = data.main.temp;
		    const place = data.name;
		    const description = data.weather[0].description;
		      
		    console.log('temperature: ' + temperature);
		    console.log('place: ' + place);
		    console.log('description: ' + description);
		    
		    // html 그리기
		    document.querySelector('.temp').innerText = 'Temperature: ' + temperature + '°C';
		    document.querySelector('.place').innerText = 'Place: ' + place;
		    document.querySelector('.desc').innerText = 'Description: ' + description;
		})
		
}
	
const callbackError= () =>{
    alert("위치정보를 찾을 수 없습니다.")
}

	navigator.geolocation.getCurrentPosition(callbackOk, callbackError);


	
</script>



<%@ include file="../common/foot.jspf"%>
