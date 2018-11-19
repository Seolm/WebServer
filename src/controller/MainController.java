package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MainController")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public MainController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String page = null;
		String param = null;
		param = request.getParameter("param");
		if(param.equals("main"))
			page = "/index.jsp";
		else if(param.equals("district"))
			page = "/districtMsg.jsp";
		else if(param.equals("neighborhood"))
			page = "/neighborhoodMsg.jsp";
		else if(param.equals("rectangle"))
			page = "/rectangle.jsp";
		else if(param.equals("circle"))
			page = "/circle.jsp";
		else if(param.equals("dashboard"))
			page = "/dashboard.jsp";
		else if(param.equals("tracking"))
			page = "/tracking.jsp";
		else
			System.out.println("잘못된 경로============");
		
		//System.out.println(param);
		System.out.println(page);
		RequestDispatcher rd = getServletContext().getRequestDispatcher(page);
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
