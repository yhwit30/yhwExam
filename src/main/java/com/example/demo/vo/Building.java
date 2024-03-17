package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Building {
	private int id;
	private String regDate;
	private String updateDate;
	private String bldgName;
	private String bldgAdd;
	private int roomTotal;
	private double latitude;
	private double longitude;
	private int memberId;
}
