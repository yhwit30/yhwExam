package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.service.ContractService;
import com.example.demo.service.TenantService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.Contract;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Room;

@Controller
public class UsrContractController {

	@Autowired
	private ContractService contractService;

	@Autowired
	private BuildingService buildingService;

	@Autowired
	private TenantService tenantService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/contract/contract")
	public String getContract(Model model, @RequestParam(defaultValue = "0") int bldgId) {

		// 건물 전체보기 위한 조건문
		if (bldgId == 0) {
			List<Contract> contracts = contractService.getForPrintContracts(bldgId);
			int contractsCnt = contracts.size();

//			건물 변환 버튼용
			List<Building> buildings = buildingService.getForPrintBuildings();

			model.addAttribute("buildings", buildings);
			model.addAttribute("contractsCnt", contractsCnt);
			model.addAttribute("contracts", contracts);
			return "usr/bg12343/contract/contract";
		}

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();
		model.addAttribute("buildings", buildings);

		// 건물별 계약정보 가져오기
		List<Contract> contracts = contractService.getForPrintContracts(bldgId);
		int contractsCnt = contracts.size();

		model.addAttribute("contractsCnt", contractsCnt);
		model.addAttribute("contracts", contracts);
		return "usr/bg12343/contract/contract";
	}

	@RequestMapping("/usr/bg12343/contract/contractAdd")
	public String addContract(Model model, @RequestParam(defaultValue = "1") int bldgId) {

		// 건물목록 가져오기
		List<Building> buildings = buildingService.getForPrintBuildings();

		// 건물별 호실 가져오기
//		List<Room> rooms = buildingService.getForPrintRooms(bldgId);

		model.addAttribute("buildings", buildings);
//		model.addAttribute("rooms", rooms);
		return "usr/bg12343/contract/contractAdd";
	}

	// ajax
	@RequestMapping("/usr/bg12343/contract/getRoomsForContract")
	@ResponseBody
	public List<Room> getRoomsForContract(int bldgId) {

		// 건물별 호실 가져오기
		List<Room> rooms = buildingService.getForPrintRooms(bldgId);

		// ajax 반환
		return rooms;
	}

	@RequestMapping("/usr/bg12343/contract/doContractAdd")
	@ResponseBody
	public String doContractAdd(int roomId, String leaseType, int deposit, int rent, int maintenanceFee,
			String contractStartDate, String contractEndDate, String depositDate, String rentDate, String tenantName,
			int tenantPhone, String tenantCarNum) {

		// 세입자 먼저 생성해서 tenantId 얻기
		tenantService.addTenantSetup(roomId, tenantName, tenantPhone, tenantCarNum);
		int tenantId = tenantService.getTenantIds(roomId); // 호실roomId 중복 시 오류나는데 이건 한 호실에 여러번 계약의 경우 체크할 때 하자

		// 계약 작성 작업
		ResultData contractAddRd = contractService.addContract(roomId, leaseType, deposit, rent, maintenanceFee,
				contractStartDate, contractEndDate, depositDate, rentDate, tenantId);

		return Ut.jsReplace(contractAddRd.getResultCode(), contractAddRd.getMsg(), "../contract/contract");

	}

	@RequestMapping("/usr/bg12343/contract/contractSetupAdd")
	public String addContracts(Model model) {

		int getLastBldgId = buildingService.getLastBldgId();
		Building addedBuilding = buildingService.getForPrintBuilding(getLastBldgId);
		List<Room> rooms = buildingService.getForPrintRooms(getLastBldgId);

		model.addAttribute("addedBuilding", addedBuilding);
		model.addAttribute("rooms", rooms);
		return "usr/bg12343/contract/contractSetupAdd";
	}

