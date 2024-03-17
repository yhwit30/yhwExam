package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Tenant {
	private int id;
	private String regDate;
	private String updateDate;
	private String tenantName;
	private int tenantPhone;
	private String tenantCarNum;
	
	private int deposit;
	private int rent;
	private int maintenanceFee;
	private String contractStartDate;
	private String contractEndDate;
	private String depositDate;
	private String rentDate;
	private int roomNum;
	private String bldgName;
	private String leaseType;

}
