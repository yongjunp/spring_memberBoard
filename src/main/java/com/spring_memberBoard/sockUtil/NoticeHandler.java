package com.spring_memberBoard.sockUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class NoticeHandler extends TextWebSocketHandler {

	private ArrayList<WebSocketSession> clientList = new ArrayList<WebSocketSession>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		clientList.add(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		//클라이언트가 웹소켓에 메세지를 전송 했을 때 실행
		JsonObject noticeObj = JsonParser.parseString(message.getPayload()).getAsJsonObject();

		String noticeType = noticeObj.get("noticeType").getAsString();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgtype", noticeType);
		// 서버가 접속중인 클라이언트들에게 메세지 전송
		switch(noticeType) {
		case "reply": // 개별 전송
			String bno = noticeObj.get("noticeMsg").getAsString();
			String bwriter = noticeObj.get("receiveId").getAsString();
			msgInfo.put("msgcomm", bno);
			for(WebSocketSession client : clientList) {
				Map<String , Object> clientAttrs = client.getAttributes();
				String clientMemberId = (String)clientAttrs.get("loginMemberId");
				if(clientMemberId.equals(bwriter)) {
					client.sendMessage(new TextMessage(new Gson().toJson(msgInfo)));
				}
			}
			
			break;
		case "board":
			msgInfo.put("msgcomm", "새 글이 등록 되었습니다.");
			for(WebSocketSession client:clientList) {
				client.sendMessage(new TextMessage(new Gson().toJson(msgInfo)));
			}
			break;
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		clientList.remove(session);
	}

}
