package net.plan.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/* 국가페이지, 도시페이지 리뷰 커뮤니티관련 DB작업 */
public class PlanCommentDAO {

	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String sql = null;

	private Connection getConnection() throws Exception {

		Connection con = null;
		// Context 객체 생성
		Context init = new InitialContext();
		// DateSource = 디비연동 이름 불러오기
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/mySQL");
		// con = DataSource
		con = ds.getConnection();
		return con;
	}
	
	// 리뷰 작성
	public void insertNationComment(PlanNationCommentBean pncb) {
		
		int num = 0;
		int nation_num = 0;
		
		String content = pncb.getContent().replaceAll("\n", "<br>");
		
		try {
			
			con = getConnection();
			
			// 전체 국가페이지 리뷰글의 num 파악
			sql = "select max(num) as num from nation_comment";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();	
			if(rs.next()) {
				num = rs.getInt("num") + 1;	// 넣을 num 값
			}
			
			// 특정 국가의 num 파악
			sql = "select max(nation_num) as nation_num from nation_comment where nation=?";
			ps = con.prepareStatement(sql);
			ps.setString(1, pncb.getNation());
			rs = ps.executeQuery();
			if(rs.next()) {
				nation_num = rs.getInt("nation_num") + 1;	// 넣을 nation_num 값
			}
			
			// DB에 넣기
			sql = "insert into nation_comment(num, nation, nation_num, nick, date, eval, content)"
					+ "values(?, ?, ?, ?, ?, ?, ?)";
			ps = con.prepareStatement(sql);
			ps.setInt(1, num);
			ps.setString(2, pncb.getNation());
			ps.setInt(3, nation_num);
			ps.setString(4, pncb.getNick());
			Timestamp date = new Timestamp(System.currentTimeMillis());	// 현재시간
			ps.setTimestamp(5, date);
			ps.setInt(6, pncb.getEval());
			ps.setString(7, pncb.getContent());
			
			ps.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}

	// 특정 리뷰 리스트 가져오기
	public List<PlanNationCommentBean> getListComment(String nation) {
		
		List<PlanNationCommentBean> list = new ArrayList<PlanNationCommentBean>();
		
		try {
			
			con = getConnection();
			
			sql = "select * from nation_comment where nation = ? order by nation_num desc";
			ps = con.prepareStatement(sql);
			ps.setString(1, nation);
			rs = ps.executeQuery();

			while(rs.next()) {
				PlanNationCommentBean pcb = new PlanNationCommentBean();
				pcb.setContent(rs.getString("content"));
				pcb.setDate(rs.getTimestamp("date"));
				pcb.setEval(rs.getInt("eval"));
				pcb.setNation(rs.getString("nation"));
				pcb.setNation_num(rs.getInt("nation_num"));
				pcb.setNick(rs.getString("nick"));
				pcb.setNum(rs.getInt("num"));
				
				list.add(pcb);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
	
}
