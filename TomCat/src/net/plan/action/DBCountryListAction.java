package net.plan.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.plan.db.PlanCountryBean;
import net.plan.db.PlanDAO;

public class DBCountryListAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");

		ActionForward forward = new ActionForward();

		System.out.println("DBcountryList execute()");

		PlanDAO pdao = new PlanDAO();

		// 전체글의 개수 구하기
		int count = pdao.getCountryCount();

		// 한페이지에 보여줄 글의 개수 설정
		int pageSize = 10;

		// 현재 페이지가 몇페이지인지 가져오기
		String pageNum = request.getParameter("pageNum");
		if (pageNum == null) {
			pageNum = "1";
		}

		// 시작행 구하기
		int currentPage = Integer.parseInt(pageNum);
		int startRow = (currentPage - 1) * pageSize + 1;

		// 끝행 구하기
		int endRow = currentPage * pageSize;

		List<PlanCountryBean> countryList = null;
		if (count != 0) {
			countryList = pdao.getCountryList(startRow, pageSize);
		}

		int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);

		int pageBlock = 10;

		int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;

		int endPage = startPage + pageBlock - 1;
		if (endPage > pageCount) {
			endPage = pageCount;
		}

		request.setAttribute("pageNum", pageNum);
		request.setAttribute("count", count);
		request.setAttribute("pageCount", pageCount);
		request.setAttribute("pageBlock", pageBlock);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);

		request.setAttribute("countryList", countryList);

		forward = new ActionForward();
		forward.setPath("./plan/countryList.jsp");
		forward.setRedirect(false);
		return forward;
	}

}