package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import dao2.LocationDAO;
import model.Location;

/**
 * Servlet implementation class LocationController
 */
@WebServlet("/LocationController")
public class LocationController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public LocationController() {
		System.out.println("make servlet");
		// mqttCallbackClient.publish("topic1", 1, "publish/subscribe test");
		// mqttCallbackClient.unsubscribe("topic1");
		// mqttCallbackClient.publish("topic1", 1, "unsubscribe test");
		// mqttCallbackClient.disconnect();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		response.getWriter().print(getJSON());
		response.getWriter().flush();
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject getJSON() {
		/*StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		Location location = LocationDAO.getInstance().getLeastLocation();
		result.append("{\"value\": \"" + location.getLatitude() + "\"},");
		result.append("{\"value\": \"" + location.getLongitude() + "\"]}");*/
		List<Location> listLocation = LocationDAO.getInstance().getAllLeastLocation();
		JSONObject data = new JSONObject();
		for(int i=0; i<listLocation.size(); i++) {
			HashMap<String, Object> myMap = new HashMap<String, Object>();
			myMap.put("client_id", listLocation.get(i).getClient_id());
			myMap.put("latitude", listLocation.get(i).getLatitude());
			myMap.put("longitude", listLocation.get(i).getLongitude());
			myMap.put("time", listLocation.get(i).getTime());
			data.put("c"+i, myMap);
		}
		/*JSONArray jsonArray = new JSONArray();
		for(Location location : listLocation) {
			HashMap<String, Object> myMap = new HashMap<String, Object>();
			myMap.put("client_id", location.getClient_id());
			myMap.put("latitude", location.getLatitude());
			myMap.put("longitude", location.getLongitude());
			myMap.put("time", location.getTime());
			JSONObject jsonObject = new JSONObject(myMap);
			jsonArray.add(jsonObject);
		}
		data.put("locations", jsonArray);*/
		/*for(Location location : listLocation) {
			JSONArray jsonArray = new JSONArray();
			HashMap<String, Object> myMap = new HashMap<String, Object>();
			myMap.put("client_id", location.getClient_id());
			myMap.put("latitude", location.getLatitude());
			myMap.put("longitude", location.getLongitude());
			myMap.put("time", location.getTime());
			JSONObject jsonObject = new JSONObject(myMap);
			jsonArray.add(jsonObject);
			data.put(location.getClient_id(), jsonArray);
		}*/
		/*System.out.println("======== 위치 최신화 =========");
		System.out.println(data);*/
		return data;
	}

}
