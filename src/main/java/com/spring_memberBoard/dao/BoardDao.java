package com.spring_memberBoard.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.spring_memberBoard.dto.Board;
import com.spring_memberBoard.dto.Reply;

public interface BoardDao {

	public String selectMaxBno();

	public int insertBoard(Board board);
	
	@Select("select * from boards order by bdate desc")
	public ArrayList<Board> selectBoard();

	public Board getBoard(int bno);

	@Update("update boards set bhits = bhits + 1 where bno = #{bno}")
	public int updateBhits(int bno);

	public int updateBstate(int bno);
	
	@Select("select * from boards where bwriter = #{loginId} order by bdate desc")
	public ArrayList<Board> selectMyBoard(@Param("loginId")String loginId);

	@Update("update boards set bstate = '1' where bno = #{bno}")
	public int rollbackBstate(int bno);
	
	@Insert("insert into replys values(#{renum}, #{inputBno}, #{inputLoginId}, #{inputComment}, sysdate, '1')")
	public int insertComment(@Param("inputLoginId")String inputLoginId, @Param("inputBno")int inputBno, @Param("inputComment")String inputComment, @Param("renum")int renum);

	@Select("select max(renum)+1 from replys")
	public String selectMaxRenum();
	
	@Update("update replys set restate = '0' where renum = #{renum}")
	public int updateReply(@Param("renum")int renum);
	
	@Select("select * from replys where rebno = #{rebno} order by renum desc")
	public ArrayList<Reply> selectReplyList(@Param("rebno")int rebno);

	@Select("select * from replys where remid = #{loginId}")
	public ArrayList<Reply> selectReply_loginId(String loginId);

	@Select("select * from replys")
	public ArrayList<Reply> selectReply();

	@Select("select count(*) from replys where rebno = #{bno}")
	public int selectBoardRecount(int bno);

	
	public ArrayList<HashMap<String, String>> selectBoards_map();

}
