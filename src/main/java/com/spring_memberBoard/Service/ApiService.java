package com.spring_memberBoard.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;

import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.spring_memberBoard.dto.Bus;

@Service
public class ApiService {

	public ArrayList<Bus> getBusArrive() throws Exception {
		System.out.println("SERVICE getBusArrive() 호출");
		 StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList"); /*URL*/
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Ha5wLAXuqk%2BGLjVvX5y6gDz38gttgHM%2B0kgvlLiwg5m7r%2F%2FTGaJErgkksxjqbKRnpgTe%2FPeigGvbbrWg7JzXZA%3D%3D"); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
	        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*데이터 타입(xml, json)*/
	        urlBuilder.append("&" + URLEncoder.encode("cityCode","UTF-8") + "=" + URLEncoder.encode("23", "UTF-8")); /*도시코드 [상세기능3 도시코드 목록 조회]에서 조회 가능*/
	        urlBuilder.append("&" + URLEncoder.encode("nodeId","UTF-8") + "=" + URLEncoder.encode("ICB163000063", "UTF-8")); /*정류소ID [국토교통부(TAGO)_버스정류소정보]에서 조회가능*/
	        URL url = new URL(urlBuilder.toString());
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        System.out.println("Response code: " + conn.getResponseCode());
	        BufferedReader rd;
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        System.out.println("222222222" + sb.toString());
	        
	        // 변환
	        JsonObject busInfo_Json = (JsonObject) JsonParser.parseString(sb.toString());
	        
	        JsonArray infoList = busInfo_Json.get("response").getAsJsonObject().get("body").getAsJsonObject().get("items").getAsJsonObject().get("item").getAsJsonArray();
	        System.out.println(infoList);
	        System.out.println(infoList.size());
	        ArrayList<Bus> busList = new ArrayList<Bus>();
	        for(int i = 0; i< infoList.size(); i++) {
	        	Bus bus = new Bus();
	        	String nodenm = infoList.get(i).getAsJsonObject().get("nodenm").getAsString();
	        	bus.setNodenm(nodenm);
	        	
	        	String routeno = infoList.get(i).getAsJsonObject().get("routeno").getAsString();
	        	bus.setRouteno(routeno);
	        	
	        	String arrprevstationcnt = infoList.get(i).getAsJsonObject().get("arrprevstationcnt").getAsString();
	        	bus.setArrprevstationcnt(arrprevstationcnt);
	        	
	        	String arrtime = infoList.get(i).getAsJsonObject().get("arrtime").getAsString();
	        	bus.setArrtime(arrtime);
	        	busList.add(bus);
	        	
	        }
	        System.out.println(busList);
	        for(JsonElement item : infoList) {
	        	
	        }
	        
//	        JsonObject busInfo_body = busInfo_Json.get("response").getAsJsonObject().get("body").getAsJsonObject();
//	        	   
//	        JsonObject busInfo_Items = busInfo_body.get("items").getAsJsonObject();
//	        System.out.println(busInfo_Items);
//	        
//	        JsonArray itemList = busInfo_Items.get("item").getAsJsonArray();
//	        System.out.println(itemList);
//	        
//	        System.out.println(itemList.size());
	        
	        
	        
		return busList;
	}

