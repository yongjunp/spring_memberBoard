package com.spring_memberBoard.sockUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

public class ChatHandler extends TextWebSocketHandler{

	ArrayList<WebSocketSession> clientList = new ArrayList<WebSocketSession>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("채팅 입장");
		clientList.add(session);
		System.out.println(session);
		Map<String, Object> loginClient = session.getAttributes();
		String loginId = (String)loginClient.get("loginMemberId");
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgid", loginId);
		msgInfo.put("msgtype", "c");
		msgInfo.put("msg", " 입장하였습니다");
		for(WebSocketSession client : clientList) {
			if(!client.equals(session)) {
				client.sendMessage( new TextMessage(gson.toJson(msgInfo)));
			}
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("채팅 메세지 보냄");
		System.out.println("메세지 : " + message);
		
		Map<String, Object> loginClient = session.getAttributes();
		String loginId = (String)loginClient.get("loginMemberId");
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgid", loginId);
		msgInfo.put("msgtype", "m");
		msgInfo.put("msg", message.getPayload());
		for(WebSocketSession client : clientList) {
			if(!client.equals(session)) {
				client.sendMessage( new TextMessage(gson.toJson(msgInfo)));
			}
		}
		
		
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("채팅 퇴장");
		clientList.remove(session);
		Map<String, Object> loginClient = session.getAttributes();
		String loginId = (String)loginClient.get("loginMemberId");
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgid", loginId);
		msgInfo.put("msgtype", "d");
		msgInfo.put("msg", " 퇴장하였습니다.");
		for(WebSocketSession client : clientList) {
				client.sendMessage( new TextMessage(gson.toJson(msgInfo)));
		}
	}

}
