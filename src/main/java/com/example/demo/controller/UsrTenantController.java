package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.service.TenantService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.Contract;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Tenant;

@Controller
public class UsrTenantController {

	@Autowired
	private TenantService tenantService;

	@Autowired
	private BuildingService buildingService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/tenant/tenant")
	public String getTenant(Model model, @RequestParam(defaultValue = "0") int bldgId) {

		if (bldgId == 0) {
			List<Tenant> tenants = tenantService.getForPrintTenants(bldgId);
			int tenantsCnt = tenants.size();

//			건물 변환 버튼용
			List<Building> buildings = buildingService.getForPrintBuildings();

			model.addAttribute("buildings", buildings);
			model.addAttribute("tenantsCnt", tenantsCnt);
			model.addAttribute("tenants", tenants);
			return "usr/bg12343/tenant/tenant";
		}

		List<Tenant> tenants = tenantService.getForPrintTenants(bldgId);
		int tenantsCnt = tenants.size();

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		model.addAttribute("tenantsCnt", tenantsCnt);
		model.addAttribute("tenants", tenants);
		return "usr/bg12343/tenant/tenant";
	}

	@RequestMapping("/usr/bg12343/tenant/tenantAdd")
	public String showTenantAdd(Model model) {

		return "usr/bg12343/tenant/tenantAdd";
	}

	@RequestMapping("/usr/bg12343/tenant/doTenantAdd")
	@ResponseBody
	public String doTenantAdd(String tenantName, int tenantPhone, String tenantCarNum) {
		// 로그인 상태 체크 - 인터셉터에서

		// 제목 내용 빈 칸 확인
		if (Ut.isNullOrEmpty(tenantName)) {
			return Ut.jsHistoryBack("F-1", "세입자이름을 입력해주세요");
		}
		if (Ut.isEmpty(tenantPhone)) {
			return Ut.jsHistoryBack("F-2", "세입자휴대폰번호를 입력해주세요");
		}
		if (Ut.isNullOrEmpty(tenantCarNum)) {
			return Ut.jsHistoryBack("F-2", "세입자차량번호를 입력해주세요");
		}

		// 게시글 작성 작업
		ResultData TenantAddRd = tenantService.addTenant(tenantName, tenantPhone, tenantCarNum);

		// 작성된 게시글 번호 가져오기
		int id = (int) TenantAddRd.getData1();

		return Ut.jsReplace(TenantAddRd.getResultCode(), TenantAddRd.getMsg(), "../tenant/tenant");
	}

	@RequestMapping("/usr/bg12343/tenant/tenantModify")
	public String showTenantModify(Model model, @RequestParam(defaultValue = "0") int bldgId) {

		if (bldgId == 0) {
			List<Tenant> tenants = tenantService.getForPrintTenants(bldgId);
			int tenantsCnt = tenants.size();

//			건물 변환 버튼용
			List<Building> buildings = buildingService.getForPrintBuildings();

			model.addAttribute("buildings", buildings);
			model.addAttribute("tenantsCnt", tenantsCnt);
			model.addAttribute("tenants", tenants);
			return "usr/bg12343/tenant/tenantModify";
		}

		List<Tenant> tenants = tenantService.getForPrintTenants(bldgId);
		int tenantsCnt = tenants.size();

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		model.addAttribute("tenantsCnt", tenantsCnt);
		model.addAttribute("tenants", tenants);
		return "usr/bg12343/tenant/tenantModify";
	}

	@RequestMapping("/usr/bg12343/tenant/doTenantModify")
	@ResponseBody
	public String doTenantModify(int[] id, String[] tenantName, int[] tenantPhone, String[] tenantCarNum) {

		ResultData tenantModifyRd = null;
		for (int i = 0; i < id.length; i++) {
			tenantModifyRd = tenantService.modifyTenant(id[i], tenantName[i], tenantPhone[i], tenantCarNum[i]);
		}

		return Ut.jsReplace(tenantModifyRd.getResultCode(), tenantModifyRd.getMsg(), "../tenant/tenant");
	}

	// ajax
	@RequestMapping("/usr/bg12343/tenant/doTenantModifyAjax")
	@ResponseBody
	public Tenant doTenantModifyAjax(int tenantId, String tenantName, int tenantPhone, String tenantCarNum) {

		// 세입자정보 수정
		ResultData tenantModifyRd = tenantService.modifyTenant(tenantId, tenantName, tenantPhone, tenantCarNum);

		// ajax 위한 데이터 가져오기
		Tenant modifiedTenant = tenantService.getForPrintTenant(tenantId);

		return modifiedTenant;
	}

}
