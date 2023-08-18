package com.spring_memberBoard.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.spring_memberBoard.Service.ApiService;
import com.spring_memberBoard.dto.Bus;

@Controller
public class ApiController {

	@Autowired
	private ApiService apisvc;
	
	@RequestMapping(value = "/getBusLocation")
	public @ResponseBody String getBusLocation(String routeid, String citycode) throws Exception {
		System.out.println("버스 위치 정보 요청");
		System.out.println("routeid" + routeid);
		String result = apisvc.getBusLocation(routeid, citycode);
		System.out.println("여기까지"+result);
		return result;
	}
	
	@RequestMapping(value = "/getBusId")
	public @ResponseBody String getBusId(String routeid, String citycode) throws Exception{
		System.out.println("버스 정보 요청");
		String result = apisvc.getBusId(routeid, citycode);
		System.out.println(result);
		return result;
	}
	
	@RequestMapping(value = "/getBusSttn")
	public @ResponseBody String getBusSttn(String lati, String longti) throws Exception {
		System.out.println("정류소 정보 받아오기 요청");
		String result = apisvc.getBusSttn(lati, longti);
		return result;
	}
	
	@RequestMapping(value = "/getBusArr")
	public @ResponseBody String getBusArr(String nodeId, String citycode) throws Exception{
		System.out.println("정류장별 도착정보");
		System.out.println(citycode);
		String result = apisvc.getBusArr(nodeId, citycode);
		System.out.println(result);
		return result;
	}
	
	@RequestMapping(value = "/busapi")
	public ModelAndView busapi() throws Exception {
		System.out.println("버스도착정보 페이지 이동요청 - /busapi");
		ModelAndView mav = new ModelAndView();
//		//1. 버스 도착 정보 조회
//		ArrayList<Bus> result = apisvc.getBusArrive();
//		
//		mav.addObject("busList", result);
//		
//		//2. 버스도착정보 페이지
		mav.setViewName("BusList");
		return mav;
	}
}
