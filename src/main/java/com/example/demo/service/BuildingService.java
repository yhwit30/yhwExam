package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.BuildingRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Room;

@Service
public class BuildingService {

	@Autowired
	private BuildingRepository buildingRepository;

	public Building getForPrintBuilding(int bldgId) {
		return buildingRepository.getForPrintBuilding(bldgId);
	}

	public List<Building> getForPrintBuildings() {
		return buildingRepository.getForPrintBuildings();
	}

	public List<Room> getForPrintRooms(int bldgId) {
		return buildingRepository.getForPrintRooms(bldgId);
	}

	public int getLastInsertId() {
		return buildingRepository.getLastInsertId();
	}

	public ResultData addBuilding(String bldgName, String bldgAdd, int roomTotal, String latitude, String longitude) {
		buildingRepository.addBuilding(bldgName, bldgAdd, roomTotal, latitude, longitude);
		int id = getLastInsertId();
		return ResultData.from("S-1", Ut.f("%d번 건물정보가 생성되었습니다", id), "id", id);
	}

	public ResultData addRoom(int bldgId, int roomNum, String roomType, double roomArea, int standardDeposit,
			int standardRent, int standardJeonse) {
		buildingRepository.addRoom(bldgId, roomNum, roomType, roomArea, standardDeposit, standardRent, standardJeonse);
		int id = getLastInsertId();
		return ResultData.from("S-1", "호실정보가 생성되었습니다", "id", id);
	}

	public ResultData modifyBuilding(int bldgId, String bldgName, String bldgAdd, int roomTotal) {
		buildingRepository.modifyBuilding(bldgId, bldgName, bldgAdd, roomTotal);
		return ResultData.from("S-1", "건물정보가 수정되었습니다");
	}

	public ResultData modifyRoom(int roomId, int roomNum, String roomType, double roomArea, int standardDeposit,
			int standardRent, int standardJeonse) {
		buildingRepository.modifyRoom(roomId, roomNum, roomType, roomArea, standardDeposit, standardRent,
				standardJeonse);
		return ResultData.from("S-1", "호실정보가 수정되었습니다");
	}

	public int getLastBldgId() {
		return buildingRepository.getLastBldgId();
	}

	public ResultData deleteBuilding(int bldgId) {
		buildingRepository.deleteBuilding(bldgId);
		return ResultData.from("S-3", Ut.f("%d번 건물이 삭제되었습니다", bldgId));
	}

	public void deleteRooms(int bldgId) {
		buildingRepository.deleteRooms(bldgId);

	}

}
