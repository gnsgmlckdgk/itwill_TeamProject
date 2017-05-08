package net.member.db;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

public class MemberDAO {
	
	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String sql = "";
	
	// Connection pool
	private Connection getConnection() throws Exception {
		Context init = new InitialContext();
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/mySQL");
		con = ds.getConnection();
		
		return con;
	}
	
	// 아이디(이메일) 중복체크 및 존재여부(추가기능)
	public int idOverlapCheck(String id) {
		int check = 0;	// 0은 중복, 1은 사용가능
		
		try {
			con = getConnection();
			
			sql = "select count(id) as count from member where id=?";
			ps = con.prepareStatement(sql);
			ps.setString(1, id);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt("count") > 0) {	// 아이디 중복, 아이디 존재
					check = 0;
				}else {										// 아이디 사용가능, 아이디 존재안함
					check = 1;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return check;
	}
	
	// 닉네임 중복체크
	public int nickOverlapCheck(String nick) {
		int check = -1;	// -1: 정규표현식 오류, 0: 중복, 1: 사용가능
		
		// 정규표현식 검사
		// 영문, 한글 시작 영문,숫자,한글 조합 가능 2~9자
		if(!Pattern.matches("^[a-z|A-Z|가-힣][a-z|A-Z|0-9|가-힣]{1,8}", nick)) {		// 정규표현식에 맞지 않으면
			return check;	// -1 반환
		}
		
		// 중복검사
		try{
			con = getConnection();
			
			sql = "select count(id) as count from member where nick=?";
			ps = con.prepareStatement(sql);
			ps.setString(1, nick);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt("count") == 0) {
					check = 1;
				}else if(rs.getInt("count")>0) {
					check = 0;
				}
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return check;
	}
	
	// 닉네임 중복체크2(같은 id의 닉네임은 중복되도 중복아님)
		public int nickOverlapCheck2(String id, String nick) {
			int check = -1;	// -1: 정규표현식 오류, 0: 중복, 1: 사용가능
			
			// 정규표현식 검사
			// 영문, 한글 시작 영문,숫자,한글 조합 가능 2~9자
			if(!Pattern.matches("^[a-z|A-Z|가-힣][a-z|A-Z|0-9|가-힣]{1,8}", nick)) {		// 정규표현식에 맞지 않으면
				return check;	// -1 반환
			}
			
			// 중복검사
			try{
				con = getConnection();
				
				sql = "select id count from member where nick=? && !(id=?)";
				ps = con.prepareStatement(sql);
				ps.setString(1, nick);
				ps.setString(2, id);
				rs = ps.executeQuery();
				
				if(rs.next()) {
					check = 0;
				}else {
					check = 1;
				}
				
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				try{
					if(rs!=null) rs.close();
					if(ps!=null) ps.close();
					if(con!=null) con.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
			
			return check;
		}
	
	// 회원가입
	public void insertMember(MemberBean mb) {
		
		/* DB암호화 */
		// 비밀번호 단방향 암호화(SHA-256)
		// 전화번호 양방향 암호화(AES)
		
		// MySQL버전이 낮아져 PASSWORD() 함수로 암호화 하는 방식으로 변경
		
		try {
			con = getConnection();
			
			sql = "insert into member(id, pass, name, nick, gender, tel, reg_date, profile, auth) "
					+ "values(?,PASSWORD(?), ?, ?, ?, HEX(AES_ENCRYPT(?, 'tel')), ?, ?, ?)";
			ps = con.prepareStatement(sql);
			ps.setString(1, mb.getId());
			ps.setString(2, mb.getPass());
			ps.setString(3, mb.getName());
			ps.setString(4, mb.getNick());
			ps.setString(5, mb.getGender());
			ps.setString(6, mb.getTel());		// 암호화키 임시로 tel로 해놓음
			ps.setTimestamp(7, mb.getReg_date());
			ps.setString(8, mb.getProfile());
			ps.setInt(9, mb.getAuth());		// 처음 가입땐 1(일반사용자)
			
			ps.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}

	// 로그인 인증
	public int memberLogin(String id, String pass) {
		
		// 0 아이디 또는 비밀번호 틀림, 1 비밀번호 맞음
		int check = 0;
		
		try {
			
			con = getConnection();
			
			// DB의 pass가 단방향 암호화 SHA-256으로 되어있기때문에 매개변수 pass를 SHA-256암호화 후 비교한다.
			// MySQL 버전이 낮아져 PASSWORD() 함수를 사용한 암호화 방식으로 변경
			sql = "select id from member where pass=PASSWORD(?)";
			ps = con.prepareStatement(sql);
			ps.setString(1, pass);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				if(rs.getString("id").equals(id)) {
					check = 1;
					return check;
				}else {
					check = 0;
				}
			}
			
			// SHA256 방식
			/*if(rs.next()) {
				String passSHA = txtSHA256(pass);	// SHA256 암호화
				if(rs.getString("pass").equals(passSHA)) {
					check = 1;
				}else {	// 비밀번호 틀림
					check = 0;
				}
			}else {	// 아이디 없음
				check = -1;
			}*/	
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return check;
	}
	
	// DB 서버 호스팅하면서 MySQL 버전이 낮아져 불가피하게 SHA256에서 PASSWORD() 함수를 쓰는 방식으로 변경
	// PASSWORD() 함수로 암호화 하는 것은 MySQL 사용자 자체의 계정 및 비밀번호를 관리하기 위한 함수여서 일반 서비스용 계정 및 암호를 관리하는 용도로는 적합하지 않다. ㅠㅠ
	
/*	// SHA256 암호화(비밀번호 확인 시 필요)
	public String txtSHA256(String str){
	
		String SHA = ""; 
	
		try{
			MessageDigest sh = MessageDigest.getInstance("SHA-256"); 
			sh.update(str.getBytes());
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer(); 
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}
			SHA = sb.toString();

		}catch(NoSuchAlgorithmException e){
			System.out.println("SHA256암호화 오류");
			e.printStackTrace(); 
			SHA = null; 
		}
			return SHA;
	}*/
	
	// 회원정보 가져오기
	public MemberBean getMember(String id) {
		
		MemberBean mb = new MemberBean();
		
		try {
			
			con = getConnection();
			
			sql = "select id, pass, name, nick, gender, AES_DECRYPT(UNHEX(tel), 'tel') as tel, reg_date, profile, auth"
					+ " from member where id = ?";
			ps = con.prepareStatement(sql);
			
			ps.setString(1, id);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {	// 아이디가 있으면
				
				mb.setId(id);
				mb.setPass(rs.getString("pass"));
				mb.setName(rs.getString("name"));
				mb.setNick(rs.getString("nick"));
				mb.setGender(rs.getString("gender"));
				mb.setTel(rs.getString("tel"));
				mb.setReg_date(rs.getTimestamp("reg_date"));
				mb.setProfile(rs.getString("profile"));
				mb.setAuth(rs.getInt("auth"));
				
			}else {	// 아이디가 없으면
				return mb;
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return mb;
	}
	
	// 읽어버린 아이디 찾기
	public List<MemberBean> getFinderMemberId(String name, String tel) {
	
		List<MemberBean> idList = new ArrayList<MemberBean>();
		
		try {			
			con = getConnection();
			
			sql = "select id, reg_date from member where name=? && AES_DECRYPT(UNHEX(tel), 'tel') = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, name);
			ps.setString(2, tel);
			
			rs = ps.executeQuery();
			
			MemberBean mb;
			while(rs.next()) {
				mb = new MemberBean();
				mb.setId(rs.getString("id"));
				mb.setReg_date(rs.getTimestamp("reg_date"));
				
				idList.add(mb);
			}
			
		}catch(Exception e) {
			System.out.println("MemberDAO->getFinderMemberId()에서 예외발생");
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return idList;
		
	}
	
	// 읽어버린 비밀번호 찾기
	public void updatePass(String id, String pass) {
		
		// 임시비밀번호를 메일로 보내고 DB에서도 비밀번호를 수정한다.
		try {
			
			con = getConnection();
			
			// 임시비밀번호 SHA256 암호화
			// MySQL 버전이 낮아져 PASSWORD() 방식으로 변경
			sql = "update member set pass = PASSWORD(?) where id = ? ";
			ps = con.prepareStatement(sql);
			ps.setString(1, pass);
			ps.setString(2, id);
			
			ps.executeUpdate();
			
		}catch(Exception e) {
			
			e.printStackTrace();
			
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}
	
	// 비밀번호 변경
	public int updatePass(String id, String cur_pass, String new_pass) {
			
		int check = 0;	// 0: 비밀번호 일치하지 않음, 1: 비밀번호 일치
		
		try {
				
			con = getConnection();
				
			// 비밀번호 맞는지 확인
			// MySQL 버전이 낮아져 PASSWORD() 방식으로 변경
			sql = "select id from member where pass=PASSWORD(?)";
			ps = con.prepareStatement(sql);
			ps.setString(1, cur_pass);
			rs = ps.executeQuery();
			
			while(rs.next()) {	// 이 비밀번호를 쓰는 아이디는 있음
				if(rs.getString("id").equals(id)) {	// 로그인한 아이디가 쓰는 비밀번호와 일치
					sql = "update member set pass = PASSWORD(?) where id = ?";
					ps = con.prepareStatement(sql);
					ps.setString(1, new_pass);
					ps.setString(2, id);
					
					ps.executeUpdate();
						
					check = 1;	
				}
			}
				
			}catch(Exception e) {
				System.out.println("MemberDAO->updatePass()에서 예외발생");
				e.printStackTrace();
			}
			
			return check;
		}
	
	// 회원정보 수정
	public void updateMember(MemberBean mb, HttpServletRequest request) {
		
		try {
			con = getConnection();
			
			if(mb.getProfile()==null) {	// 프로필 사진 변경을 안했으면

				// 회원정보 수정
				sql = "update member set name=?, nick=?, gender=?, tel=HEX(AES_ENCRYPT(?, 'tel')) where id=?";
				ps = con.prepareStatement(sql);
				ps.setString(1, mb.getName());
				ps.setString(2, mb.getNick());
				ps.setString(3, mb.getGender());
				ps.setString(4, mb.getTel());
				ps.setString(5, mb.getId());
				
				ps.executeUpdate();
				
			}else {	// 프로필 사진 변경을 했으면
				
				// 기존의 프로필 이미지는 삭제(물리적 위치에 있는 이미지 파일)
				sql = "select profile from member where id=?";
				ps = con.prepareStatement(sql);
				ps.setString(1, mb.getId());
				rs = ps.executeQuery();
				if(rs.next()) {
					String realPath = request.getRealPath("/upload/images/profileImg/");
					File f = new File(realPath+rs.getString("profile"));
					f.delete();
				}
				
				// 회원정보 수정
				sql = "update member set name=?, nick=?, gender=?, tel=HEX(AES_ENCRYPT(?, 'tel')), profile=? where id=?";
				ps = con.prepareStatement(sql);
				ps.setString(1, mb.getName());
				ps.setString(2, mb.getNick());
				ps.setString(3, mb.getGender());
				ps.setString(4, mb.getTel());
				ps.setString(5, mb.getProfile());
				ps.setString(6, mb.getId());
				
				ps.executeUpdate();
			}
			
		}catch(Exception e){
			System.out.println("MemberDAO->updateMember에서 예외발생");
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
	}
	
	// 회원 탈퇴
	public int deleteMember(String id, String pass) {
		
		int check = 0;	// 0: 비밀번호 틀림, 1: 탈퇴 완료
		
		try {
			
			con = getConnection();
			
			sql = "select id from member where pass=PASSWORD(?)";
			ps = con.prepareStatement(sql);
			ps.setString(1, pass);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				if(rs.getString("id").equals(id)) {	// 비밀번호의 아이디들 중 로그인한 아이디와 같은 아이디가 있는지 확인
					check = 1;
					
					sql="delete from member where id=?";
					ps = con.prepareStatement(sql);
					ps.setString(1, id);
					
					ps.executeUpdate();
					
				}else {
					check = 0;
				}
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return check;
	}
	
	// 회원 탈퇴(관리자가 회원관리 페이지에서 삭제시키기 때문에 id만 필요)
		public void deleteMember(String id) {

			try {
				
				con = getConnection();
				
				sql = "delete from member where id=?";
				ps = con.prepareStatement(sql);
				ps.setString(1, id);
				
				// 일단 삭제안되게 막아둠
				ps.executeUpdate();
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				try{
					if(rs!=null) rs.close();
					if(ps!=null) ps.close();
					if(con!=null) con.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
	
	// 가입된 회원수 구하기
	public int getCountMember() {
		
		int count = 0;
		try {
			
			con = getConnection();
			
			sql = "select count(id) as count from member";
			ps = con.prepareStatement(sql);
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt("count");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return count;
	}
	
	// 가입된 회원수 구하기(검색값)
		public int getCountMember(String search, String search_sel) {
			
			int count = 0;
			try {
				
				con = getConnection();
				
				if("id_search".equals(search_sel)) {	// 아이디로 검색
					sql = "select count(id) as count from member where id like ?"; 
				}else {	// 닉네임으로 검색
					sql = "select count(id) as count from member where nick like ?"; 
				}
				
				ps = con.prepareStatement(sql);
				ps.setString(1, "%"+search+"%");
				
				rs = ps.executeQuery();
				
				if(rs.next()) {
					count = rs.getInt("count");
				}
				
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				try{
					if(rs!=null) rs.close();
					if(ps!=null) ps.close();
					if(con!=null) con.close();
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
			return count;
		}
	
	// 회원 리스트 가져오기
	public List<MemberBean> getMemberList(int startRow, int pageSize, String search, String search_sel) {
		
		List<MemberBean> memberList = new ArrayList<MemberBean>();
		MemberBean mb = null;
		
		try {
			
			con = getConnection();
			
			if("id_search".equals(search_sel)) {	// 아이디로 검색
				sql = "select id, pass, name, nick, gender, tel, reg_date, profile, auth from member "
						+ "where id like ? limit ?, ?";
			}else {	// 닉네임으로 검색
				sql = "select id, pass, name, nick, gender, tel, reg_date, profile, auth from member "
						+ "where nick like ? limit ?, ?";
			}
			
			ps = con.prepareStatement(sql);
			ps.setString(1, "%"+search+"%");
			ps.setInt(2, startRow-1);
			ps.setInt(3, pageSize);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				mb = new MemberBean();
				
				mb.setId(rs.getString("id"));
				mb.setPass(rs.getString("pass"));
				mb.setName(rs.getString("name"));
				mb.setNick(rs.getString("nick"));
				mb.setGender(rs.getString("gender"));
				mb.setTel(rs.getString("tel"));
				mb.setReg_date(rs.getTimestamp("reg_date"));
				mb.setProfile(rs.getString("profile"));
				mb.setAuth(rs.getInt("auth"));
				
				memberList.add(mb);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return memberList;
	}
	
	// 권한 변경
	public void authUpdate(String id, String auth) {
		
		try {
			
			con = getConnection();
			
			sql = "update member set auth=? where id=?";
			ps = con.prepareStatement(sql);
			if(auth.equals("admin")) {	// 관리자
				ps.setInt(1, 0);
			}else if(auth.equals("user")) {	// 사용자
				ps.setInt(1, 1);
			}
			ps.setString(2, id);
			ps.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				if(con!=null) con.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}

} // class








