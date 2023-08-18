package com.spring_memberBoard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring_memberBoard.Service.TagoService;

@Controller
public class TagoController {
	
	@Autowired
	private TagoService tsvc;
	
	@RequestMapping(value = "/getBusNodeList")
	public @ResponseBody String getBusNodeList(String citycode, String routeid) throws Exception{
		System.out.println("버스 노선 정보 요청");
		String result = tsvc.getBusNodeList(citycode, routeid);
		return result;
	}
	
	@RequestMapping(value="/getBusLocList")
	public @ResponseBody String getBusLocList(String citycode, String routeid) throws Exception{
		System.out.println("버스 위치 정보 조회 요청");
		String result = tsvc.getBusLocList(citycode, routeid);
		return result;
	}
	
	@RequestMapping(value = "/getBusArrInfo")
	public @ResponseBody String getBusArrInfo(String nodeid, String citycode) throws Exception {
		System.out.println("버스 도착정보 받아오기 호출");
		String result = tsvc.getBusArrInfo(nodeid, citycode);
		return result;
	}
	@RequestMapping(value = "/getBusSttnList")
	public @ResponseBody String getBusSttnList(String latitude, String longtitude) throws Exception{
		System.out.println("정류소 정보 받아오기 호출");
		String result = tsvc.getBusSttnList(latitude, longtitude);
		return result;
	}

	@RequestMapping(value = "/tagoBus")
	public ModelAndView tagoBus() {
		System.out.println("타고버스 페이지 이동");
		ModelAndView mav = new ModelAndView();
		mav.setViewName("TagoBus");
		return mav;
		
	}
}
