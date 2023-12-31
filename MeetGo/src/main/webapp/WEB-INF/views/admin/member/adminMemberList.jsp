<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>일반 사용자 관리 페이지</title>
</head>
<style>
    #list-area {
        width: 1800px;
		height: 700px;
        align-items: center;
        text-align: center;
        margin: auto;
        margin-bottom: 20px;
    }
    .chatTable {
        width: 2000px;
        margin: auto;
        text-align: center;
        box-sizing: border-box;
        font-size: 15px;
    }

    .chatTable > thead {
        height: 50px;
        background-color: #2A8FF7;
        color: white;
    }

    .chatTable > thead > tr > td {
    }

    .chatTable > tbody > tr {
        height: 50px;
        color: #020715;
    }

    .chatTable > tbody > tr > td {
		padding: 5px;
		box-sizing: border-box;
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

    #chatList {
        width: 100%;
        text-align: center;
    }

    #chatList > thead {
        background-color: #2a91f7c0;
        color: white;
    }

    #chatList > tbody:hover {
    }

    #chatList > tbody > tr:hover {
        color: black !important;
    }
</style>

<body>
<jsp:include page="../common/adminHeader.jsp"/>
<script>
    function selectAllMember(cPage) {
        $('.chatTable>tbody').empty();
        $('#button-area').empty();
        $.ajax({
            url: "selectAllMember.ad",
            dataType: "json",
            data: {
                cPage: cPage
            },
            success: function (data) {
                let memberList = data.memberList;
                let pi = data.pi;
                for (let i = 0; i < memberList.length; i++) {
                    let member = memberList[i];
                    let selectMember =
                        '<tr>' +
                        '<td width="3%">' + member.userNo + '</td>' +
                        '<td width="5%">' + member.userId + '</td>' +
                        '<td width="8%">' + member.userEmail + '</td>' +
                        '<td width="4%">' + member.userName + '</td>' +
                        '<td width="5%">' + member.userNickname + '</td>' +
                        '<td width="10%">' + member.userPhone + '</td>' +
                        '<td width="8%">' + member.createDate + '</td>' +
                        '<td width="8%">' + member.lastAccessDate + '</td>' +
                        '<td width="8%" id="memberEnrollStatus' + member.userNo + '">';
                    if (member.enrollStatus == 1) {
                        selectMember +=
                            '일반 회원</td>' +
                            '<td id="memberStatus' + member.userNo + '"><button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + member.userNo + ', \'탈퇴\')">회원정지</button></td>' +
                            '</tr>';
                    } else if (member.enrollStatus == 2) {
                        selectMember +=
                            '일반 + 고수 회원</td>' +
                            '<td id="memberStatus' + member.userNo + '"><button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + member.userNo + ', \'탈퇴\')">회원정지</button></td>' +
                            '</tr>';
                    } else if (member.enrollStatus == 3) {
                        selectMember +=
                            '일반 회원(고수 비활성화)</td>' +
                            '<td id="memberStatus' + member.userNo + '"><button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + member.userNo + ', \'탈퇴\')">회원정지</button></td>' +
                            '</tr>';
                    } else {
                        selectMember +=
                            '회원 탈퇴</td>' +
                            '<td id="memberStatus' + member.userNo + '"><button class="meetgo-btn w-80" onclick="changeMemberStatus(' + member.userNo + ', \'해제\')">정지 해제</button></td>' +
                            '</tr>';
                    }
                    $('.chatTable>tbody').append(selectMember);

                }
                let paging = '';
                if (pi.currentPage == 1) {
                    paging += '<button class="pagingBtn" disabled style="background-color: ">&lt;</button>'
                } else {
                    paging += '<button class="pagingBtn" onclick="selectAllMember(' + (pi.currentPage - 1) + ')">&lt;</button>'
                }
                for (let i = pi.startPage; i <= pi.endPage; i++) {
                    if(pi.currentPage == i){
                    	paging += '<button class="pageBtn" style="background-color:rgb(32, 93, 154);" onclick="selectAllMember(' + i + ')">' + i + '</button>'
                    } else {
                    	paging += '<button class="pageBtn" onclick="selectAllMember(' + i + ')">' + i + '</button>'
                    }
                }
                if (pi.currentPage == pi.endPage) {
                    paging += '<button class="pagingBtn" disabled style="background-color: ">&gt;</button>'
                } else {
                    paging += '<button class="pagingBtn" onclick="selectAllMember(' + (pi.currentPage + 1) + ')">&gt;</button>'
                }
                $('#button-area').append(paging);
            },
            error: function () {
                console.log("실패");
            }
        })
    }

    selectAllMember(1);

    function changeMemberStatus(userNo, status) {
        $.ajax({
            url: "adminMemberChangeStatus.ad",
            dataType: "json",
            method: "POST",
            data: {
                userNo: userNo,
                status: status
            },
            success: function (data) {
                console.log(data);
                $('#memberStatus' + data.userNo).empty();
                $('#memberEnrollStatus' + data.userNo).empty();
                let content = '';
                let content1 = '';
                if (data.enrollStatus == 1) {
                    content1 += '일반 회원'
                    content += '<button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + data.userNo + ', \'탈퇴\')">회원정지</button>';
                } else if (data.enrollStatus == 2) {
                    content1 += '일반 회원(고수 비활성화)'
                    content += '<button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + data.userNo + ', \'탈퇴\')">회원정지</button>';
                } else if (data.enrollStatus == 3) {
                    content1 += '일반 회원(고수 비활성화)'
                    content += '<button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + data.userNo + ', \'탈퇴\')">회원정지</button>';
                } else {
                    content1 += '회원 탈퇴'
                    content += '<button class="meetgo-btn w-80" onclick="changeMemberStatus(' + data.userNo + ', \'해제\')">정지 해제</button>';
                }
                $('#memberEnrollStatus' + data.userNo).append(content1);
                $('#memberStatus' + data.userNo).append(content);
            },
            error: function () {
                console.log("상태 실패")
            }
        })
    }
</script>
<div class="pageTitleArea" align="center">
	<br>
	<p class="pageTitle">
		<img style="width: 40px; height: 40px"
			 src="data:image/png;base64,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">
		일반 사용자 관리
	</p>
	<br>
</div>
<div align="center" style="height: 600px;" id="list-area" class="table table-borderless table-hover">
	<table class="chatTable" id="chatList">
		<thead>
		<tr>
			<td width="5%">회원 번호</td>
			<td width="5%">아이디</td>
			<td width="10%">이메일</td>
			<td width="5%">이름</td>
			<td width="5%">닉네임</td>
			<td width="10%">전화번호</td>
			<td width="5%">가입일</td>
			<td width="5%">최근 접속일</td>
			<td width="5%">회원 상태</td>
			<td width="5%">정지/정지해제</td>
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
