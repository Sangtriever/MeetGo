<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>Title</title>
	<style>
        #list-area {
            width: 1400px;
            min-height: 700px;
            align-items: center;
            text-align: center;
            margin: auto;
            margin-bottom: 20px;
        }
        .pageTitleArea{
            margin-top: 20px;
        }
        .pageTitleArea hr {
            width: 1000px;
            border: 1px solid black;
        }
        .pageTitle{
            font-size: 30px;
        }
        .pagingBtn{
        border: 0;
        border-radius: 5px;
        width: 30px;
        height: 40px;
        font-size: 20px;
        color: white;
        background-color: #2a91f7c0;
        margin : 0px 3px;
    }
    .pageBtn{
        border: 0;
        border-radius: 5px;
        width: 30px;
        height: 40px;
        font-size: 20px;
        color: white;
        background-color: #2a91f7c0;
        margin : 0px 3px;
    }
	</style>
</head>
<body>
<jsp:include page="../../common/adminHeader.jsp"/>
<script>
	selectBoard(3, 1);
    function deleteBoard(boardNo, cPage){
        console.log("ㅇㅅㅇ");
        $.ajax({
            url :"deleteBoard.ad",
            method: "get",
            data : {
                boardNo : boardNo
            },
            success : function (){
                selectBoard(3 , cPage)
            },
            error : function (){
                console.log("삭제 실패");
            }
        })
    }
    function redirectToNoticeDetail(boardNo){
        location.href ="noticeDetail.bo?bno="+boardNo;
	}
	function selectBoard(status , cPage){
		$('#chatList > tbody').empty();
		$('#button-area').empty();
		$.ajax({
			url : "selectBoardList",
			method : "get",
			data : {
				status : status,
				cPage : cPage
			},
			success : function (data){
				let list = data.list;
				let pi = data.pi;
				
				for (let i = 0; i < list.length; i++) {
                    console.log(list[i]);
					let content =
                        '<tr onclick="redirectToNoticeDetail(' + list[i].boardNo + ')">' +
							'<td width="10%" onclick="redirectToNoticeDetail(' + list[i].boardNo + ')">' + list[i].boardNo + '</td>' +
							'<td width="20%" onclick="redirectToNoticeDetail(' + list[i].boardNo + ')">' + list[i].boardTitle + '</td>' +
							'<td width="15%" onclick="redirectToNoticeDetail(' + list[i].boardNo + ')">' + list[i].createDate.substring(0, 16) + '</td>' +
							'<td width="10%" onclick="redirectToNoticeDetail(' + list[i].boardNo + ')">' + list[i].boardCount + '</td>' +
							'<td width="10%">';
                        	if(list[i].boardStatus == 1){
                        		content += '<button class="meetgo-red" onclick="deleteBoard(' + list[i].boardNo + ', ' + pi.currentPage + ')">게시글 삭제</button>';
                        	} else {
                        		content += '<p style="color: red" disabled>삭제된 게시글</p>';
                        	}
                        content += '</td>' +
                        '</tr>';
					$('#chatList > tbody').append(content);
				}
				let paging = '';
				if (pi.currentPage == 1) {
					paging += '<button class="pagingBtn" disabled style="background-color: ">&lt;</button>'
				} else {
					paging += '<button class="pagingBtn" onclick="selectBoard(3, ' + (pi.currentPage - 1) + ')">&lt;</button>'
				}
				for (let i = pi.startPage; i <= pi.endPage; i++) {
					if(pi.currentPage == i){
						paging += '<button class="pageBtn" style="background-color:rgb(32, 93, 154);" onclick="selectBoard(3, ' + i + ')">' + i + '</button>'
					} else {
						paging += '<button class="pageBtn" onclick="selectBoard(3, ' + i + ')">' + i + '</button>'
					}
				}
				if (pi.currentPage == pi.endPage) {
					paging += '<button class="pagingBtn" disabled style="background-color: ">&gt;</button>'
				} else {
					paging += '<button class="pagingBtn" onclick="selectBoard(3, ' + (pi.currentPage + 1) + ')">&gt;</button>'
				}
				$('#button-area').append(paging);

			},
			error : function (){
				console.log("공지사항 리스트 조회 실패");
			}
		})
	}
</script>
<div class="pageTitleArea" align="center">
	<br>
	<p class="pageTitle">
		<img style="width: 40px; height: 40px" src="<%=request.getContextPath()%>/resources/images/chat/notice-icon.png">
		공지사항 관리
	</p>
	<br>
	<hr>
</div>
<div style="height:600px;" align="center" id="list-area" class="table table-borderless table-hover">
	<table class="chatTable" id="chatList">
		<thead>
			<tr style="background-color: #2A8FF7; color: white">
				<td width="10%">게시글 번호</td>
				<td width="20%">제목</td>
				<td width="15%">게시글 생성일</td>
				<td width="10%">게시글 조회수</td>
				<td width="15%">게시글 상태</td>
			</tr>
		</thead>
		<tbody>
		
		</tbody>
	</table>
</div>
<div align="center" id="button-area">
</div>
</body>
</html>
