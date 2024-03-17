package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.MaintenanceFee;

@Mapper
public interface MaintenanceFeeRepository {

	@Select("""
			SELECT
			    R.*, C.*, B.*, T.*,
			    MF1.monthlyMaintenanceFee AS monthlyMaintenanceFee1,
			    MF2.monthlyMaintenanceFee AS monthlyMaintenanceFee2,
			    MF3.monthlyMaintenanceFee AS monthlyMaintenanceFee3,
			    MF4.monthlyMaintenanceFee AS monthlyMaintenanceFee4,
			    MF5.monthlyMaintenanceFee AS monthlyMaintenanceFee5,
			    MF6.monthlyMaintenanceFee AS monthlyMaintenanceFee6,
			    MF7.monthlyMaintenanceFee AS monthlyMaintenanceFee7,
			    MF8.monthlyMaintenanceFee AS monthlyMaintenanceFee8,
			    MF9.monthlyMaintenanceFee AS monthlyMaintenanceFee9,
			    MF10.monthlyMaintenanceFee AS monthlyMaintenanceFee10,
			    MF11.monthlyMaintenanceFee AS monthlyMaintenanceFee11,
			    MF12.monthlyMaintenanceFee AS monthlyMaintenanceFee12
			FROM
			    room AS R
			LEFT JOIN
			    contract AS C ON R.id = C.roomId
			LEFT JOIN
			    building AS B ON R.bldgId = B.id
			LEFT JOIN
			    tenant AS T ON C.tenantId = T.id
			LEFT JOIN
			    maintenance_fee AS MF1 ON MF1.tenantId = T.id AND MF1.updateDate LIKE '${year}-01%'
			LEFT JOIN
			    maintenance_fee AS MF2 ON MF2.tenantId = T.id AND MF2.updateDate LIKE '${year}-02%'
			LEFT JOIN
			    maintenance_fee AS MF3 ON MF3.tenantId = T.id AND MF3.updateDate LIKE '${year}-03%'
			LEFT JOIN
			    maintenance_fee AS MF4 ON MF4.tenantId = T.id AND MF4.updateDate LIKE '${year}-04%'
			LEFT JOIN
			    maintenance_fee AS MF5 ON MF5.tenantId = T.id AND MF5.updateDate LIKE '${year}-05%'
			LEFT JOIN
			    maintenance_fee AS MF6 ON MF6.tenantId = T.id AND MF6.updateDate LIKE '${year}-06%'
			LEFT JOIN
			    maintenance_fee AS MF7 ON MF7.tenantId = T.id AND MF7.updateDate LIKE '${year}-07%'
			LEFT JOIN
			    maintenance_fee AS MF8 ON MF8.tenantId = T.id AND MF8.updateDate LIKE '${year}-08%'
			LEFT JOIN
			    maintenance_fee AS MF9 ON MF9.tenantId = T.id AND MF9.updateDate LIKE '${year}-09%'
			LEFT JOIN
			    maintenance_fee AS MF10 ON MF10.tenantId = T.id AND MF10.updateDate LIKE '${year}-10%'
			LEFT JOIN
			    maintenance_fee AS MF11 ON MF11.tenantId = T.id AND MF11.updateDate LIKE '${year}-11%'
			LEFT JOIN
			    maintenance_fee AS MF12 ON MF12.tenantId = T.id AND MF12.updateDate LIKE '${year}-12%'
			GROUP BY
			    R.id
			HAVING B.id = #{bldgId}
			""")
	List<MaintenanceFee> getMaintenanceFeeMonthly(int bldgId, Integer year);

	@Select("""
			SELECT *
			FROM room AS R
			LEFT JOIN contract AS C
			ON R.id = C.roomId
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			LEFT JOIN tenant AS T
			ON C.tenantId = T.id
			LEFT JOIN maintenance_fee AS MF
			ON MF.tenantId = T.id AND MF.updateDate LIKE '${year}-${month}%'
			GROUP BY R.id
			HAVING B.id = #{bldgId};
			""")
	List<MaintenanceFee> getMaintenanceFees(int bldgId, Integer year, String month);

	@Select("""
			SELECT *
			FROM room AS R
			LEFT JOIN contract AS C
			ON R.id = C.roomId
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			LEFT JOIN tenant AS T
			ON C.tenantId = T.id
			LEFT JOIN maintenance_fee AS MF
			ON MF.tenantId = T.id
			WHERE MF.updateDate LIKE '${year}-${month}%'
			AND MF.tenantId = #{tenantId}
			GROUP BY R.id
			HAVING B.id = #{bldgId};
			""")
	MaintenanceFee getMaintenanceFee(int tenantId, int bldgId, Integer year, String month);

	@Update("""
			UPDATE maintenance_fee
			SET commonElec = #{commonElec},
			commonWater = #{commonWater},
			elevater = #{elevater},
			internetTV = #{internetTV},
			fireSafety = #{fireSafety},
			waterUse = #{waterUse},
			waterCost = #{waterCost},
			waterBill = #{waterBill},
			elecUse = #{elecUse},
			elecCost = #{elecCost},
			elecBill = #{elecBill},
			gasUse = #{gasUse},
			gasCost = #{gasCost},
			gasBill = #{gasBill},
			monthlyMaintenanceFee = #{monthlyMaintenanceFee},
			lateFee = #{lateFee},
			lateMaintenanceFee = #{lateMaintenanceFee},
			maintenanceFeeDate = #{maintenanceFeeDate}
			WHERE tenantId = #{tenantId}
			AND updateDate LIKE '${year}-${month}%'
			""")
	void modifyMaintenanceFee(int tenantId, int commonElec, int commonWater, int elevater, int internetTV,
			int fireSafety, int waterUse, int waterCost, int waterBill, int elecUse, int elecCost, int elecBill,
			int gasUse, int gasCost, int gasBill, int monthlyMaintenanceFee, int lateFee, int lateMaintenanceFee,
			int maintenanceFeeDate, int year, String month);

	@Insert("""
			INSERT INTO maintenance_fee
			SET regDate = NOW(),
			commonElec = #{commonElec},
			commonWater = #{commonWater},
			elevater = #{elevater},
			internetTV = #{internetTV},
			fireSafety = #{fireSafety},
			waterUse = #{waterUse},
			waterCost = #{waterCost},
			waterBill = #{waterBill},
			elecUse = #{elecUse},
			elecCost = #{elecCost},
			elecBill = #{elecBill},
			gasUse = #{gasUse},
			gasCost = #{gasCost},
			gasBill = #{gasBill},
			monthlyMaintenanceFee = #{monthlyMaintenanceFee},
			lateFee = #{lateFee},
			lateMaintenanceFee = #{lateMaintenanceFee},
			maintenanceFeeDate = #{maintenanceFeeDate},
			tenantId = #{tenantId},
			updateDate = '${year}-${month}'
			""")
	void addMaintenanceFee(int tenantId, int commonElec, int commonWater, int elevater, int internetTV, int fireSafety,
			int waterUse, int waterCost, int waterBill, int elecUse, int elecCost, int elecBill, int gasUse,
			int gasCost, int gasBill, int monthlyMaintenanceFee, int lateFee, int lateMaintenanceFee,
			int maintenanceFeeDate, int year, String month);

}
