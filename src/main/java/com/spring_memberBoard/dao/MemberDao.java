package com.spring_memberBoard.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.spring_memberBoard.dto.Member;

public interface MemberDao {

	@Select("SELECT * FROM MEMBERS WHERE MID = #{inputId}")
	Member selectMemberInfo(@Param("inputId")String inputId);

/*	@Select("SELECT * FROM MEMBERS WHERE MID = #{inputId} AND MPW = #{inputPw]")
	Member selectMemberLogin(@Param("mid") String inputId,@Param("inputPw") String inputPw); //2개 이상의 매개변수가 있을때 */

	Member selectMemberInfo_mapper(@Param("inputId") String inputId);

	@Insert("INSERT INTO MEMBERS(MID,MPW,MNAME,MBIRTH,MEMAIL,MSTATE) VALUES(#{mid},#{mpw},#{mname},#{mbirth},#{memail},'1')")
	int insertMember(Member member);

	@Select("SELECT MID,MPW FROM MEMBERS WHERE MID= #{mid} AND MPW= #{mpw}")
	Member loginMember(@Param("mid") String mid, @Param("mpw") String mpw);

	@Select("SELECT * FROM MEMBERS WHERE MID = #{loginId} AND MPW = #{inputPw}")
	Member selectInfo(@Param("loginId")String loginId, @Param("inputPw")String inputPw);
	
	@Update("update members set mpw = #{mpw}, mname = #{mname}, mbirth = #{mbirth}, memail = #{memail} where mid = #{mid}")
	int updateInfo(Member mem);
	
}
