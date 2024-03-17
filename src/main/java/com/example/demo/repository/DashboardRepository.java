package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Dashboard;

@Mapper
public interface DashboardRepository {

	@Select("""
			SELECT SUM(deposit) AS depositSum, SUM(rent) AS rentSum, SUM(maintenanceFee) AS maintenanceFeeSum, C.*, R.*, B.*
			FROM contract AS C
			INNER JOIN room AS R
			ON C.roomId = R.id
			INNER JOIN building AS B
			ON R.bldgId = B.id
			GROUP BY B.id
			""")
	List<Dashboard> getDashboard();

	@Select("""
			SELECT *,
				MAX(CASE WHEN CS.rentDate LIKE '${year}-01%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus1,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-02%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus2,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-03%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus3,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-04%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus4,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-05%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus5,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-06%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus6,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-07%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus7,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-08%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus8,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-09%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus9,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-10%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus10,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-11%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus11,
			    MAX(CASE WHEN CS.rentDate LIKE '${year}-12%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus12
			FROM room AS R
			LEFT JOIN contract AS C
			ON R.id = C.roomId
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			LEFT JOIN tenant AS T
			ON C.tenantId = T.id
			LEFT JOIN contract_Status AS CS
			ON C.tenantId = CS.tenantId
			AND (CS.rentDate LIKE '${year}-01%' OR CS.rentDate LIKE '${year}-02%' OR CS.rentDate LIKE '${year}-03%' OR
			     CS.rentDate LIKE '${year}-04%' OR CS.rentDate LIKE '${year}-05%' OR CS.rentDate LIKE '${year}-06%' OR
			     CS.rentDate LIKE '${year}-07%' OR CS.rentDate LIKE '${year}-08%' OR CS.rentDate LIKE '${year}-09%' OR
			     CS.rentDate LIKE '${year}-10%' OR CS.rentDate LIKE '${year}-11%' OR CS.rentDate LIKE '${year}-12%')
			GROUP BY R.id
			HAVING B.id = #{bldgId}
			""")
	List<Dashboard> getRentStatus(int bldgId, int year);

	@Select("""
			SELECT *
			FROM contract_status
			WHERE rentDate LIKE '${year}-${month}%' AND tenantId = #{tenantId};
			""")
	Dashboard getRentStatusRd(int tenantId, int year, String month);

	@Update("""
			UPDATE contract_status
			SET paymentStatus = #{body}
			WHERE rentDate LIKE '${year}-${month}%' AND tenantId = #{tenantId};
			""")
	void modifyRentStatus(int tenantId, String body, int year, String month);

	@Insert("""
			INSERT INTO
			contract_status SET
			regDate = NOW(),
			updateDate = NOW(),
			rentDate = '${year}-${month}',
			tenantId = #{tenantId},
			paymentStatus = '${body}',
			extraIncome = '없음',
			extraExpense = '없음'
			""")
	void addRentStatus(int tenantId, String body, int year, String month);

	@Delete("""
			DELETE FROM contract_status
			WHERE rentDate LIKE '${year}-${month}%' AND tenantId = #{tenantId}
			""")
	void deleteRentStatus(int tenantId, String body, int year, String month);

}
