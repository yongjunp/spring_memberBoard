package com.spring_memberBoard.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring_memberBoard.Service.BoardService;
import com.spring_memberBoard.Service.MemberService;
import com.spring_memberBoard.dto.Board;
import com.spring_memberBoard.dto.Member;
import com.spring_memberBoard.dto.Reply;


@Controller
public class MemberController {
	
	@Autowired
	private MemberService msvc;
	@Autowired
	private BoardService bscv;
	
	@RequestMapping(value = "/updateInfo")
	public ModelAndView updateInfo(Member mem,HttpSession session, String memailId, String memailDomain) {
		System.out.println("내정보 수정 요청");
		ModelAndView mav = new ModelAndView();
		String inputMid = (String)session.getAttribute("loginMemberId");
		mem.setMid(inputMid);
		String memail = memailId + "@" + memailDomain;
		mem.setMemail(memail);
		System.out.println(mem);
		int result = msvc.updateInfo(mem);
		if(result > 0) {
			mav.setViewName("/MainPage");
			mav.addObject("msg", "내정보 수정에 성공하였습니다.");
		}else {
			mav.setViewName("/Member/ModifyInfo");
			mav.addObject("msg","내정보 수정에 실패하였습니다.");
		}
		return mav;
	}
	
	@RequestMapping(value="/modifyInfo")
	public ModelAndView modifyInfo(HttpSession session) {
		System.out.println("내정보 수정 페이지 이동 요청");
		ModelAndView mav = new ModelAndView();
		Member mem = msvc.selectInfo((String)session.getAttribute("loginMemberId"));
		
//		날짜 타입에 맞게 바꿔주기
		String[] mbirth = mem.getMbirth().split(" ");
		mem.setMbirth(mbirth[0]);
		System.out.println(mem);
		mav.addObject("mem", mem);
		
		
//		이메일 아이디와 도메인으로 나누기
		String[] memail = mem.getMemail().split("@");
		String memailId = memail[0];
		String memailDomain = memail[1];
		System.out.println(memailId + "@" + memailDomain);
		mav.addObject("memailId", memailId);
		mav.addObject("memailDomain", memailDomain);
		
		
		mav.setViewName("/Member/ModifyInfo");
		return mav;
	}
	
	@RequestMapping(value = "/checkInfo")
	public ModelAndView checkInfo(String inputPw, HttpSession session, RedirectAttributes ra) {
		System.out.println("내정보 페이지 비밀번호 확인");
		ModelAndView mav = new ModelAndView();
		String loginId = (String)session.getAttribute("loginMemberId");
		Member mem = msvc.infoCheck(loginId, inputPw);
		
		ArrayList<Board> bList = bscv.getMyBoardList(loginId);
		ArrayList<Reply> rList = bscv.getReplyList(loginId);
		int recount = rList.size();
		mav.setViewName("redirect:/MemInfo");
		if(mem == null) {
			ra.addFlashAttribute("msg", "비밀번호 확인 실패");
		}else {
			ra.addFlashAttribute("msg", "비밀번호 확인 완료");
		}		
		ra.addFlashAttribute("mem", mem);
		ra.addFlashAttribute("bList", bList);
		ra.addFlashAttribute("recount", recount);
		
		return mav;
	}
	
	@RequestMapping(value = "/MemInfo")
	public ModelAndView MemInfo() {
		System.out.println("내정보확인 페이지 이동요청");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/Member/MemInfo");
		return mav;
	}
	
	@RequestMapping(value = "/MemberLogout")
	public ModelAndView MemberLogout(HttpSession session, RedirectAttributes ra) {
		System.out.println("로그아웃 요청");
		ModelAndView mav = new ModelAndView();
//		session.invalidate() 세션값을 모두 초기화
		session.removeAttribute("loginMemberId");
		mav.setViewName("redirect:/");
		ra.addFlashAttribute("msg", "로그아웃 성공");
		return mav;
	}
	
