package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Memo {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int boardId;
	private int bldgId;
	private int roomId;
	private int tenantId;
	private String title;
	private String body;
	private String repairDate;
	private int repairCost;

	private String bldgName;
	private int roomNum;
	private String tenantName;
}
