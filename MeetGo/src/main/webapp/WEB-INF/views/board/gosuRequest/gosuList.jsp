<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style>
        @font-face {
            font-family: 'Pretendard-Regular';
            src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
            font-weight: 400;
            font-style: normal;
        }
        img {
            object-fit: cover !important;
        }
        .wrap {
            font-family: 'Pretendard-Regular';

        }


        .wrap {
            margin: auto;
            height: 1000px;
            width: 1000px;
            box-sizing: border-box;
        }

        .gosu_header {
            height: 100px;
            width: 1000px;
            box-sizing: border-box;
            text-align: center;
        }

        .gosu_body_1 {
            height: 40px;
            box-sizing: border-box;
            width: 1000px;
            display: flex;

        }

        .gosu_body_1_1 {

            height: 40px;
            box-sizing: border-box;
            width: 10%;
            float: left;
        }

        .gosu_body_1_2 {

            height: 40px;
            box-sizing: border-box;
            width: 70%;
            float: center;
            text-align: center;
        }

        .gosu_body_1_3 {
            height: 40px;
            box-sizing: border-box;
            width: 20%;
            text-align: right;
        }

        .gosu_main {
            width: 1000px;
            box-sizing: border-box;
        }

        table, th, td {

            border-collapse: collapse;
            width: 1000px;
        }

        .gosu_notice {
            box-sizing: border-box;

            width: 70%;
        }

        .gosu_first {
            background-color: #e8f6ff;

        }

        .gosu_content {
            box-sizing: border-box;

            width: 1000px;
            height: 630px;
        }

        .bno {
            width: 80px;
            height: 10px;
            box-sizing: border-box;

        }

        .gosu_content_2 {
            width: 850px;
            box-sizing: border-box;

        }

        .gosu_content_3 {
            width: 100px;
            box-sizing: border-box;

        }

        .gosu_content_4 {
            width: 130px;
            box-sizing: border-box;

        }

        .gosu_footer {
            float: center;
            width: 1000px;
            height: 30px;
            box-sizing: border-box;

        }

        .list-bar {
            text-align: center;
            margin-top: 20px; /* You can adjust the margin-top value as needed */
        }

        .pagination {
            display: inline-block;
            margin: 0;
            padding: 0;
        }

        .pagination li {
            display: inline;
            margin-right: 5px; /* Adjust the spacing between pagination items as needed */
        }

        .pagination a {
            text-decoration: none;
            color: #007bff; /* You can set the color to your preference */
            padding: 8px 12px;
            border: 1px solid #007bff; /* You can set the border color to your preference */
            border-radius: 5px;
        }

        .pagination a:hover {
            background-color: #007bff; /* You can set the hover background color to your preference */
            color: #fff; /* You can set the hover text color to your preference */
        }

        .gosu_content_2:hover {
            text-decoration: underline;
            cursor: pointer;


        }

        .pagingBtn {
            border: 0;
            border-radius: 5px;
            width: 30px;
            height: 40px;
            font-size: 20px;
            color: white;
            background-color: #2a91f7c0;
            margin: 0px 3px;
        }

        .pageBtn {
            border: 0;
            border-radius: 5px;
            width: 30px;
            height: 40px;
            font-size: 20px;
            color: white;
            background-color: #2a91f7c0;
            margin: 0px 3px;
        }
		.boardList {
			text-align: center;
		}
		.boardList tbody>tr:hover {
			background-color: lightgray;
		}
	</style>
</head>
<body>
<jsp:include page="../../common/header.jsp"/>

<jsp:include page="../../common/side.jsp"/>

<div class="wrap">
	
	<br><br>
	
	<div class="gosu_header">
		
		<br>
		<h2>고수찾아요</h2>
		<hr>
	</div>
	
	<a href="gosuWrite.bo" style="float:right;">
		<c:choose>
			<c:when test="${  not empty sessionScope.loginUser }">
				<button type="submit" class="btn btn-primary">글작성</button>
			</c:when>
		</c:choose>
	</a>
	
	<br><br>
	
	<div class="gosu_main">
		
		<!-- 공지사항 -->
		<table class="boardList">
			<thead>
			<tr>
				<td><b>No</b></td>
				<td><b>제목</b></td>
				<td><b>작성일</b></td>
				<td><b>조회수</b></td>
			</tr>
			</thead>
			<tbody>
			<tr style="background-color: #d6eaff">
				<td><i class="bi bi-megaphone-fill"></i></td>
				<td><b>게시판 이용안내 및 주의사항</b></td>
				<td><b>2023-11-28</b></td>
				<td><b>50</b></td>
			</tr>
			<tr style="background-color: #d6eaff">
				<td><i class="bi bi-megaphone-fill"></i></td>
				<td><b>게시판 이용정지 안내</b></td>
				<td><b>2023-11-29</b></td>
				<td><b>58</b></td>
			</tr>
				<c:forEach var="m" items="${ requestScope.list }">
				
				<tr onclick="sendGosuReqDetail( ${m.boardNo} )">
					<td class="bno"> ${m.boardNo}</td>
					<td class="gosu_content_2" style="">${m.boardTitle} </td>
					<td class="gosu_content_4" style="text-align: center;"> ${m.createDate}</td>
					<td class="gosu_content_2" style="width:40px;">${m.boardCount} </td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	
	
	</div>
	
	<div class="gosu_footer">
	
	</div>
	<div id="pagingArea" align="center">
		
		<c:choose>
			<c:when test="${ requestScope.pi.currentPage eq 1 }">
				<button class="pagingBtn" onclick="location.href='#'">&lt;</button>
			</c:when>
			<c:otherwise>
				<button class="pagingBtn" onclick="location.href='gosuList.bo?cpage=${ requestScope.pi.currentPage - 1 }'">&lt;</button>
			</c:otherwise>
		</c:choose>
		
		<c:forEach var="p" begin="${ requestScope.pi.startPage }"
				   end="${ requestScope.pi.endPage }"
				   step="1">
			<button class="pageBtn" onclick="location.href='gosuList.bo?cpage=${ p }'">${ p }</button>
		</c:forEach>
		
		<c:choose>
			<c:when test="${ requestScope.pi.currentPage eq requestScope.pi.maxPage }">
				<button class="pagingBtn" href="#">&gt;</button>
			</c:when>
			<c:otherwise>
				<button class="pagingBtn" onclick="location.href='gosuList.bo?cpage=${ requestScope.pi.currentPage + 1 }'">&gt;</button>
			</c:otherwise>
		</c:choose>
	
	</div>
</div>

<jsp:include page="../../common/footer.jsp"/>


<script>
    function sendGosuReqDetail(bno) {
        location.href = "gosuDetail.bo?bno=" + bno;

    };


</script>

</body>
</html>