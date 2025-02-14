<%@page import="common.UtilMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="userPack.UserVO" %>
<jsp:useBean id="uDAO" class="userPack.UserDAO"/>
<jsp:useBean id="bDAO" class="boardPack.BoardDAO" />
<%@page import="boardPack.BoardVO" %>
<%
	String nowPage = request.getParameter("nowPage");
	String keyField = request.getParameter("keyField");
	String keySub = request.getParameter("keySub");
	String keyWord = request.getParameter("keyWord");
	String boardName = request.getParameter("boardName");
	String seq_str = request.getParameter("seq");
	String ref_str = request.getParameter("ref");
	BoardVO bVO = new BoardVO();
	String title = "";
	String subject = "";
	String content = "";
	int seq = 0;
	int ref = 0;
	if(seq_str!=null){
		seq = Integer.parseInt(seq_str);
		bVO = bDAO.getBoard(boardName, seq);
		title = bVO.getTitle();
		subject = bVO.getSubject();
		content = bVO.getContent();
	}
	if(ref_str!=null){
		ref = Integer.parseInt(ref_str);
		bVO = bDAO.getBoard(boardName, ref);
		subject = bVO.getSubject();
	}
	int postNum = 0;
	if(seq!=0 && ref==0){
		postNum = seq;
	}else if(seq==0 && ref!=0){
		postNum = ref;
	}
	
	
	String user = (String)session.getAttribute("user");
	UserVO uVO = new UserVO();
	String userName = "";
	String userAuthority = "";
	/* String url = "post.jsp?boardName="+boardName; */
	if(user!=null){
		uVO = uDAO.getUser(user);
		userName = uVO.getName();
		userAuthority = uVO.getAuthority();
	}else{
		/* session.setAttribute("referUrl", url);
		System.out.println(url); */
		response.sendRedirect("signIn.jsp");
	}
	
%>
<!DOCTYPE html>
<html lang="KO">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./css/index-sub.css">
    <link rel="stylesheet" href="./css/community_list.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <title>Small Planet</title>
    <!-- 구글폰트 import -->
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Gugi&family=Pacifico&family=Roboto:ital,wght@1,300&family=Supermercado+One&display=swap');
    </style>
    <!-- 부트스트랩 jsDelivr CSS only -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <!-- 부트스트랩 jsDeliver JavaScript Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
        crossorigin="anonymous"></script>
    <!-- icon 이미지 -->
    <script src="https://kit.fontawesome.com/cd6c1c6007.js" crossorigin="anonymous"></script>
    <!-- bxSlider -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>   
    <!-- summernote -->
    <link rel="stylesheet" href="./summernote/summernote-lite.css">

    <script src="./summernote/summernote-lite.js"></script>
    <script src="./summernote/lang/summernote-ko-KR.js"></script>
    
</head>

