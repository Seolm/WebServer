package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import dao2.LocationDAO;
import model.Location;
import publishData.Publish;

@WebServlet("/DataController")
public class DataController extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
    public DataController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("type").toString();
		String msg = request.getParameter("pubmsg").toString();
		if(type.equals("knn"))
			getKneighbors(response, msg);
		else if(type.equals("tracking"))
			getLog(response, msg);
		else if(type.equals("realtime")) 
	         getUsersCountByDistrict(response, msg);
		else if(type.equals("duration")) 
	         getUsersCountByDuration(response, msg);
		else if(type.equals("oneday")) 
	         getUsersCountByDistrictDuringTheDay(response, msg);

		else response.getWriter().print(choiceMethod(type, msg));
	}

	public boolean choiceMethod(String type, String msg) {
		if(type.equals("district")) {
			String district = msg.split(",")[0];
			String pubmsg = msg.split(",")[1];
			publishDistrict(district, pubmsg);
		} else if(type.equals("locationRec")) {
			Double[] locations = new Double[4]; //북동위도,북동경도,남서위도,남서경도
			String sp = msg.split(",")[5]; // emer or nomal
			String pubmsg="";
			for(int i=0; i<4; i++) {
				locations[i] = Double.parseDouble(msg.split(",")[i]);
			}
			if(sp.equals("nomal")) {
				pubmsg = msg.split(",")[4]+","+msg.split(",")[5]+","+msg.split(",")[6];
			}
			if(sp.equals("emer")) {
				pubmsg = msg.split(",")[4]+","+msg.split(",")[5]+","+msg.split(",")[6]+","+msg.split(",")[7]+","+msg.split(",")[8];
			}
			publishLocationRec(locations, pubmsg);
		} else if(type.equals("locationCir")) {
			Double[] center = new Double[2];
			int radius = Integer.parseInt(msg.split(",")[2]);
			String sp = msg.split(",")[4];
			String pubmsg = "";
			for(int i=0; i<2; i++) {
				center[i] = Double.parseDouble(msg.split(",")[i]);
			}
			if(sp.equals("nomal")) {
				pubmsg = msg.split(",")[3]+","+msg.split(",")[4]+","+msg.split(",")[5];
			}
			if(sp.equals("emer")) {
				pubmsg = msg.split(",")[3]+","+msg.split(",")[4]+","+msg.split(",")[5]+","+msg.split(",")[6]+","+msg.split(",")[7];
			}
			publishLocationCir(center, radius, pubmsg);
		} else if(type.equals("publishKnn")) {
			String sp = msg.split(",")[1];
			String pubmsg = "";
			int clientNum = 0;
			List<String> clients = new ArrayList<String>();
			if(sp.equals("nomal")) {
				pubmsg = msg.split(",")[0]+","+msg.split(",")[1]+","+msg.split(",")[2];
				clientNum = Integer.parseInt(msg.split(",")[3])+4;
				for(int i=4; i<clientNum; i++) {
					clients.add(msg.split(",")[i]);
				}
			}
			if(sp.equals("emer")) {
				pubmsg = msg.split(",")[0]+","+msg.split(",")[1]+","+msg.split(",")[2]+","+msg.split(",")[3]+","+msg.split(",")[4];
				clientNum = Integer.parseInt(msg.split(",")[5])+6;
				for(int i=6; i<clientNum; i++) {
					clients.add(msg.split(",")[i]);
				}
			}
			publishKnn(clients, pubmsg);
		}
		return true;
	}

	private void publishKnn(List<String> clients, String pubmsg) {
		Publish.getInstance().publishKnn(clients, pubmsg);
	}

	public void publishDistrict(String district, String pubmsg) {
		Publish.getInstance().publishDistrict(district, pubmsg);
	}
	
	public void publishLocationRec(Double[] locations, String pubmsg) {
		Publish.getInstance().publishLocationRec(locations, pubmsg);
	}
	
	private void publishLocationCir(Double[] center, int radius, String pubmsg) {
		Publish.getInstance().publishLocationCir(center, radius, pubmsg);
	}
	
	@SuppressWarnings("unchecked")
	private void getKneighbors(HttpServletResponse response, String msg) throws IOException {
		Double[] center = new Double[2];
		for(int i=0; i<2; i++) {
			center[i] = Double.parseDouble(msg.split(",")[i]);
		}
		int radius = Integer.parseInt(msg.split(",")[2]);
		int people = Integer.parseInt(msg.split(",")[3]);
		String client = msg.split(",")[4];
		
		List<String> clients = LocationDAO.getInstance().getKneighbors(center, radius, people, client);
		JSONObject data = new JSONObject();
		//HashMap<String, Object> myMap = new HashMap<String, Object>();
		//myMap.put("clients", clients);
		data.put("clients", clients);
		System.out.println(data);
		response.getWriter().print(data);
		response.getWriter().flush();
	}

	@SuppressWarnings("unchecked")
	public void getLog(HttpServletResponse response, String msg) throws IOException {
		String client = msg.split(",")[0];
		long[] dates = new long[2];
		for(int i=0; i<2; i++) {
			dates[i] = Long.parseLong(msg.split(",")[i+1]);
		}
		List<Location> trackingLogs = LocationDAO.getInstance().getTrackingData(dates, client);
		JSONObject data = new JSONObject();
		for(int i=0; i<trackingLogs.size(); i++) {
			HashMap<String, Object> myMap = new HashMap<String, Object>();
			myMap.put("latitude", trackingLogs.get(i).getLatitude());
			myMap.put("longitude", trackingLogs.get(i).getLongitude());
			myMap.put("time", trackingLogs.get(i).getTime());
			data.put("d"+i, myMap);
		}
		System.out.println(data);
		response.getWriter().print(data);
		response.getWriter().flush();
	}
	
	private void getUsersCountByDistrict(HttpServletResponse response, String msg) throws IOException {
	    String district = msg.split(",")[0];
	      int cnt = LocationDAO.getInstance().getUsersCountByDistrict(district);
	      response.getWriter().write(Integer.toString(cnt));
	      response.getWriter().flush();
	}
	   
	private void getUsersCountByDuration(HttpServletResponse response, String msg) throws IOException {
	      String district = msg.split(",")[0];
	      String fromDate = msg.split(",")[1];
	      String toDate = msg.split(",")[2];
	      int[] cnt = LocationDAO.getInstance().getUsersCountByDuration(district, fromDate, toDate);
	      response.getWriter().write(Arrays.toString(cnt));
	      response.getWriter().flush();
	   }
	   
	private void getUsersCountByDistrictDuringTheDay(HttpServletResponse response, String msg) throws IOException {
	      String date = msg;
	      int[] cnt = LocationDAO.getInstance().getUsersCountByDistrictDuringTheDay(date);
	      response.getWriter().write(Arrays.toString(cnt));
	      response.getWriter().flush();
	   }

}
