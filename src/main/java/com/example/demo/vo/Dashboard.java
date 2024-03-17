package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Dashboard {

	private int id;
	private String regDate;
	private String updateDate;
	private int standardDeposit;
	private int standardRent;
	private int standardJeonse;
	private String leaseType;
	private String deposit;
	private String rent;
	private String maintenanceFee;
	private String contractStartDate;
	private String contractEndDate;
	private String depositDate;
	private String rentDate;
	private String paymentStatus;
	private int tenantId;

	private int bldgId;
	private int roomTotal;
	private String bldgName;
	private String roomNum;
	private String roomType;
	private String tenantName;
	private String tenantPhone;
	private String paymentStatus1;
	private String paymentStatus2;
	private String paymentStatus3;
	private String paymentStatus4;
	private String paymentStatus5;
	private String paymentStatus6;
	private String paymentStatus7;
	private String paymentStatus8;
	private String paymentStatus9;
	private String paymentStatus10;
	private String paymentStatus11;
	private String paymentStatus12;
	private double roomArea;
	
	private int depositSum;
	private int rentSum;
	private int maintenanceFeeSum;

}