<body>
    <header style="z-index: 1;">
        <!-- Logo -->
        <nav class="navbar">
            <div class="navbar_logo">
                <a style="color: #5180d8; border-bottom: 2px solid transparent;" href="index.jsp" class="navbar_logotext" >SMALLPLANET</a>
            </div>

            <!-- nav 메뉴 -->
            <div class="menu">
                <ul class="navbar_menu">
                    <li><a class="menuNum" href="introduce.jsp">소 개</a></li>
                    <li><a class="menuNum" href="community.jsp" style="border-bottom: 2px solid #5180d8; padding-bottom: 42px;" >커뮤니티</a></li>
                    <li><a class="menuNum" href="dataBoard.jsp">자 료 실</a></li>
                    <li><a class="menuNum" href="qnaBoard.jsp">Q & A</a></li>
                    <li><a class="menuNum" href="inquiry.jsp">문의하기</a></li>
                </ul>
            </div>
          
            <div class="loginJoin">
            <%if(user!=null){%>
             <!-- // 로그인 했을때 프로필 모양-->
					<a href="memberInfo.jsp">
                    <img src="./images/profiledefault.png" alt="" class="profile-picture">                
                    <div style="position: relative; top: -30px; right: -10px;">
                    <%=userName %>
                </a>       
                <a href="logout.jsp" style="margin-left: 10px;">로그아웃</a>
                <%if(userAuthority.equals("admin")){ %>
                <div class='btn_container'>
                    <a href="admin-list.jsp" class='pulse-button'>ADMIN</a>
                </div>
                <%} %>
			<%}else{ %>
            	<a href="signIn.jsp">LOGIN / JOIN</a>
			<%} %>
			</div>


            <!-- 해상도 낮아지면 생기는 버튼 -->
            <a href="#" class="navbar_toggleBtn">
                <i class="fa-solid fa-bars"></i>
            </a>
        </nav>
        <hr class="header_line">
    </header>
    <!-- 본문 -->
    <main>
        <h1>글작성</h1>

        <!-- form 안에 에디터를 사용하는 경우(보통 이 경우를 많이 사용하는듯) -->
        <%if(seq==0 && ref==0){ %>
        <form name="insert" method="post" action="insertBoard" enctype="multipart/form-data" class="summer_editor" style="width: auto;">
        <%}else if(ref!=0){ %>
        <form name="insert" method="post" action="replyBoard" enctype="multipart/form-data" class="summer_editor" style="width: auto;">
        <%}else{ %>
        <form name="insert" method="post" action="updateBoard" enctype="multipart/form-data" class="summer_editor" style="width: auto;">
		<%} %>
            <select name="board" id="list-select" required>
            	<%if(boardName.equals("qnaBoard")){ %>
                <option value="qnaBoard" 
                	<%=UtilMgr.boardSelected(boardName, "qnaBoard") %> 
                	style="<%=UtilMgr.boardDisable(boardName, "qnaBoard",postNum)%>" 
                	>Q&A</option>
                <%} %>
                <%if(boardName.equals("community")){ %>
                <option value="community" 
                	<%=UtilMgr.boardSelected(boardName, "community") %> 
                	style="<%=UtilMgr.boardDisable(boardName, "community",postNum)%>" 
                	>커뮤니티</option>
                <%} %>
               	<%if(userAuthority.equals("admin")){ %>
                <%if(boardName.equals("dataBoard")){ %>
                <option value="dataBoard" 
                	<%=UtilMgr.boardSelected(boardName, "dataBoard") %> 
                	style="<%=UtilMgr.boardDisable(boardName, "dataBoard",postNum)%>" 
                	>자료실</option>
                <%} %>
                <%} %>
            </select>    
            <select name="subject" id="list-select2" required>
           	<%if(userAuthority.equals("admin")){ %>
               <option value="공지사항" <%=UtilMgr.boardSelected(subject, "공지사항") %> 
               	style="<%=UtilMgr.boardDisable(subject, "공지사항",postNum)%>">공지사항</option>
               <%} %>
            <!-- 커뮤니티 말머리 -->
            <%if(boardName.equals("community")){ %>
                <option class="commuSub" value="일상" <%=UtilMgr.boardSelected(subject, "일상") %> 
                	style="<%=UtilMgr.boardDisable(subject, "일상",postNum)%>">일상</option>
                <option class="commuSub" value="도움" <%=UtilMgr.boardSelected(subject, "도움") %> 
                	style="<%=UtilMgr.boardDisable(subject, "도움",postNum)%>">도움</option>
            <%} %>
                	<!-- 자료실 말머리 -->
            <%if(boardName.equals("dataBoard")){ %>
                <option class="dataSub" value="자체제작" <%=UtilMgr.boardSelected(subject, "자체제작") %> 
                	style="<%=UtilMgr.boardDisable(subject, "자체제작",postNum)%>">자체제작</option>
                <option class="dataSub" value="기타" <%=UtilMgr.boardSelected(subject, "기타") %> 
                	style="<%=UtilMgr.boardDisable(subject, "기타",postNum)%>">기타</option>
            <%} %>
                <!-- qna 말머리 -->
            <%if(boardName.equals("qnaBoard")){ %>
                <option class="qnaSub" value="자료요청" <%=UtilMgr.boardSelected(subject, "자료요청") %> 
                	style="<%=UtilMgr.boardDisable(subject, "자료요청",postNum)%>">자료요청</option>
                <option class="qnaSub" value="건의사항" <%=UtilMgr.boardSelected(subject, "건의사항") %> 
                	style="<%=UtilMgr.boardDisable(subject, "건의사항",postNum)%>">건의사항</option>
            <%} %>
            </select>
            <input type="text" name="title" placeholder="제목을 입력하세요" value="<%=title %>" class="summer_editor_title" required>
            <input type="hidden" name="writer" value="<%=user %>">
            <textarea required name="content" id="summernote"><%=content %></textarea>
            <%if(seq==0){ %><!-- 처음 작성 -->
            <input type="file" name="fileName" size="50" maxlength="50" class="file-upload">
            	<%if(ref!=0){ %><!-- 답글 -->
	            <input type="hidden" name="ref" value="<%=ref %>">
	            <%} %>
            <%}else{ %><!-- 수정할 때 -->
            <input type="hidden" name="seq" value="<%=seq %>">
            <%} %>
            
            <input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="keySub" value="<%=keySub%>">
			<%if(!(keyWord==null || keyWord.equals(""))){ %>
			<input type="hidden" name="keyField" value="<%=keyField%>">
			<input type="hidden" name="keyWord" value="<%=keyWord%>">
			<%}%>
	        <input type="submit" value="submit" class="button submit-write">
        </form>

        
        
    </main>
    <footer class="foot-container">
        <div class="container">
            <br>
            <div class="row">
                <div class="col-sm-12 col-md-6">
                    <h6></h6>
                    <p style="color: #5b5b5b;" class="text-justify">안녕하세요 Small planet 입니다. <br>세상에 모든것들은 아주 작은 것에서 비롯되어
                        형태를 이루고<br> 자연과 조화를 이루어
                        상생합니다.
                        그렇게 저희 Small Planet 또한 <br>상생과 조화를 통한 협업으로 이끌어지는 팀입니다.</p>
                </div>

                <div class="col-xs-6 col-md-3">
                    <h6 style="color: #5b5b5b;">Categories</h6>
                    <ul class="footer-links">
                        <li><a href="./introduce.jsp">소개</a></li>
                        <li><a href="./community.jsp">커뮤니티</a></li>
                        <li><a href="./dataBoard.jsp">자료실</a></li>
                        <li><a href="./qnaBoard.jsp">Q & A</a></li>
                        <li><a href="./inquiry.jsp">문의하기</a></li>
                    </ul>
                </div>

                <div class="col-xs-6 col-md-3">
                    <h6 style="color: #5b5b5b;">Quick Links</h6>
                    <ul class="footer-links">
                        <li><a href="https://gratis-zinc-179.notion.site/0edca8071fd94328ac9b6614af09ee45" target= "_blank">Notion</a></li>
                        <li><a href="https://github.com/jdb1593/SmallPlanet.git" target= "_blank">GitHub</a></li>
                    </ul>
                </div>
            </div>
            <hr>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-8 col-sm-6 col-xs-12">
                    <p style="color: #5b5b5b;" class="copyright-text">Copyright &copy; 2022 All Rights Reserved by
                        <a href="https://github.com/jdb1593/SmallPlanet.git">Small Planet</a>.
                    </p>
                </div>

                <div class="col-md-4 col-sm-6 col-xs-12">
                    <ul class="social-icons">
                        <li><a class="facebook" href="https://ko-kr.facebook.com/"><i class="fa fa-facebook"></i></a></li>
                        <li><a class="twitter" href="https://twitter.com/?lang=ko"><i class="fa fa-twitter"></i></a></li>
                        <li><a class="dribbble" href="https://dribbble.com/"><i class="fa fa-dribbble"></i></a></li>
                        <li><a class="linkedin" href="https://kr.linkedin.com/"><i class="fa fa-linkedin"></i></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>
    <script src="./script/community_list.js"></script>
    
</body>
</html>