package com.spring_memberBoard.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.spring_memberBoard.Service.BoardService;
import com.spring_memberBoard.dto.Board;
import com.spring_memberBoard.dto.Reply;

@Controller
public class BoardController {

	ModelAndView mav;
	@Autowired
	private BoardService bsvc;
	
	@RequestMapping(value = "/removeReply")
	public @ResponseBody String removeReply(int renum) {
		System.out.println("댓글 삭제요청");
		String result = bsvc.deleteReply(renum) + "";
		return result;
	}
	
	@RequestMapping(value = "/replyList")
	public @ResponseBody String replyList(int rebno) {
		System.out.println("댓글 조회 요청");
		System.out.println("댓글을 조회 할 글번호 : " + rebno);
		//1. service - 댓글 목록 조회
		ArrayList<Reply>replyList = bsvc.getReplyList(rebno);
		//조회된 댓글 목록 확인
		System.out.println("댓글 갯수 : " + replyList.size());
		System.out.println(replyList);
		//2.json변환 후 응답
		//gson사용 {key : value}
		Gson gson = new Gson();
		String reList = gson.toJson(replyList);
		System.out.println(reList);
		
		return reList;
	}
	
	@RequestMapping(value = "/inputComment")
	public @ResponseBody String inputComment(int inputBno, String inputLoginId, String inputComment) {
		System.out.println("댓글 등록 요청");
		System.out.println("아이디" + inputLoginId);
		System.out.println("글번호" + inputBno);
		System.out.println("댓글" + inputComment);
		int resultReply = bsvc.insertComment(inputBno, inputLoginId, inputComment);
		String result = "";
		if(resultReply == 0) {
			result = "실패";
		} else {
			result ="성공";
		}
		return result;
	}
	
	@RequestMapping(value = "/rollbackBoard")
	public ModelAndView rollbackBoard(int bno) {
		System.out.println("글 되돌리기 요청");
		mav = new ModelAndView();
		int result = bsvc.rollbackBoard(bno);
		mav.setViewName("/MainPage");
		if(result > 0) {
			mav.addObject("msg","글 되돌리기를 성공하였습니다.");			
		}else {
			mav.addObject("msg", "글 되돌리기를 실패하였습니다.");
		}
		return mav;
	}
	
	@RequestMapping(value = "/removeBoard")
	public ModelAndView removeBoard(int bno) {
		System.out.println("게시물 삭제요청");
		System.out.println("bno : " + bno);
		int result = bsvc.deleteBoard(bno);
		mav.setViewName("MainPage");
		if(result > 0) {
			mav.addObject("msg", "삭제가 완료되었습니다.");			
		} else {
			mav.addObject("msg", "삭제를 실패하였습니다.");
		}
		return mav;
	}
	
	@RequestMapping(value="/boardView")
	public ModelAndView lookBoard(int bno) {
		System.out.println("게시물 확인 페이지 이동요청");
		mav = new ModelAndView();
		System.out.println(bno);
		Board board = bsvc.getBoard(bno);
		System.out.println(board);
		mav.setViewName("/Board/BoardView");
		mav.addObject("board", board);
		return mav;
	}
	
	@RequestMapping(value="/boardList")
	public ModelAndView boardList() {
		System.out.println("게시판 목록 가져오기 요청");
		mav = new ModelAndView();
		ArrayList<Board> bList = bsvc.getBoardList();
		System.out.println(bList);
		mav.addObject("bList", bList);
		
		// HashMap - 글 목록 조회
		ArrayList<HashMap<String, String>> bList_map = bsvc.getBoardList_map();
		System.out.println(bList_map);
		mav.addObject("bListMap", bList_map);
		mav.setViewName("/Board/BoardList");
		return mav;
	}
	
	@RequestMapping(value="/boardWrite")
	public ModelAndView boardWrite(Board board, HttpSession session, RedirectAttributes ra) {
		System.out.println("글등록 요청");
		mav = new ModelAndView();
		String bwirter = (String)session.getAttribute("loginMemberId");
		board.setBwriter(bwirter);
		
		int result = 0;
		try {
			result = bsvc.registBoard(board, session);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		if(result>0) {
			ra.addFlashAttribute("msg", "글쓰기에 성공하였습니다.");
			ra.addFlashAttribute("noticeMsg","New Board");
			mav.setViewName("redirect:/boardList");
			
			
		}else {
			ra.addFlashAttribute("msg", "글쓰기에 실패하였습니다.");
			mav.setViewName("redirect:/boardWriteForm");
		}
		return mav;
	}
	
	@RequestMapping(value = "/boardWriteForm")
	public ModelAndView boardWriteForm() {
		System.out.println("글작성 페이지 이동 요청 /boardWriteForm");
		mav = new ModelAndView();
		mav.setViewName("/Board/BoardWriteForm");
		return mav;
		
	}
}
