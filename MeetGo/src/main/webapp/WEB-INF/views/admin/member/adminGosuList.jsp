<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>고수 관리 페이지</title>
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
		cursor: pointer;
    }
</style>
<body>
<jsp:include page="../common/adminHeader.jsp"/>
<script>
	$(function (){
        selectAllGosu(1);
        $(document).on("click", "#memberList>tbody>tr td:not(:last-child)", function (){
            let gno = $(this).siblings(".adminGosuNo").text();
            window.open("gosuDetail.go?gno=" + gno ,"_blank");
		})
	})
	function selectAllGosu(cPage){
        $('.chatTable>tbody').empty();
        $('#button-area').empty();
        $.ajax({
			url : "selectAllGosu.ad",
            dataType: "json",
            data: {
                cPage: cPage
            },
            success: function (data) {
				console.log(data);
                let gosuList = data.gosuList;
                let pi = data.pi;
                for (let i = 0; i < gosuList.length; i++) {
                    let gosu = gosuList[i];
                    let content = '';
                    content +=
						'<tr>' +
							'<td width="5%" class=adminGosuNo>'+gosu.gosuNo+'</td>' +
							'<td width="20%">'+gosu.introduction+'</td>' +
							'<td width="5%">'+gosu.employees+'명</td>' +
							'<td width="5%">'+gosu.businessStatus+'</td>' +
							'<td width="5%">'+gosu.education+'</td>' +
							'<td width="5%">'+gosu.career+'</td>' +
							'<td width="10%">'+gosu.region+'</td>' +
							'<td width="5%"><button class="meetgo-btn meetgo-red w-80" onclick="changeMemberStatus(' + gosu.userNo + ', \'탈퇴\')">회원정지</button></td></td>' +
                        '</tr>';
                    $('.chatTable>tbody').append(content);
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
                selectAllGosu(${requestScope.cPage});
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
		<img style="width: 40px; height: 40px" src="data:image/png;base64,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">
		고수 회원 관리
	</p>
	<br>
</div>
<div style="position: absolute; top: 120px; right: 40px;" >
	클릭시 고수 상세보기로 이동합니다.<br>
	해당 페이지는 현재 활성화 되어 있는 고수만 조회가 가능합니다.
</div>
<div align="center" style="height:600px;"id="list-area" class="table table-borderless table-hover">
	<table class="chatTable" id="chatList">
		<thead>
			<tr>
				<td width="5%">고수 번호</td>
				<td width="20%">소개</td>
				<td width="5%">직원수</td>
				<td width="5%">사업자 여부</td>
				<td width="5%">학력</td>
				<td width="5%">경력</td>
				<td width="10%">지역</td>
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
