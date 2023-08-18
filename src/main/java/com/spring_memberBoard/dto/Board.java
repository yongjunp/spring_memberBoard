package com.spring_memberBoard.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Board {
	private int bno; 			//번호	-자동생성
	private String bwriter;		//작성자	
	private String btitle;		//제목	-입력
	private String bcontents;	//내용	-입력
	private int bhits;			//조회수	- 0
	private String bdate;		//작성일	-sysdate
	private String bstate;		//상태	- 1
	
	private String bfilename;	//파일이름	-입력
	private MultipartFile bfile;
	
	private int recount;
}
