package com.example.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.vo.Tenant;

@Mapper
public interface TenantRepository {

	@Select("""
			<script>
			SELECT *
			FROM tenant AS T
			LEFT JOIN contract AS C
			ON T.roomId = C.roomId
			LEFT JOIN room AS R
			ON T.roomId = R.id
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			WHERE 1=1
			<if test="bldgId != 0">
				AND B.id = #{bldgId}
			</if>
			</script>
			""")
	public List<Tenant> getForPrintTenants(int bldgId);

	@Select("""
			<script>
			SELECT *
			FROM tenant AS T
			LEFT JOIN contract AS C
			ON T.roomId = C.roomId
			LEFT JOIN room AS R
			ON T.roomId = R.id
			LEFT JOIN building AS B
			ON R.bldgId = B.id
			WHERE T.id = #{tenantId}
			</script>
			""")
	public Tenant getForPrintTenant(int tenantId);

	@Insert("""
			INSERT INTO
			tenant SET
			regDate = NOW(),
			updateDate = NOW(),
			tenantName = #{tenantName},
			tenantPhone = #{tenantPhone},
			tenantCarNum = #{tenantCarNum}
			""")
	public void addTenant(String tenantName, int tenantPhone, String tenantCarNum);

	@Select("SELECT LAST_INSERT_ID()")
	public int getLastInsertId();

	@Update("""
			UPDATE tenant
			SET tenantName = #{tenantName},
			tenantPhone = #{tenantPhone},
			tenantCarNum = #{tenantCarNum}
			WHERE id = #{id}
			""")
	public void modifyTenant(int id, String tenantName, int tenantPhone, String tenantCarNum);

	@Insert("""
			INSERT INTO tenant
			SET regDate = NOW(),
			updateDate = NOW(),
			roomId = #{roomId},
			tenantName = #{tenantName},
			tenantPhone = #{tenantPhone},
			tenantCarNum = #{tenantCarNum}
			""")
	public void addTenantSetup(int roomId, String tenantName, int tenantPhone, String tenantCarNum); // contractController에서
																										// 사용

	@Select("""
			SELECT id
			FROM tenant
			WHERE roomId = #{roomId}
			""")
	public int getTenantIds(int roomId);// contractController에서 사용

	@Select("""
			SELECT COUNT(*)
			FROM tenant
			WHERE roomId = #{roomId}
			""")
	public int getTenantIdCnt(int roomId);

}