	@RequestMapping(value="/MemberJoinForm")
	public ModelAndView MemberJoinOn() {
		System.out.println("회원가입페이지 이동 요청 - /MemberJoinForm");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/Member/MemberJoinForm");
		
		return mav;
	}
	
	@RequestMapping(value="/idCheck")
	public @ResponseBody String memberIdCheck(String inputId) {
		System.out.println("아이디 중복 확인 요청");
		System.out.println("확인할 아이디 : "+inputId);
		//1.서비스 호출 - 아이디 중복 확인 기능
		// MEMBERS테이블의 MID 컬럼에 저장된 아이디 인지 확인
		// SELECT * FROM MEMBERS WHERE MID = #{mid};
		String checkResult = msvc.idCheck(inputId);
		
		//2.확인 결과 반환 Y:사용가능 N:사용불가능
		return checkResult;
	}
	@RequestMapping(value = "/memberJoin")
	public ModelAndView memberJoin(Member member, String memailId, String memailDomain, RedirectAttributes ra) {
		ModelAndView mav = new ModelAndView();
		// 가입할 회원 정보 파라메터 확인
		System.out.println(member);
		System.out.println("회원가입 요청");
		System.out.println(memailId);
		System.out.println(memailDomain);
		member.setMemail(memailId+"@"+memailDomain);
		System.out.println(member.getMemail());
		// SERVICE - 회원가입 기능 호출 - INSERT INTO MEMBERS
		int joinResult = msvc.registMember(member);
		/*view/Success.jsp
		 * <script>
		 * alert(${msg});
		 * location.href="${url}";
		 * </script>
			mav.setViewName("Success"); // 성공했을때 갈 페이지
			mav.addObject("msg","회원가입에 성공 했습니다.");
			mav.addObject("url","/mainpage");
		 * */
		
		/* redirect:/ */
		if(joinResult > 0) {
			System.out.println("가입 성공");
			mav.setViewName("redirect:/");
			ra.addFlashAttribute("msg","회원가입에 성공 했습니다."); //1회용 Flash
			
		} else {
			System.out.println("가입 실패");
			mav.setViewName("redirect:/MemberJoinForm"); // 실패했을때 갈 페이지 (회원가입 페이지)
			ra.addFlashAttribute("msg","회원가입에 실패하였습니다.");
		}
		
		return mav;
	}
	/*1. 로그인 페이지 이동 요청에 대한 처리 /memberLoginForm */
	@RequestMapping(value="/MemberLoginForm")
	public ModelAndView memberLoginForm() {
		System.out.println("로그인 페이지 이동 요청");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("Member/MemberLoginForm");
		return mav;
	}
	/*2. 로그인 요청에 대한 처리 /memberLogin */
	@RequestMapping(value="/memberLogin")
	public ModelAndView memberLogin(HttpSession session,String mid,String mpw , RedirectAttributes ra) {
		System.out.println("로그인 처리 요청 - /memberLogin");
		ModelAndView mav = new ModelAndView();
		//1.로그인할 아이디, 비밀번호 파라메터 확인
		System.out.println("입력한 아이디 : "+mid);
		System.out.println("입력한 비밀번호 : "+mpw);
		//2.SERVICE - 로그인 회원정보 조회 호출
		Member loginMember = msvc.getLoginMemberInfo(mid,mpw);		
		if(loginMember == null) {
			System.out.println("로그인 실패");
			/*로그인 페이지로 이동*/
			mav.setViewName("redirect:/MemberLoginForm");
			ra.addFlashAttribute("msg","로그인 실패하였습니다");
			
		}else {
			System.out.println("로그인 성공");
			session.setAttribute("loginMemberId",loginMember.getMid());
			mav.setViewName("redirect:/");
			ra.addFlashAttribute("msg","로그인에 성공했습니다.");
			/*메인 페이지로 이동*/
		}
		return mav;
	}
	

}

