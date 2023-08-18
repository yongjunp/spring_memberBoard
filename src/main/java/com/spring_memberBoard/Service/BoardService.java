package com.spring_memberBoard.Service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring_memberBoard.dao.BoardDao;
import com.spring_memberBoard.dto.Board;
import com.spring_memberBoard.dto.Reply;

@Service
public class BoardService {

	@Autowired
	private BoardDao bdao;

	public int registBoard(Board board, HttpSession session) throws IllegalStateException, IOException {
		System.out.println("service - registBoard()요청");

//		업로드된 파일 저장 - 저장경로 설정, 파일명 처리 
		MultipartFile bfile = board.getBfile(); // 첨부파일
		String bfilename = "";// 파일명 저장할 변수
		String savePath = ""; // 파일을 저장할 경로
		if (!bfile.isEmpty()) { // 첨부파일 확인 isEmpty는 MultipartFile안에 데이터가 있으면 false 없으면 true
			// 첨부파일이 있는 경우 !가 붙어있기 때문에
			System.out.println("첨부파일있음");
			// 임의의 코드 + 사진.avif
			UUID uuid = UUID.randomUUID();
			// String code = UUID.randomUUID().toString();
			String code = uuid.toString();
			System.out.println("code : " + code);
			bfilename = code + "_" + bfile.getOriginalFilename();
			// 저장할 경로 resources/boardUpload 폴더에 파일저장
//			D:\spring_wk\spring_memberBoard\src\main\webapp\resources\boardUpload
			//savePath = session.getServletContext().getRealPath("/resources/boardUpload");
			savePath = session.getServletContext().getRealPath("/resources/boardUpload");
			File newFile = new File(savePath, bfilename);//File("경로", "파일이름")
			bfile.transferTo(newFile);
			System.out.println(savePath = session.getServletContext().getRealPath("/resources/boardUpload"));
		}
		System.out.println("파일이름 : " + bfilename);
		System.out.println("savePath : " + savePath);
		board.setBfilename(bfilename);
		System.out.println(board);

//		업로드된 파일의 이름 추출 - bfilename

//		글번호 생성 (최대값 +1)
		int maxBno = 0;
		String resultBno = bdao.selectMaxBno();
		if (resultBno == null) {
			maxBno = 1;
		} else {
			maxBno = Integer.parseInt(bdao.selectMaxBno());
		}
		board.setBno(maxBno);

//		insert시작
		int result = bdao.insertBoard(board);
		if(result >0) {
			System.out.println("글쓰기 성공");
		}else {
			System.out.println("글쓰기 실패");
			return 0;
		}
		return result;
	}

	public ArrayList<Board> getBoardList() {
		System.out.println("service - getBoardList() 호출");
		ArrayList<Board> bList = bdao.selectBoard();
		// dao - select * from boards where bstate = '1' orderbdate desc
		/*
		 * select * from replys where rebno = 1 
		 */
		for(Board bo : bList) {
			int recount = bdao.selectBoardRecount(bo.getBno());
			bo.setRecount(recount);
		}
		return bList;
	}

	public Board getBoard(int bno) {
		System.out.println("service - getBoard()요청");
		//1.조회수 증가
		int result = bdao.updateBhits(bno);
		System.out.println(result);
		//2. 글 정보 조회
		Board board = bdao.getBoard(bno);		
		//3. 글내용 줄바꿈 문자 >> HTML 태그로 치환
		
		return board;
	}

	public int deleteBoard(int bno) {
		System.out.println("service - deleteBoard()호출");
		int result = bdao.updateBstate(bno);
		System.out.println("update완료");
		return result;
	}

	public ArrayList<Board> getMyBoardList(String loginId) {
		System.out.println("service - getBoardList(String loginId) 호출");
		ArrayList<Board> bList = bdao.selectMyBoard(loginId);
		return bList;
	}

	public int rollbackBoard(int bno) {
		System.out.println("service - rollbackBoard()호출");
		int result = bdao.rollbackBstate(bno);
		return result;
	}

	public int insertComment(int inputBno, String inputLoginId, String inputComment) {
		System.out.println("service - insertComment()호출");
		int renum = 0;
		String resultRenum = bdao.selectMaxRenum();
		if (resultRenum == null) {
			renum = 1;
		} else {
			renum = Integer.parseInt(bdao.selectMaxRenum());
		}
		System.out.println(renum);
		int resultReply = bdao.insertComment(inputLoginId, inputBno, inputComment, renum);
		return resultReply;
	}

	public ArrayList<Reply> getReplyList(int rebno) {
		System.out.println("service - getReplyList(rebno)호출");
		ArrayList<Reply> replyList = bdao.selectReplyList(rebno);
		return replyList;
	}

	public int deleteReply(int renum) {
		System.out.println("service - deleteReply()호출");
		int result = bdao.updateReply(renum);
		return result;
	}

	public ArrayList<Reply> getReplyList(String loginId) {
			System.out.println("service - getReplyList(loginId)호출");
			ArrayList<Reply> rList = bdao.selectReply_loginId(loginId);
		return rList;
	}

	public ArrayList<HashMap<String, String>> getBoardList_map() {
		System.out.println("service - getBoardList_map() 호출");
		return bdao.selectBoards_map();
	}


}
