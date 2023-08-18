package com.spring_memberBoard.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring_memberBoard.dao.MemberDao;
import com.spring_memberBoard.dto.Member;

@Service
public class MemberService {

	@Autowired
	private MemberDao mdao;
	
	public String idCheck(String inputId) {
		System.out.println("SERVICE - idCheck() 호출");
		System.out.println("아이디 : "+inputId);
		
		Member member = mdao.selectMemberInfo(inputId);
		
		Member member_mapper = mdao.selectMemberInfo_mapper(inputId);
		System.out.println(member_mapper);
		System.out.println(member);
		String result = "N";
		if(member ==null) {
			result = "Y";
		}else {
			result ="N";
		}	
		return result;
	}

	public int registMember(Member member) {
		System.out.println("SERVICE - registMember()호출");
		//DAO 호출 - INSERT INTO MEMBERS()
		int joinResult = 0;
		try {
			joinResult = mdao.insertMember(member); 			
		} catch (Exception e) {
			e.printStackTrace(); //e.printStackTrace() : 에러의 발생근원지를 찾아서 단계별로 에러를 출력합니다.
		}
		
		return joinResult;
	}

	public Member getLoginMemberInfo(String mid, String mpw) {
		System.out.println("SERVICE - getLoginMemberInfo() 호출");
		Member loginResult = null;
		try {
			loginResult = mdao.loginMember(mid,mpw);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return loginResult;
	}

	public Member infoCheck(String loginId, String inputPw) {
		System.out.println("service - infoCheck()호출");
		Member mem = mdao.selectInfo(loginId, inputPw);
		System.out.println(mem);
		return mem;
	}

	public Member selectInfo(String inputId) {
		System.out.println("service - selectInfo()요청");
		Member member = mdao.selectMemberInfo(inputId);
		return member;
	}

	public int updateInfo(Member mem) {
		System.out.println("service - updateInfo()호출");
		int result = mdao.updateInfo(mem);
		return result;
	}


}
