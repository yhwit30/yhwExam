package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MaintenanceFee {

	private int id;
	private String regDate;
	private String updateDate;
	private int commonElec;
	private int commonWater;
	private int elevater;
	private int internetTV;
	private int fireSafety;
	private int waterUse;
	private int waterCost;
	private int waterBill;
	private int elecUse;
	private int elecCost;
	private int elecBill;
	private int gasUse;
	private int gasCost;
	private int gasBill;
	private int monthlyMaintenanceFee;
	private int lateFee;
	private int lateMaintenanceFee;
	private int maintenanceFeeDate;
	private int tenantId;
	
	
	private int bldgId;
	private String bldgName;
	private String roomNum;
	private String tenantName;
	private String leaseType;
	private int monthlyMaintenanceFee1;
	private int monthlyMaintenanceFee2;
	private int monthlyMaintenanceFee3;
	private int monthlyMaintenanceFee4;
	private int monthlyMaintenanceFee5;
	private int monthlyMaintenanceFee6;
	private int monthlyMaintenanceFee7;
	private int monthlyMaintenanceFee8;
	private int monthlyMaintenanceFee9;
	private int monthlyMaintenanceFee10;
	private int monthlyMaintenanceFee11;
	private int monthlyMaintenanceFee12;

}
