package com.example.demo.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.service.CsvService;
import com.example.demo.service.MaintenanceFeeService;
import com.example.demo.service.PdfService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.MaintenanceFee;
import com.example.demo.vo.ResultData;
import com.lowagie.text.DocumentException;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrMaintenanceFeeController {

	LocalDate now = LocalDate.now();
	int nowYear = now.getYear();

	@Autowired
	private MaintenanceFeeService maintenanceFeeService;

	@Autowired
	private BuildingService buildingService;

	@Autowired
	private PdfService pdfService;

	@Autowired
	private CsvService csvService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/maintenanceFee/maintenanceFee")
	public String getMaintenanceFee(Model model, @RequestParam(defaultValue = "1") int bldgId, Integer year) {

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		List<MaintenanceFee> maintenanceFeeMonthly = maintenanceFeeService.getMaintenanceFeeMonthly(bldgId, year);

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		model.addAttribute("maintenanceFeeMonthly", maintenanceFeeMonthly);
		model.addAttribute("nowYear", nowYear);
		return "usr/bg12343/maintenanceFee/maintenanceFee";
	}

	@RequestMapping("/usr/bg12343/maintenanceFee/maintenanceFeeDetail")
	public String getMaintenanceFeeDetail(Model model, @RequestParam(defaultValue = "1") int bldgId, Integer year,
			String month) {
		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		List<MaintenanceFee> maintenanceFees = maintenanceFeeService.getMaintenanceFees(bldgId, year, month);

		Building building = buildingService.getForPrintBuilding(bldgId);

		model.addAttribute("maintenanceFees", maintenanceFees);
		model.addAttribute("building", building);
		return "usr/bg12343/maintenanceFee/maintenanceFeeDetail";
	}

	@RequestMapping("/usr/bg12343/maintenanceFee/maintenanceFeeModify")
	public String showMaintenanceFeeModify(Model model, @RequestParam(defaultValue = "1") int bldgId, Integer year,
			String month) {
		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		List<MaintenanceFee> maintenanceFee = maintenanceFeeService.getMaintenanceFees(bldgId, year, month);

		model.addAttribute("maintenanceFee", maintenanceFee);
		return "usr/bg12343/maintenanceFee/maintenanceFeeModify";
	}

	@RequestMapping("/usr/bg12343/maintenanceFee/doMaintenanceFeeModify")
	@ResponseBody
	public String doMaintenanceFeeModify(int[] tenantId, int[] commonElec, int[] commonWater, int[] elevater,
			int[] internetTV, int[] fireSafety, int[] waterUse, int[] waterCost, int[] elecUse, int[] elecCost,
			int[] gasUse, int[] gasCost, int[] maintenanceFeeDate, int bldgId, Integer year, String month) {

		// 레포지터리 월표현 정리
		if (month.equals("010")) {
			month = "10";
		} else if (month.equals("011")) {
			month = "11";
		} else if (month.equals("012")) {
			month = "12";
		}

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		// 관리비 계산을 위한 배열생성
		int[] waterBills = new int[tenantId.length];
		int[] elecBills = new int[tenantId.length];
		int[] gasBills = new int[tenantId.length];
		int[] monthlyMaintenanceFees = new int[tenantId.length];
		int[] lateFees = new int[tenantId.length];
		int[] lateMaintenanceFees = new int[tenantId.length];

		// insert 실행- UX 생각해서 수정버튼으로 추가로 처리함
		MaintenanceFee maintenanceFee = null;
		for (int i = 0; i < tenantId.length; i++) {

			// 기존에 데이터가 없거나, tenantId가 0이 아닌 경우 insert 한다. 0을 거를 수 있는 이유는 sql을 not null로 했기
			// 때문일 것.
			int tenantCheck = tenantId[i];
			maintenanceFee = maintenanceFeeService.getMaintenanceFee(tenantId[i], bldgId, year, month);
			if (maintenanceFee == null && tenantCheck != 0) {

				int waterBill = maintenanceFeeService.calculateBill(waterUse[i], waterCost[i]);
				int elecBill = maintenanceFeeService.calculateBill(elecUse[i], elecCost[i]);
				int gasBill = maintenanceFeeService.calculateBill(gasUse[i], gasCost[i]);
				int monthlyMaintenanceFee = maintenanceFeeService.sumMaintenanceFee(commonElec[i], commonWater[i],
						elevater[i], internetTV[i], fireSafety[i], waterBill, elecBill, gasBill);
				int lateFee = maintenanceFeeService.caculateLateFee(monthlyMaintenanceFee);
				int lateMaintenanceFee = maintenanceFeeService.sumMaintenanceFee(monthlyMaintenanceFee, lateFee);

				maintenanceFeeService.addMaintenanceFee(tenantId[i], commonElec[i], commonWater[i], elevater[i],
						internetTV[i], fireSafety[i], waterUse[i], waterCost[i], waterBill, elecUse[i], elecCost[i],
						elecBill, gasUse[i], gasCost[i], gasBill, monthlyMaintenanceFee, lateFee, lateMaintenanceFee,
						maintenanceFeeDate[i], year, month);
			}
		}

		// 관리비 정보 수정
		ResultData maintenanceFeeModifyRd = null;

		for (int i = 0; i < tenantId.length; i++) {

			waterBills[i] = maintenanceFeeService.calculateBill(waterUse[i], waterCost[i]);
			elecBills[i] = maintenanceFeeService.calculateBill(elecUse[i], elecCost[i]);
			gasBills[i] = maintenanceFeeService.calculateBill(gasUse[i], gasCost[i]);
			monthlyMaintenanceFees[i] = maintenanceFeeService.sumMaintenanceFee(commonElec[i], commonWater[i],
					elevater[i], internetTV[i], fireSafety[i], waterBills[i], elecBills[i], gasBills[i]);
			lateFees[i] = maintenanceFeeService.caculateLateFee(monthlyMaintenanceFees[i]);
			lateMaintenanceFees[i] = maintenanceFeeService.sumMaintenanceFee(monthlyMaintenanceFees[i], lateFees[i]);

			maintenanceFeeModifyRd = maintenanceFeeService.modifyMaintenanceFee(tenantId[i], commonElec[i],
					commonWater[i], elevater[i], internetTV[i], fireSafety[i], waterUse[i], waterCost[i], waterBills[i],
					elecUse[i], elecCost[i], elecBills[i], gasUse[i], gasCost[i], gasBills[i],
					monthlyMaintenanceFees[i], lateFees[i], lateMaintenanceFees[i], maintenanceFeeDate[i], year, month);
		}

		return Ut.jsReplace(maintenanceFeeModifyRd.getResultCode(), maintenanceFeeModifyRd.getMsg(),
				"../maintenanceFee/maintenanceFeeDetail?bldgId=" + bldgId + "&month=" + month);
	}

	@RequestMapping("usr/bg12343/maintenanceFee/pdfExport")
	public void generatePDF(HttpServletResponse response, int tenantId, int bldgId, Integer year, String month)
			throws DocumentException, IOException {

		// RequestParam 기본값문법으로 nowYear 데이터가 잘 안 들어가서 이렇게 체크
		if (year == null) {
			year = nowYear;
		}

		// 파일 형식설정(없어도 되기는 한다?)
		response.setContentType("application/pdf");

		// pdf 파일에 시간정보 추가
		DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd:mm:ss");
		String currentDateTime = dateFormatter.format(new Date());

		// pdf 저장방식 설정
		String headerKey = "Content-Disposition";
		// 브라우저 새로 열어서 보여주기
		String headerValue = "inline; filename=pdf_" + currentDateTime + ".pdf";
		response.setHeader(headerKey, headerValue);

		pdfService.export(response, tenantId, bldgId, year, month);

	}

	@RequestMapping("usr/bg12343/maintenanceFee/csvExport")
	public void generateCSV(HttpServletResponse response, int tenantId, int bldgId, Integer year, String month) throws DocumentException, IOException {

		// csv 파일에 시간정보 추가
		DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd:mm:ss");
		String currentDateTime = dateFormatter.format(new Date());

		// csv 저장방식 설정
		response.setContentType("text/csv");
		String headerKey = "Content-Disposition";
		String headerValue = "attachment; filename=csv_" + currentDateTime + ".csv";
		response.setHeader(headerKey, headerValue);

		csvService.export(response, tenantId, bldgId, year, month);

	}

}
