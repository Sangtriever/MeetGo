<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .table-hover{
        width: 1200px; 
        text-align: center;
        padding: auto;
        border-radius: 5px;
    }
    
    .truncate {
	    max-width: 150px;
	    white-space: nowrap;
	    overflow: hidden;
	    text-overflow: ellipsis;
	}
    
    .table-hover thead{
    	border-bottom: 1px solid #2a91f7c0;
    }
    
    .table-hover td{
    	height: 40px;
    }
    
    #pagingArea {width:fit-content; margin:auto;}
    
    @font-face {
        font-family: 'Pretendard-Regular';
        src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 400;
        font-style: normal;
    }
    * { font-family: 'Pretendard-Regular'; }
    
    #pagingBtn-area{margin-top: 80px;}
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
    .none{
    	background-color: none;
    }
    
</style> 
</head>
<body>
	
	<jsp:include page="../common/header.jsp" />
	<br>	
	
    <div style="width: 80%; margin: auto; min-height: 400px;">
        
            <br><br>
            	
            <br>
	            <table style="width: 70%; margin: auto; text-align:center;" id="type">
                <tr>
					<td class="type" style="width:20%; border-bottom: 3px solid #2A8FF7"><h4><b>진행중인 계약</b></h4></td>                
					<td class="type" style="width:20%;"><h4><b>완료된 계약</b></h4> </td>
					<c:choose>
						<c:when test="${ sessionScope.loginUser.userStatus eq 1 }">
							<td class="type" style="text-align: right; float:right; margin-top:15px;"><a href="myReview.me?cPage=1" style="color:#2a91f7c0;" class=""><h5>내 리뷰 보러가기</h5></a></td>                
						</c:when>
						<c:when test="${ sessionScope.loginUser.userStatus eq 2 }">
							<td class="type" style="text-align: right; float:right; margin-top:15px;"><a href="WrittenReview.me?cPage=1" style="color:#2a91f7c0;" class=""><h5>내게 작성된 리뷰 보러가기</h5></a></td>                
						</c:when>						
					</c:choose>
               </tr>
            </table>
			
            <br><br>
        	<div id="inCom" style="min-height: 500px;">
        		<h5 align="center" style="text-decoration: none;">√ 표시된 계약은 의뢰하신 계약입니다.</h5>
        		<br>
	            <table class="table-hover" align="center">
	                <thead style="height: 35px;">
	                    <tr >
	                    	<th style="width: 4%;"></th>
	                        <th style="width: 10%;">계약번호</th>
	                        <th style="width: 25%;">계약명</th>
	                        <th style="width: 10%;">고수번호</th>
	                        <th style="width: 10%;">고객번호</th>
	                        <th style="width: 20%;">시작일</th>
	                        <th style="width: 15%;">현재상태</th>
	                        <th style="width: 10%;"></th>
	                    </tr>
	                </thead>
	                <tbody id="listBody">
	                    
	                </tbody>
	            </table>
	            
	            <br><br><br><br>
        	</div>
            <div id="pagingArea">
           	
           	</div>
           
    </div>
    
    <script>
    	$(function(){
    		
    		inComEst(1);
    		
    		let $inCom = $("#type").find(".type").eq(0);
    		let $com = $("#type").find(".type").eq(1);
    		
    		$inCom.click(function(){
    			$(this).css("border-bottom", "3px solid #2A8FF7");
    			$com.css("border-bottom", "none");
    			
    			inComEst(1);
    		});
    		
    		$com.click(function(){
    			$(this).css("border-bottom", "3px solid #2A8FF7");
    			$inCom.css("border-bottom", "none");
    			
    			comEst(1);
    		});
    	});
    	
    	function inComEst(page){
    		
    		$('#listBody').empty();
    		$('#pagingArea').empty();
    		
    		$.ajax({
	    		url: "InComEstimate.me",
	    		dataType: "json",
	    		data: {
	    			cPage:page
	    		},
	    		success: function(data){
	    			let list = data.list2;
	    			if(list.length != 0){
	    				
		    			for(let i = 0; i < list.length; i++){
		    				let content = 
			    					'<tr>';
			    					
			    			if(${ sessionScope.loginUser.userNo } == list[i].gosuNo){
			    				content += "<td></td>";
			    			} else {
			    				content += "<td> √ </td>";	
			    			}
			    			
			    			content +=
			    			
		                    '<td class="eno">'+list[i].estNo+'</td>' +
		                    '<td class="truncate">'+list[i].estTitle+'</td>' +
		                    '<td>'+list[i].gosuNo+'</td>' +
		                    '<td>'+list[i].userNo+'</td>' +
		                    '<td>'+list[i].startDate+'</td>' +
		                    '<td>';
		    				if(list[i].status == 3){
	                    		content += '결제 대기';
	                    	} else {
	                    		content += '결제 완료';
	                    	}
		    				content += 
		    				'</td>' +
		    				'<td><a class="btn btn-primary btn-sm" href="chat.ct?type=all">채팅</a></td>' +
		    				'</tr>'
			    				
	    					$('#listBody').append(content);
		    			}
		    			
		    			let paging = '';
	    		    	
		    		    if(data.pi2.currentPage == 1){
		    		    	paging += '<button class="pagingBtn" disabled style="display:none;">&lt;</button>';
		    		    } else {
		    		    	paging += '<button class="pagingBtn" onclick="inComEst(' + (data.pi2.currentPage - 1) + ')">&lt;</button>';
		    		    }
		    		    
		    		    for(let i = data.pi2.startPage; i <= data.pi2.endPage; i++){
		    		    	
		    		    	if(data.pi2.currentPage == i){
		    		    		
								paging += '<button class="pageBtn" disabled style="background-color:rgb(32, 93, 154);" onclick="inComEst('+ i +')">' + i + '</button>'	    		    	
		    		    	} else{
		    		    		
								paging += '<button class="pageBtn" onclick="inComEst('+ i +')">' + i + '</button>'	    		    	
		    		    	}
		    		    	
		    		    }
		    		    
		    		    if(data.pi2.currentPage == data.pi2.endPage){
		    		    	paging += '<button class="pagingBtn" disabled style="display:none;">&gt;</button>';
		    		    } else {
		    		    	paging += '<button class="pagingBtn" onclick="inComEst(' + (data.pi2.currentPage + 1) + ')">&gt;</button>'
		    		    }
		    		    
		    		    $('#pagingArea').append(paging);
		    			
		        		$(".table-hover>tbody>tr td:not(:last-child)").click(function() {
		        			
		        			let eno = $(this).siblings(".eno").text();
		        			// console.log(eno);
		        			location.href = "estimateDetail.me?eno=" + eno;
		        		});
		    		} else {
		    			let content = '<tr><td colspan = "7">진행중인 계약이 없습니다.</td></tr>';
		    			$('#listBody').append(content);
		    		}

	    		},
	    		error: function(){
	    			console.log("실패")
	    		}
    		});
    	}
    	
    	function comEst(page){
    		
    		$('#listBody').empty();
    		$('#pagingArea').empty();
    		
    		$.ajax({
    			
    		    url: "comEstimate.me",
    		    dataType: "json",
    		    data: {
    		        cPage: page
    		    },
    		    success: function(data){
    		    	let list = data.list1;
    		    	if(list.length != 0){
    		    		
	    		    	for(let i = 0; i < list.length; i++){
		    		    	let content = '<tr>';
	    		    		
	    		    		if(${ sessionScope.loginUser.userNo } == list[i].estimate.gosuNo){
			    				content += "<td></td>";
			    			} else {
			    				content += "<td> √ </td>";	
			    			}
	    		    		
	    		    		content +=
	    		    		
		                    '<td class="eno">'+list[i].estimate.estNo+'</td>' +
		                    '<td class="truncate">'+list[i].estimate.estTitle+'</td>' +
		                    '<td>'+list[i].estimate.gosuNo+'</td>' +
		                    '<td>'+list[i].estimate.userNo+'</td>' +
		                    '<td>'+list[i].estimate.startDate+'</td>' +
		                    '<td>서비스 완료</td>';
		                    
		                    
		                    if(data.userNo != list[i].estimate.gosuNo){
		                    	
		                    	if(list[i].reviewCnt > 0) {
		                    		content += '<td>' + '<a type="button" class="btn btn-secondary btn-sm">'
		                    				 + '작성완료' + '</a>' + '</td>';
		                    	} else {
		                    		content += '<td id="review">' + '<a type="button" class="btn btn-success btn-sm">'
		                    				 + '작성하기' + '</a>' 
		                    				 + '<input type="hidden" id="estNo" value="' 
		                    				 + list[i].estimate.estNo + '">' + '</td>';
		                    	}
		                    } else {
		                    	
		                    	if(list[i].reviewCnt > 0){
		                    		content += '<td class="review-info">'
		                    				 + '<a type="button" class="btn btn-success btn-sm">'
		                    				 + '리뷰보기' + '</a>'
		                    				 + '<input type="hidden" class="revNo" value="'
		                    				 + list[i].revNo + '">' + '</td>';
		                    	} else {
		                    		
		                    		content += '<td>' + '<a type="button" class="btn btn-secondary btn-sm">'
		                    				 + '리뷰대기' + '</a>' + '</td>';
		                    	}
		                    }
		                    
		                	content += '</tr>';
		                	
							// console.log(content);
		                	$('#listBody').append(content);
		    		    }
	    		    	
		    		    let paging = '';
	    		    	
		    		    if(data.pi1.currentPage == 1){
		    		    	paging += '<button class="pagingBtn" disabled style="display:none;">&lt;</button>';
		    		    } else {
		    		    	paging += '<button class="pagingBtn" onclick="comEst(' + (data.pi1.currentPage - 1) + ')">&lt;</button>';
		    		    }
		    		    
		    		    for(let i = data.pi1.startPage; i <= data.pi1.endPage; i++){
		    		    	
		    		    	if(data.pi1.currentPage == i){
		    		    		
								paging += '<button class="pageBtn" disabled style="background-color:rgb(32, 93, 154);" onclick="comEst('+ i +')">' + i + '</button>';	    		    	
		    		    	} else{
		    		    		
								paging += '<button class="pageBtn" onclick="comEst('+ i +')">' + i + '</button>';	    		    	
		    		    	}
		    		    	
		    		    }
		    		    
		    		    if(data.pi1.currentPage == data.pi1.endPage){
		    		    	paging += '<button class="pagingBtn" disabled style="display:none;">&gt;</button>';
		    		    } else {
		    		    	paging += '<button class="pagingBtn" onclick="comEst(' + (data.pi1.currentPage + 1) + ')">&gt;</button>';
		    		    }
		    		    
		    		    $('#pagingArea').append(paging);
	
		    		    $("#review").click(function(){
		        			let eno = $("#estNo").val();
		        			// console.log(eno);
		        			
		        			location.href = "reviewWrite.me?eno=" + eno;
		        		});
	
		        		$(".review-info").click(function(){
		        			
		        			let rno = $(this).closest('tr').find(".revNo").val();
	
		        			// console.log(rno);
		        			
		        			location.href = "reviewDetail.me?rno=" + rno;
		        		});
		        		
		        		$(".table-hover>tbody>tr td:not(:last-child)").click(function() {
		        			
		        			let eno = $(this).siblings(".eno").text();
		        			// console.log(eno);
		        			location.href = "estimateDetail.me?eno=" + eno;
		        		});
    		    	} else {
    		    		let content = '<tr><td colspan = "7">완료된 계약이 없습니다.</td></tr>';
		    			$('#listBody').append(content);
    		    	}
	    		    
    		    },
    		    error : function(){
    		    	console.log("실패");
    		    }
    		
    		});
    	}
    	
    </script>
	<br><br><br><br>
	<jsp:include page="../common/footer.jsp" />
</body>
</html>