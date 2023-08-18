package com.spring_memberBoard.dto;

import lombok.Data;

@Data
public class Bus {
	
	private String nodenm;				//정류소명
	private String routeno;				//노선번호
	private String arrprevstationcnt;	//남은정류장수
	private String arrtime;				//도착예정시간
}
