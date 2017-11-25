package com.github.elizabetht.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.github.elizabetht.repository.StudentRepository;

/**
 * Servlet implementation class StudentController
 */

@SuppressWarnings("serial")
public class StudentController extends HttpServlet {
	private StudentRepository studentRepository;

	private static String STUDENT_SIGNUP = "content/signup.jsp";
	private static String STUDENT_LOGIN = "content/login.jsp";
	private static String LOGIN_SUCCESS = "content/success.jsp";
	private static String LOGIN_FAILURE = "content/failure.jsp";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StudentController() {
		super();
		studentRepository = new StudentRepository();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {	
		String forward = STUDENT_SIGNUP;
		RequestDispatcher view = request.getRequestDispatcher(forward);
		view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String pageName = request.getParameter("pageName");
		String clientName = request.getParameter("clientName");
		System.out.println("clientName"+clientName);
		String forward = "";		
		System.out.println("pageName"+pageName);
		
			if (pageName.equals("signup")) {
				if (studentRepository.findByUserName(request
						.getParameter("userName"))) {
					request.setAttribute("message", "User Name exists. Try another user name");
					forward = STUDENT_SIGNUP;
					RequestDispatcher view = request
							.getRequestDispatcher(forward);
					view.forward(request, response);
					return;
				}

//				studentRepository.save(request.getParameter("userName"),
//						request.getParameter("password"),
//						request.getParameter("firstName"),
//						request.getParameter("lastName"),
//						request.getParameter("dateOfBirth"),
//						request.getParameter("emailAddress"));
//				forward = STUDENT_LOGIN;
			} else if (pageName.equals("login")) {
				boolean result = studentRepository.findByLogin(
						request.getParameter("userName"),
						request.getParameter("password"));
				if (result == true) {
					forward = LOGIN_SUCCESS;
				} else {
					forward = LOGIN_FAILURE;
				}
			}
			 pageName = request.getParameter("pageName");
			
			if(pageName.equals("addQuestion")) {
				System.out.println("Client Name"+request.getParameter("clientName"));
				System.out.println("User Name"+request.getParameter("userName"));
			}
			
			if(pageName.equals("addClient")) {
				System.out.println("Calling Student Repository");
				studentRepository.saveClient(request
						.getParameter("userName"),request
						.getParameter("clientName"));
			}
			
			if(pageName.equals("searchQuestion")) {
				String action = request.getParameter("action");
				if(action!=null && action.equalsIgnoreCase("Search")) {
				System.out.println("Calling Student Repository");
				studentRepository.searchQuestion(request
						.getParameter("qText"));
				}else if(action!=null && action.equalsIgnoreCase("AddQuestion")){
					studentRepository.addQuestion(request
							.getParameter("qText"));
				}
			}
			
			
		RequestDispatcher view = request.getRequestDispatcher(forward);
		view.forward(request, response);
	}
}
