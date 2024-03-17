package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.DashboardRepository;
import com.example.demo.vo.Dashboard;

@Service
public class DashboardService {

	@Autowired
	private DashboardRepository dashboardRepository;

	public List<Dashboard> getDashboard() {
		return dashboardRepository.getDashboard();
	}

	public List<Dashboard> getRentStatus(int bldgId, int year) {
		return dashboardRepository.getRentStatus(bldgId, year);
	}

	public Dashboard getRentStatusRd(int tenantId, int year, String month) {
		return dashboardRepository.getRentStatusRd(tenantId, year, month);
	}

	public void modifyRentStatus(int tenantId, String body, int year, String month) {
		dashboardRepository.modifyRentStatus(tenantId, body, year, month);

	}

	public void addRentStatus(int tenantId, String body, int year, String month) {
		dashboardRepository.addRentStatus(tenantId, body, year, month);

	}

	public void deleteRentStatus(int tenantId, String body, int year, String month) {
		dashboardRepository.deleteRentStatus(tenantId, body, year, month);

	}

	public double getOccupancyRate(int roomsCnt, int tenantCnt) {
		return ((double) tenantCnt / (double) roomsCnt) * 100;
	}

}
