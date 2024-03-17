package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ContractRepository;
import com.example.demo.vo.Contract;
import com.example.demo.vo.ResultData;

@Service
public class ContractService {

	@Autowired
	private ContractRepository contractRepository;

	public List<Contract> getForPrintContracts(int bldgId) {
		return contractRepository.getForPrintContracts(bldgId);
	}

	public Contract getForPrintContract(int contractId) {
		return contractRepository.getForPrintContract(contractId);
	}

	public ResultData modifyContract(int contractId, String tenantName, String leaseType, int deposit, int rent,
			int maintenanceFee, String contractStartDate, String contractEndDate, String depositDate, String rentDate) {
		contractRepository.modifyContract(contractId, tenantName, leaseType, deposit, rent, maintenanceFee,
				contractStartDate, contractEndDate, depositDate, rentDate);
		return ResultData.from("S-1", "계약정보가 수정되었습니다");
	}

	public ResultData addContract(int roomId, String leaseType, int deposit, int rent, int maintenanceFee,
			String contractStartDate, String contractEndDate, String depositDate, String rentDate, int tenantIds) {
		contractRepository.addContract(roomId, leaseType, deposit, rent, maintenanceFee, contractStartDate,
				contractEndDate, depositDate, rentDate, tenantIds);
		return ResultData.from("S-1", "계약정보가 생성되었습니다");
	}

}
