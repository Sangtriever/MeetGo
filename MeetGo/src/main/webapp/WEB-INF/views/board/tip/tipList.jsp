<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style>
		a{
			text-decoration: none!important;
		}
        @font-face {
            font-family: 'Pretendard-Regular';
            src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
            font-weight: 400;
            font-style: normal;
        }


        @import url("https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css");

        .wrap {
            font-family: 'Pretendard-Regular';
            width: 1000px;
            margin: auto;
        }

        #tipListTable td {
            height: 100px;
            padding-left: 40px;
            padding-right: 40px;
        }
        .tipList tbody > tr:hover{
			background-color: lightgray;
		}
        #tipListTable th {
            height: 100px;
            padding-left: 40px;
            padding-right: 40px;
        }

        .content_1 {
            width: 1000px;
            float: right;
            box-sizing: border-box;
        }

        .content_title {
            width: 1000px;
            box-sizing: border-box;

        }

        .content_1_1 {
            box-sizing: border-box;
            width: 1000px;
        }

        .content_1_2 {
            box-sizing: border-box;
            width: 1000px;

        }

        .content_1_3 {
            box-sizing: border-box;
            width: 1000px;

        }

        .content_1_title {
            border: 1px solid hotpink;
            box-sizing: border-box;
            width: 1000px;
        }

        .content_main3_2 {
            width: 30%;
            box-sizing: border-box;
            text-align: center;
            float: right;
        }

        .content_main4_1 {
            width: 70%;
            box-sizing: border-box;
            float: left;

        }

        .content_main4_2 {
            width: 30%;
            box-sizing: border-box;
            text-align: center;
            float: right;
        }

        .content_1_3_1 {
            width: 70%;
            box-sizing: border-box;
            float: left;
        }

        .content_1_3_2 {
            width: 30%;
            box-sizing: border-box;
            text-align: center;
            float: right;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .tipmain {
            width: 1000px;
        }

        .content {
            width: 1000px;
        }

        .tip_content {
            cursor: pointer;
        }

        .tip_content:hover {
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
	
	</style>
</head>
<body>
<jsp:include page="../../common/header.jsp"/>
<jsp:include page="../../common/side.jsp"/>

<div class="wrap">
	
	<div class="content_1">
		<br><br><br>
		<div class="content_title" style="text-align: center; font-size: 28px;">
			<p>팁과 노하우</p>
			<hr>
		</div>
		<a href="tipWrite.bo">
			<c:choose>
				<c:when test="${  not empty sessionScope.loginUser }">
					<button type="submit" class="btn btn-primary" style="float: right;" align="right">글작성</button>
				</c:when>
			</c:choose>
		</a>
		<div class="tipmain" align="center">
			
			<br>
			
			<table class="tipList" style="width: 1000px; text-align:center;">
				<thead>
					<tr>
						<th style="width: 15%">글번호</th>
						<th style="width: 25%">사진</th>
						<th style="width: 20%">제목</th>
						<th style="width: 20%">작성자</th>
						<th style="width: 15%">작성일</th>
						<th style="width: 10%">조회수</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="m" items="${requestScope.dtoList}">
					<tr id="concon" onclick="location.href='tipDetail.bo?bno=' + ${m.boardNo}">
						<td class="bno" >
							<p style="font-size:20px;"> ${m.boardNo}</p>
						</td>
						<td>
							<img src="${m.bfilePath}" style="width:150px; height:150px;">
						</td>
						<td class="tip_content">
							<p style="font-size:20px;">
									${m.boardTitle}
							</p>
						</td>
						<td style="font-size:20px; ">
							${m.userNickname}
						</td>
						<td style="font-size:20px; ">
								${m.boardCreateDate}
						</td>
						<td style="font-size:20px; ">
								${m.boardCount}
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
		
		<div class="footer">
			
			
			<br><br><br>
			
			<div id="pagingArea" align="center">
				<c:choose>
					<c:when test="${ requestScope.pi.currentPage eq 1 }">
						<button class="pagingBtn" onclick="location.href='#'">&lt;</button>
					</c:when>
					<c:otherwise>
						<button class="pagingBtn" onclick="location.href='tipList.bo?cpage=${requestScope.pi.currentPage - 1}'">&lt;</button>
					</c:otherwise>
				</c:choose>
				<c:forEach var="p" begin="${ requestScope.pi.startPage }"
						   end="${ requestScope.pi.endPage }"
						   step="1">
					<c:choose>
						<c:when test="${ requestScope.pi.currentPage eq p }">
							<button class="pageBtn" style="color: black" disabled onclick="location.href='tipList.bo?cpage=${p}'">${ p }</button>
						</c:when>
						<c:otherwise>
							<button class="pageBtn" onclick="location.href='tipList.bo?cpage=${p}'">${ p }</button>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<c:choose>
					<c:when test="${ requestScope.pi.currentPage eq requestScope.pi.maxPage }">
						<button class="pagingBtn" href="#">&gt;</button>
					</c:when>
					<c:otherwise>
						<button class="pagingBtn" onclick="location.href='tipList.bo?cpage=${requestScope.pi.currentPage + 1}'">&gt;</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</div>

<script>
    $("#concon").click(function () {
        let bno = $(this).children(".bno").text();
        location.href = "tipDetail.bo?bno=" + bno;
    });

</script>

</body>
</html>