	@RequestMapping("/usr/bg12343/contract/doContractSetupAdd")
	@ResponseBody
	public String doContractSetupAdd(int roomId[], String[] tenantName, int[] tenantPhone, String[] tenantCarNum,
			String[] leaseType, int[] deposit, int[] rent, int[] maintenanceFee, String[] contractStartDate,
			String[] contractEndDate, String[] depositDate, String[] rentDate) {

		// Contract 객체를 생성하고 컨트롤러에서 넘어온 값들을 저장한다.
		List<Contract> contractSet = new ArrayList<>();
		for (int i = 0; i < roomId.length; i++) {
			Contract contract = new Contract();
			contract.setRoomId(roomId[i]);
			contract.setTenantName(tenantName[i]);
			contract.setTenantPhone(tenantPhone[i]);
			contract.setTenantCarNum(tenantCarNum[i]);
			contract.setLeaseType(leaseType[i]);
			contract.setDeposit(deposit[i]);
			contract.setRent(rent[i]);
			contract.setMaintenanceFee(maintenanceFee[i]);
			contract.setContractStartDate(contractStartDate[i]);
			contract.setContractEndDate(contractEndDate[i]);
			contract.setDepositDate(depositDate[i]);
			contract.setRentDate(rentDate[i]);

			// leaseType이 0(공실)이 아닌 경우에만 contractSet에 추가한다.
			if (!"0".equals(contract.getLeaseType())) {
				contractSet.add(contract);
			}
		}

		System.out.println(contractSet.toString());

		// tenantId가 먼저 있어야 계약정보 insert가 가능하다
		boolean tenantDataCheck = false;
		for (int i = 0; i < contractSet.size(); i++) {
			Contract contract = contractSet.get(i);
			tenantDataCheck = tenantService.isTenantData(contract.getRoomId());
			if (!tenantDataCheck) {
				// todo 아직 계약날짜로 체크하는 코드 미완성이라 일단 1호실 1계약으로
				return Ut.jsReplace("F-1", "이미 roomId가 있습니다", "../contract/contract");
			}
			tenantService.addTenantSetup(contract.getRoomId(), contract.getTenantName(), contract.getTenantPhone(),
					contract.getTenantCarNum());
		}

		// tenantId 가져오기
		int[] tenantIds = new int[contractSet.size()];
		for (int i = 0; i < contractSet.size(); i++) {
			Contract contract = contractSet.get(i);
			tenantIds[i] = tenantService.getTenantIds(contract.getRoomId());
		}

		// 모든 호실 공실일 경우
		if (contractSet.isEmpty()) {
			return Ut.jsReplace("S-2", "모두 공실처리되었습니다", "../contract/contract");
		}

		// tenantId 포함해서 contract 데이터베이스에 넣기
		for (int i = 0; i < contractSet.size(); i++) {
			Contract contract = contractSet.get(i);
			ResultData contractAddRd = contractService.addContract(contract.getRoomId(), contract.getLeaseType(),
					contract.getDeposit(), contract.getRent(), contract.getMaintenanceFee(),
					contract.getContractStartDate(), contract.getContractEndDate(), contract.getDepositDate(),
					contract.getRentDate(), tenantIds[i]);
		}
		return Ut.jsReplace("S-1", "계약 정보가 추가되었습니다", "../contract/contract");
	}

	@RequestMapping("/usr/bg12343/contract/contractModify")
	public String modifyContract(Model model, @RequestParam(defaultValue = "0") int bldgId) {

		// 전체보기에서 수정
		if (bldgId == 0) {
			List<Contract> contracts = contractService.getForPrintContracts(bldgId);
			int contractsCnt = contracts.size();

			// 건물 변환 버튼용
			List<Building> buildings = buildingService.getForPrintBuildings();

			model.addAttribute("buildings", buildings);
			model.addAttribute("contractsCnt", contractsCnt);
			model.addAttribute("contracts", contracts);
			return "usr/bg12343/contract/contractModify";
		}

		// 건물별로 수정
		// 건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		List<Contract> contracts = contractService.getForPrintContracts(bldgId);
		int contractsCnt = contracts.size();

		model.addAttribute("contractsCnt", contractsCnt);
		model.addAttribute("contracts", contracts);
		return "usr/bg12343/contract/contractModify";
	}

	// ajax
	@RequestMapping("/usr/bg12343/contract/doContractModifyAjax")
	@ResponseBody
	public Contract doContractModifyAjax(int contractId, String tenantName, String leaseType, int deposit, int rent,
			int maintenanceFee, String contractStartDate, String contractEndDate, String depositDate, String rentDate) {

		// 계약정보 수정
		contractService.modifyContract(contractId, tenantName, leaseType, deposit, rent, maintenanceFee,
				contractStartDate, contractEndDate, depositDate, rentDate);

		// ajax 위한 데이터 가져오기
		Contract modifiedContract = contractService.getForPrintContract(contractId);

		return modifiedContract;
	}

	@RequestMapping("/usr/bg12343/contract/doContractModify")
	@ResponseBody
	public String doContractModify(int id[], String[] tenantName, String[] leaseType, int[] deposit, int[] rent,
			int[] maintenanceFee, String[] contractStartDate, String[] contractEndDate, String[] depositDate,
			String[] rentDate, int bldgId) {

		// 계약정보를 한번에 수정하기 위한 배열 사용
		ResultData contractModifyRd = null;
		for (int i = 0; i < id.length; i++) {
			contractModifyRd = contractService.modifyContract(id[i], tenantName[i], leaseType[i], deposit[i], rent[i],
					maintenanceFee[i], contractStartDate[i], contractEndDate[i], depositDate[i], rentDate[i]);
		}

		return Ut.jsReplace(contractModifyRd.getResultCode(), contractModifyRd.getMsg(),
				"../contract/contract?bldgId=" + bldgId);
	}

	@RequestMapping("/usr/bg12343/contract/doContractDelete")
	@ResponseBody
	public String doContractDelete(int id) {

		return null;
	}

}
