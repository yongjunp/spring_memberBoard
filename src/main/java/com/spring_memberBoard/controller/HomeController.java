package com.spring_memberBoard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	@RequestMapping(value = "/")
	public String home() {
		System.out.println("메인페이지 이동 요청 -/");
		return "MainPage";
	}
	
}
