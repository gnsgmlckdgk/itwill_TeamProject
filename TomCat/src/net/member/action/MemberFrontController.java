package net.member.action;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MemberFrontController extends HttpServlet {
 
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String uriPath = request.getRequestURI();
		String contextPath = request.getContextPath();
		String command = uriPath.substring(contextPath.length());
		
		// 이동정보 담는 객체
		ActionForward forward = null;
		// 처리담당 객체
		Action action = null;
		
		if(command.equals("/Main.me")) {	// 메인 페이지
			
			forward = new ActionForward();
			forward.setPath("./main/main.jsp");
			forward.setRedirect(false);
		
		}else if(command.equals("/MemberJoin.me")) {	// 회원가입 입력 페이지
			
			action = new MemberJoinKeySetting();
			try {
				forward = action.execute(request, response);
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}else if(command.equals("/MemberJoinAction.me")) {		// 회원가입 DB작업
			
			action = new MemberJoinAction();
			try {
				forward = action.execute(request, response);
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}else if(command.equals("/MemberLoginAction.me")) {		// 로그인 처리
			
			action = new MemberLoginAction();
			try {
				forward = action.execute(request, response);
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}else if(command.equals("/MemberIdFinder.me")) {	// 아이디 찾기 입력 페이지(팝업 브라우저)
			
			forward = new ActionForward();
			forward.setPath("./member/idFinder.jsp");
			forward.setRedirect(false);
			
		}else if(command.equals("/MemberIdFinderAction.me")) {	// 아이디 찾기 처리(팝업 브라우저)
			
			action = new MemberIdFinderAction();
			
			try {
				forward = action.execute(request, response);
				
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		// 이동
		if(forward!=null) {
			if(forward.isRedirect()) {	// response방식
				response.sendRedirect(forward.getPath());
			}else {	// forward방식
				RequestDispatcher dispatcher = request.getRequestDispatcher(forward.getPath());
				dispatcher.forward(request, response);
			}
		}
		
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
}
