package com.example.demo.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.service.DashboardService;
import com.example.demo.service.TenantService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.Dashboard;
import com.example.demo.vo.Room;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Tenant;

@Controller
public class UsrDashboardController {

	LocalDate now = LocalDate.now();
	int nowYear = now.getYear();

	@Autowired
	private Rq rq;

	@Autowired
	private DashboardService dashboardService;

	@Autowired
	private BuildingService buildingService;

	@Autowired
	private TenantService tenantService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/dashboard/dashboard")
	public String getDashboard(Model model, @RequestParam(defaultValue = "1") int bldgId) {

		// 건물별 보증금 등 합계 가져오기
		List<Dashboard> dashboard = dashboardService.getDashboard();
		
		// 건물 지도에 찍을 용도
		Building buildingRd = buildingService.getForPrintBuilding(bldgId);

		// 호실정보 가져오기
		List<Room> rooms = buildingService.getForPrintRooms(bldgId);
		int roomsCnt = rooms.size();

		// 입주율 가져오기(세입자수 / 호실수)
		List<Tenant> tenants = tenantService.getForPrintTenants(bldgId);
		int tenantCnt = tenants.size();
		double occupancyRate = dashboardService.getOccupancyRate(roomsCnt, tenantCnt);

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();
		model.addAttribute("buildings", buildings);

		model.addAttribute("buildingRd", buildingRd);
		model.addAttribute("dashboard", dashboard);
		model.addAttribute("rooms", rooms);
		model.addAttribute("roomsCnt", roomsCnt);
		model.addAttribute("occupancyRate", (int) occupancyRate);
		return "usr/bg12343/dashboard/dashboard";
	}

	@RequestMapping("/usr/bg12343/dashboard/rentStatus")
	public String getStatus(Model model, @RequestParam(defaultValue = "1") int bldgId, Integer year) {

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}
		List<Dashboard> rentStatus = dashboardService.getRentStatus(bldgId, year);
		

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		model.addAttribute("rentStatus", rentStatus);
		model.addAttribute("nowYear", nowYear);
		return "usr/bg12343/dashboard/rentStatus";
	}

	// ajax
	@RequestMapping("/usr/bg12343/dashboard/doRentStatusAdd")
	@ResponseBody
	public String doRentStatusAdd(Model model, int tenantId, String body, int year, String month) {

		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		Dashboard rentStatusRd = dashboardService.getRentStatusRd(tenantId, year, month);

		System.out.println(tenantId);
		System.out.println(body);
		System.out.println(year);
		System.out.println(month);

		// 이미 데이터가 있다면 추가하면 안됨
		if (rentStatusRd != null) {
			return Ut.jsHistoryBack("F-1", "add 이미 있음");
		}

		// 수납현황 추가
		dashboardService.addRentStatus(tenantId, body, year, month);

		// ajax 위한 데이터 가져오기
		rentStatusRd = dashboardService.getRentStatusRd(tenantId, year, month);
		return rentStatusRd.getPaymentStatus();
	}

	// ajax
	@RequestMapping("/usr/bg12343/dashboard/doRentStatusModify")
	@ResponseBody
	public String doRentStatusModify(int tenantId, String body, int year, String month) {

		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		Dashboard rentStatusRd = dashboardService.getRentStatusRd(tenantId, year, month);

		// 데이터가 표 안에 있어서 jshistoryback이 안 먹혀서 null로 둠
		if (rentStatusRd == null) {
			return null;
		}

		// 수납현황 수정
		dashboardService.modifyRentStatus(tenantId, body, year, month);

		// ajax 위한 데이터 가져오기
		rentStatusRd = dashboardService.getRentStatusRd(tenantId, year, month);
		return rentStatusRd.getPaymentStatus();
	}

	// ajax
	@RequestMapping("/usr/bg12343/dashboard/doRentStatusDelete")
	@ResponseBody
	public void doRentStatusDelete(int tenantId, String body, int year, String month) {

		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		// 나중에 회원체크 userCanDelete 메소드 가져다 써야함(articleService)

		// 삭제할 데이터 있는지 체크
		Dashboard rentStatusRd = dashboardService.getRentStatusRd(tenantId, year, month);
		if (rentStatusRd == null) {
			return;
		}

		// 수납현황 삭제
		dashboardService.deleteRentStatus(tenantId, body, year, month);

	}

	@RequestMapping("/usr/bg12343/dashboard/reportBusiness")
	public String showNotice(Model model, @RequestParam(defaultValue = "1") int bldgId, Integer year) {

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		// 현황 데이터 가져오기
		List<Dashboard> rentStatus = dashboardService.getRentStatus(bldgId, year);

//				건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();
		model.addAttribute("buildings", buildings);

		model.addAttribute("rentStatus", rentStatus);
		model.addAttribute("nowYear", nowYear);
		return "usr/bg12343/dashboard/reportBusiness";
	}

}
