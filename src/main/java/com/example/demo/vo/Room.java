package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Room {
	private int id;
	private String regDate;
	private String updateDate;
	private int roomNum;
	private String roomType;
	private int standardDeposit;
	private int standardRent;
	private int standardJeonse;
	private int bldgId;
	private double roomArea;
	private String furnish;
	
	private String bldgName;
	private int deposit;
	private int rent;
	private int maintenanceFee;
	private String tenantName;

}
