package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Room;
import com.example.demo.vo.Rq;

@Controller
public class UsrBuildingController {

	@Autowired
	private Rq rq;
	
	@Autowired
	private BuildingService buildingService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/building/building")
	public String getBuilding(Model model, @RequestParam(defaultValue = "1") int bldgId) {

		Building buildingRd = buildingService.getForPrintBuilding(bldgId);

		List<Building> buildings = buildingService.getForPrintBuildings();

		List<Room> rooms = buildingService.getForPrintRooms(bldgId);
		int roomsCnt = rooms.size();

		model.addAttribute("buildingRd", buildingRd);
		model.addAttribute("buildings", buildings);
		model.addAttribute("rooms", rooms);
		model.addAttribute("roomsCnt", roomsCnt);
		return "usr/bg12343/building/building";
	}

	@RequestMapping("/usr/bg12343/building/buildingAdd")
	public String showBuildingAdd(Model model) {

		return "usr/bg12343/building/buildingAdd";
	}

	@RequestMapping("/usr/bg12343/building/doBuildingSetupAdd")
	@ResponseBody
	public String doBuildingAdd(String bldgName, String bldgAdd, int roomTotal, String latitude, String longitude) {

		// 게시글 작성 작업
		ResultData buildingAddRd = buildingService.addBuilding(bldgName, bldgAdd, roomTotal, latitude, longitude);

		return Ut.jsReplace(buildingAddRd.getResultCode(), buildingAddRd.getMsg(), "../building/roomSetupAdd");
	}

	@RequestMapping("/usr/bg12343/building/buildingModify")
	public String showBuildingModify(Model model, @RequestParam(defaultValue = "1") int bldgId) {

		Building buildingRd = buildingService.getForPrintBuilding(bldgId);

		List<Room> rooms = buildingService.getForPrintRooms(bldgId);

		model.addAttribute("buildingRd", buildingRd);
		model.addAttribute("rooms", rooms);

		return "usr/bg12343/building/buildingModify";
	}

	@RequestMapping("/usr/bg12343/building/doBuildingModify")
	@ResponseBody
	public String doBuildingModify(int[] roomId, String bldgName, String bldgAdd, int roomTotal, int[] roomNum,
			String[] roomType, double[] roomArea, int[] standardDeposit, int[] standardRent, int[] standardJeonse,
			int bldgId) {

		ResultData buildingModifyRd = null;
		ResultData roomModifyRd = null;
		for (int i = 0; i < roomId.length; i++) {
			roomModifyRd = buildingService.modifyRoom(roomId[i], roomNum[i], roomType[i], roomArea[i],
					standardDeposit[i], standardRent[i], standardJeonse[i]);
		}

		buildingModifyRd = buildingService.modifyBuilding(bldgId, bldgName, bldgAdd, roomTotal);

		return Ut.jsReplace(buildingModifyRd.getResultCode(), buildingModifyRd.getMsg(),
				"../building/building?bldgId=" + bldgId);
	}

	@RequestMapping("/usr/bg12343/building/doBuildingDelete")
	@ResponseBody
	public String doBuildingDelete(int bldgId) {

		// 건물정보 삭제
		ResultData buildingDeleteRd = buildingService.deleteBuilding(bldgId);

		// 해당 건물 호실정보 삭제
		buildingService.deleteRooms(bldgId);

		return Ut.jsReplace(buildingDeleteRd.getResultCode(), buildingDeleteRd.getMsg(), "../building/building");
	}

	@RequestMapping("/usr/bg12343/building/roomSetupAdd")
	public String showRoomAdd(Model model) {

		int getLastBldgId = buildingService.getLastBldgId();
		Building addedBuilding = buildingService.getForPrintBuilding(getLastBldgId);

		model.addAttribute("addedBuilding", addedBuilding);
		return "usr/bg12343/building/roomSetupAdd";
	}

	@RequestMapping("/usr/bg12343/building/doRoomAdd")
	@ResponseBody
	public String doRoomAdd(int[] bldgId, int[] roomNum, String[] roomType, double[] roomArea, int[] standardDeposit,
			int[] standardRent, int[] standardJeonse) {

		// 표에 있는 데이터라 null 체크가 이곳에서 안되서 앞서서 ajax로 체크

		// 게시글 작성 작업
		ResultData RoomAddRd = null;
		for (int i = 0; i < bldgId.length; i++) {
			RoomAddRd = buildingService.addRoom(bldgId[i], roomNum[i], roomType[i], roomArea[i], standardDeposit[i],
					standardRent[i], standardJeonse[i]);
		}

		return Ut.jsReplace(RoomAddRd.getResultCode(), RoomAddRd.getMsg(), "../contract/contractSetupAdd");
	}

}
