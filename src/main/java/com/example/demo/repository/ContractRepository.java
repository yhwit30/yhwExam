package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Contract;

@Mapper
public interface ContractRepository {

	@Select("""
			<script>
			SELECT *
			FROM contract AS C
			LEFT JOIN room AS R
			ON C.roomId = R.id
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			LEFT JOIN tenant AS T
			ON C.tenantId = T.id
			WHERE 1=1
			<if test="bldgId != 0">
				AND B.id = #{bldgId}
			</if>
			GROUP BY C.id
			</script>
			""")
	List<Contract> getForPrintContracts(int bldgId);

	@Select("""
			<script>
			SELECT *
			FROM contract AS C
			LEFT JOIN room AS R
			ON C.roomId = R.id
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			LEFT JOIN tenant AS T
			ON C.tenantId = T.id
			GROUP BY C.id
			HAVING C.id = #{contractId}
			</script>
			""")
	Contract getForPrintContract(int contractId);

	@Update("""
			<script>
			UPDATE contract AS C INNER JOIN Tenant AS T
			ON C.tenantId = T.id
			SET C.updateDate = NOW(),
			T.tenantName = #{tenantName},
			C.leaseType = #{leaseType},
			C.deposit = #{deposit},
			C.rent = #{rent},
			C.maintenanceFee = #{maintenanceFee},
			C.contractStartDate = #{contractStartDate},
			C.contractEndDate = #{contractEndDate},
			C.depositDate = #{depositDate},
			C.rentDate = #{rentDate}
			WHERE C.id = #{contractId}
			</script>
			""")
	void modifyContract(int contractId, String tenantName, String leaseType, int deposit, int rent, int maintenanceFee,
			String contractStartDate, String contractEndDate, String depositDate, String rentDate);

	@Insert("""
			INSERT INTO contract
			SET regDate = NOW(),
			updateDate = NOW(),
			tenantId = #{tenantIds},
			roomId = #{roomId},
			leaseType = #{leaseType},
			deposit = #{deposit},
			rent = #{rent},
			maintenanceFee = #{maintenanceFee},
			contractStartDate = #{contractStartDate},
			contractEndDate = #{contractEndDate},
			depositDate =  #{depositDate},
			rentDate =  #{rentDate}
			""")
	void addContract(int roomId, String leaseType, int deposit, int rent, int maintenanceFee, String contractStartDate,
			String contractEndDate, String depositDate, String rentDate, int tenantIds);

}