	public String getBusArr(String nodeId, String citycode) throws Exception  {
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Ha5wLAXuqk%2BGLjVvX5y6gDz38gttgHM%2B0kgvlLiwg5m7r%2F%2FTGaJErgkksxjqbKRnpgTe%2FPeigGvbbrWg7JzXZA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*데이터 타입(xml, json)*/
        urlBuilder.append("&" + URLEncoder.encode("cityCode","UTF-8") + "=" + URLEncoder.encode(citycode, "UTF-8")); /*도시코드 [상세기능3 도시코드 목록 조회]에서 조회 가능*/
        urlBuilder.append("&" + URLEncoder.encode("nodeId","UTF-8") + "=" + URLEncoder.encode(nodeId, "UTF-8")); /*정류소ID [국토교통부(TAGO)_버스정류소정보]에서 조회가능*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println(sb.toString());
        
        //변환
        JsonObject busInfo_Json = JsonParser.parseString(sb.toString()).getAsJsonObject();
        
        JsonArray infoList = busInfo_Json.get("response").getAsJsonObject().get("body").getAsJsonObject().get("items").getAsJsonObject().get("item").getAsJsonArray();
        
		return new Gson().toJson(infoList);
	}

	public String getBusSttn(String lati, String longti) throws Exception {
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getCrdntPrxmtSttnList"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Ha5wLAXuqk%2BGLjVvX5y6gDz38gttgHM%2B0kgvlLiwg5m7r%2F%2FTGaJErgkksxjqbKRnpgTe%2FPeigGvbbrWg7JzXZA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*데이터 타입(xml, json)*/
        urlBuilder.append("&" + URLEncoder.encode("gpsLati","UTF-8") + "=" + URLEncoder.encode(lati, "UTF-8")); /*WGS84 위도 좌표*/
        urlBuilder.append("&" + URLEncoder.encode("gpsLong","UTF-8") + "=" + URLEncoder.encode(longti, "UTF-8")); /*WGS84 경도 좌표*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println(sb.toString());

        JsonObject arrBusSttn = JsonParser.parseString(sb.toString()).getAsJsonObject();
        JsonArray busSttn = arrBusSttn.get("response").getAsJsonObject().get("body").getAsJsonObject().get("items").getAsJsonObject().get("item").getAsJsonArray();
        
		return new Gson().toJson(busSttn);
	}

	public String getBusId(String routeno, String citycode) throws Exception {
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BusRouteInfoInqireService/getRouteNoList"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Ha5wLAXuqk%2BGLjVvX5y6gDz38gttgHM%2B0kgvlLiwg5m7r%2F%2FTGaJErgkksxjqbKRnpgTe%2FPeigGvbbrWg7JzXZA%3D%3D"); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*데이터 타입(xml, json)*/
        urlBuilder.append("&" + URLEncoder.encode("cityCode","UTF-8") + "=" + URLEncoder.encode(citycode, "UTF-8")); /*도시코드 [상세기능4. 도시코드 목록 조회]에서 조회 가능*/
        urlBuilder.append("&" + URLEncoder.encode("routeNo","UTF-8") + "=" + URLEncoder.encode(routeno, "UTF-8")); /*노선번호*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println(sb.toString());
        
        JsonObject busLocaList = JsonParser.parseString(sb.toString()).getAsJsonObject();
        System.out.println("여기1번"+busLocaList);
        JsonArray busLocaArr = busLocaList.get("response").getAsJsonObject().get("body").getAsJsonObject().get("items").getAsJsonObject().get("item").getAsJsonArray();
        System.out.println("여기2번"+busLocaArr);
		return new Gson().toJson(busLocaArr);
	}

	public String getBusLocation(String routeid, String citycode) throws Exception {
		 StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1613000/BusLcInfoInqireService/getRouteAcctoBusLcList"); /*URL*/
	        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Ha5wLAXuqk%2BGLjVvX5y6gDz38gttgHM%2B0kgvlLiwg5m7r%2F%2FTGaJErgkksxjqbKRnpgTe%2FPeigGvbbrWg7JzXZA%3D%3D"); /*Service Key*/
	        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
	        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*한 페이지 결과 수*/
	        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8") + "=" + URLEncoder.encode("json", "UTF-8")); /*데이터 타입(xml, json)*/
	        urlBuilder.append("&" + URLEncoder.encode("cityCode","UTF-8") + "=" + URLEncoder.encode(citycode, "UTF-8")); /*도시코드 [상세기능3 도시코드 목록 조회]에서 조회 가능*/
	        urlBuilder.append("&" + URLEncoder.encode("routeId","UTF-8") + "=" + URLEncoder.encode(routeid, "UTF-8")); /*노선ID [국토교통부(TAGO)_버스노선정보]에서 조회가능*/
	        URL url = new URL(urlBuilder.toString());
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Content-type", "application/json");
	        System.out.println("Response code: " + conn.getResponseCode());
	        BufferedReader rd;
	        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        } else {
	            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
	        }
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = rd.readLine()) != null) {
	            sb.append(line);
	        }
	        rd.close();
	        conn.disconnect();
	        System.out.println(sb.toString());
	        
	        JsonObject busLocaOb = JsonParser.parseString(sb.toString()).getAsJsonObject();
	        JsonArray busLocaArray = busLocaOb.get("response").getAsJsonObject().get("body").getAsJsonObject().get("items").getAsJsonObject().get("item").getAsJsonArray();
		return new Gson().toJson(busLocaArray);
	}
	}
