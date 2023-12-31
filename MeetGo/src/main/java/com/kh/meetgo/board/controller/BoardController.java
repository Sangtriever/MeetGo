package com.kh.meetgo.board.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.kh.meetgo.board.model.dto.BoardDto;
import com.kh.meetgo.board.model.dto.BoardFileDto;
import com.kh.meetgo.board.model.dto.ReplyDto;
import com.kh.meetgo.board.model.service.BoardService;
import com.kh.meetgo.board.model.vo.Board;
import com.kh.meetgo.board.model.vo.Board_File;
import com.kh.meetgo.board.model.vo.Reply;
import com.kh.meetgo.common.config.S3Uploader;
import com.kh.meetgo.common.model.service.CommonService;
import com.kh.meetgo.common.model.vo.PageInfo;
import com.kh.meetgo.common.template.Pagination;
import com.kh.meetgo.gosu.model.dto.PofolOpt;
import com.kh.meetgo.gosu.model.vo.Pofol;
import com.kh.meetgo.gosu.model.vo.PofolImg;
import com.kh.meetgo.member.model.vo.Member;

@Controller
public class BoardController {
	
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private S3Uploader s3Uploader;
	private CommonService commonService;


	
	
	// 고수찾아요 게시판리스트 조회
	@GetMapping("gosuList.bo")
	public ModelAndView selectGosuReqList(
			@RequestParam(value = "cpage", defaultValue = "1") int currentPage,
			ModelAndView mv) {
		
		int listCount = boardService.selectGosuReqListCount();
		
		int pageLimit = 5;
		int boardLimit = 20;
		
		PageInfo pi = Pagination.getPageInfo(listCount,
						currentPage, pageLimit, boardLimit);
		
		ArrayList<Board> list = boardService.selectGosuReqList(pi);
		
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .setViewName("board/gosuRequest/gosuList");
		return mv;
	}
	
	@GetMapping("gosuWrite.bo")
	public String gosuWrite() {
		
		return "board/gosuRequest/gosuWrite";
	}
	
	// 고수찾아요 게시판 등록
	@PostMapping("gosuInsert.bo")
	public String insertGosuReqBoard(		
							  HttpSession session,
							  Model model,
							  @SessionAttribute("loginUser") Member loginUser,
							  @RequestParam("gosuReqImg") ArrayList<MultipartFile> gosuReqImgArr,
							  String boardTitle,
							  String boardContent
							  ) {
		
		int userNo = loginUser.getUserNo();
			
		Board gosuReq = new Board();
		
		gosuReq.setBoardTitle(boardTitle);
		gosuReq.setBoardContent(boardContent);

		gosuReq.setUserNo(userNo);
		
		int result1 = boardService.insertGosuReqBoard(gosuReq);
		
		int boardNo = gosuReq.getBoardNo();
		
		int result2 = 0;
	
		try {	
		
			for(int i = 0; i < gosuReqImgArr.size(); i++) {
		
				String filePath = s3Uploader.upload(gosuReqImgArr.get(i), "boardImg");
		
				result2 = boardService.insertGosuReqImg(filePath, boardNo);
		
			}
		
		} catch (IOException e) {
			e.printStackTrace();
	
		}

		if(result1 * result2 > 0) { 
			
			session.setAttribute("alertMsg", "성공적으로 게시글이 등록되었습니다.");
			
			return "redirect:/gosuList.bo"; // 첫 페이지로 이동
			
		} else { 
			model.addAttribute("errorMsg", "게시글 등록 실패");
			
			return "common/errorPage";
		}
		
	}

	
	// 고수찾아요 게시판 상세조회	
	@RequestMapping("gosuDetail.bo")
	public ModelAndView selectGosuReqBoard(String bno, 
									ModelAndView mv
									) {
		
		int boardNo = Integer.parseInt(bno); 
				
		
		
		int result = boardService.increaseGosuReqCount(boardNo);
		
		
		if(result > 0) { 
			
			BoardDto m = boardService.selectGosuReqBoard(boardNo);
			
			ArrayList<Board_File> imgList = boardService.selectGosuReqImgList(boardNo);
			
			mv.addObject("m", m)
			  .addObject("imgList", imgList)
			  .setViewName("board/gosuRequest/gosuDetail"); 
			
		} else { 
			
			mv.addObject("errorMsg", "게시글 상세조회 실패")
			  .setViewName("common/errorPage");
		}
		
		return mv;
	}
	
	// 팁 노하우 게시판 리스트 조회
	@GetMapping("tipList.bo")
	public ModelAndView selectTipList(
			@RequestParam(value = "cpage", defaultValue = "1") int currentPage,
			ModelAndView mv) {
	
		int listCount = boardService.selectTipListCount();		
		int pageLimit = 5;
		int boardLimit = 5;
		
		PageInfo pi = Pagination.getPageInfo(listCount, 
						currentPage, pageLimit, boardLimit);
		
	
		ArrayList<BoardFileDto> dtoList = boardService.selectTipList(pi);

		mv.addObject("dtoList", dtoList)
		  .addObject("pi", pi)
		  .setViewName("board/tip/tipList");
		return mv;
	}
	
	
	@GetMapping("tipWrite.bo")
	public String tipWrite() {
		
		return "board/tip/tipWrite";
	}
	
	
	
	// 팁 노하우 게시판 등록
		@PostMapping("tipInsert.bo")
		public String insertTipBoard( 
			        Model model,
			        HttpSession session,
			        @SessionAttribute("loginUser") Member loginUser,
			        @RequestParam("tipImg") ArrayList<MultipartFile> tipImgArr,
			        String boardTitle,
			        String boardContent
					) {
			
			int userNo = loginUser.getUserNo();
				
			BoardFileDto tipDto = new BoardFileDto();
			
			tipDto.setBoardTitle(boardTitle);
			tipDto.setBoardContent(boardContent);
			
			tipDto.setUserNo(userNo);
			
			int result1 = boardService.insertTipBoard(tipDto);
			
			int boardNo = tipDto.getBoardNo();
			
	
			int result2 = 0;
		
			try {	
			
				for(int i = 0; i < tipImgArr.size(); i++) {
			
					String bfilePath = s3Uploader.upload(tipImgArr.get(i), "boardImg");
			
					result2 = boardService.insertTipImg(bfilePath, boardNo);
			
				}
			
			} catch (IOException e) {
				e.printStackTrace();
		
			}

			if(result1 * result2 > 0) { 
				
				session.setAttribute("alertMsg", "성공적으로 게시글이 등록되었습니다.");
				
				return "redirect:/tipList.bo"; // 첫 페이지로 이동
				
			} else { 
				model.addAttribute("errorMsg", "게시글 등록 실패");
				
				return "common/errorPage";
			}
			
		}

	
	// 팁노하우 게시판 상세 조회
		@RequestMapping("tipDetail.bo")
		public ModelAndView selectTipBoard(
				
				String bno, ModelAndView mv) {

			bno = bno.trim();

		    try {
		        
		    	int boardNo = Integer.parseInt(bno);
		    	
		        int result = boardService.increaseTipCount(boardNo);

		        
		        
		        if (result > 0) {
		            
		        	BoardFileDto m = boardService.selectTipBoard(boardNo);
		           
		        	
		        	ArrayList<BoardFileDto> dtoList =
		        			boardService.selectTipImgList(boardNo);
		        	
		        	
		        			mv.addObject("m", m)
		                    .addObject("dtoList", dtoList)
		                    .setViewName("board/tip/tipDetail");
		        } else {
		            mv.addObject("errorMsg", "게시글 상세조회 실패")
		                    .setViewName("common/errorPage");
		        }
		    } catch (NumberFormatException e) {
		        // 숫자로 변환에 실패한 경우에 대한 처리
		        mv.addObject("errorMsg", "게시글 번호가 올바르지 않습니다.")
		                .setViewName("common/errorPage");
		    }

		    return mv;
		}
	
	
	@GetMapping("noticeList.bo")
	public ModelAndView selectNoticeList(
			
			@RequestParam(value = "cpage", defaultValue = "1") int currentPage,
			ModelAndView mv) {
		
		int listCount = boardService.selectNoticeListCount();
		
		int pageLimit = 5;
		int boardLimit = 10;
		
		PageInfo pi = Pagination.getPageInfo(listCount, 
					currentPage, pageLimit, boardLimit);
		
		ArrayList<BoardDto> list = boardService.selectNoticeList(pi);
		
		
		mv.addObject("list", list)
		  .addObject("pi", pi)
		  .setViewName("board/notice/noticeList");
		  return mv;
		
	}
	
	@GetMapping("noticeWrite.bo")
	public String noticeWrite() {
		
		return "board/notice/noticeWrite";
	}

	
	@PostMapping("noticeInsert.bo")
	public String insertNoticeBoard(	
							  Board m,
							  HttpSession session,
							  Model model,
							  @SessionAttribute("loginUser") Member loginUser
							  
							  ) {
		
		int userNo = loginUser.getUserNo();
			
		m.setUserNo(userNo);
		
		int result = boardService.insertNoticeBoard(m);
		
		if(result > 0) { 
			
			session.setAttribute("alertMsg", "성공적으로 게시글이 등록되었습니다.");
			
			return "redirect:/noticeList.bo"; 
			
		} else { 
			
			
			model.addAttribute("errorMsg", "게시글 등록 실패");
			
			return "common/errorPage";
		}
	}

	@RequestMapping("noticeDetail.bo")
	public ModelAndView selectNoticeBoard(String bno, 
									ModelAndView mv) {
	
		
		int boardNo = Integer.parseInt(bno); 
		
	
		int result = boardService.increaseNoticeCount(boardNo);		
		
		
		if(result > 0) { 
			      	

			BoardDto m = boardService.selectNoticeBoard(boardNo);
			
			
			mv.addObject("m", m)			  
			.setViewName("board/notice/noticeDetail"); 
			
		} else { 
			
			mv.addObject("errorMsg", "게시글 상세조회 실패")
			  .setViewName("common/errorPage");
		}
		
		return mv;
	}
	
	
	@RequestMapping("sendPofol.po")
	public String sendPofolList() {
		return "board/portfolio/pofolList";
	}
	
	// 포트폴리오 게시판
	@ResponseBody
	@RequestMapping(value = "pofolListOrderBy.po", produces = "text/json; charset=UTF-8")
	public String selectPofolList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage
		 , @RequestParam(value = "standard") String standard
		 , @RequestParam(value = "category") String category) {

		int listCount = boardService.countPofolList();
		int pageLimit = 5;
		int boardLimit = 9;
		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
		
		int categoryBigNo = Integer.parseInt(category);
		
		// 전체 내용 리스트
		ArrayList<PofolOpt> list = boardService.selectPofolList(pi, standard, categoryBigNo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("list", list);
		map.put("pi", pi);
		return new Gson().toJson(map);
	}

	@ResponseBody
	@RequestMapping("sendPofolWrite.po")
	public ModelAndView sendPofolWrite(@SessionAttribute("loginUser") Member loginUser
								, ModelAndView mv) {
		
		int userNo = loginUser.getUserNo();
		
		ArrayList<String> loginUserCtgName = boardService.getLoginUserCtgName(userNo);
		
		mv.addObject("loginUserCtgName", loginUserCtgName).setViewName("board/portfolio/pofolWrite");
		return mv;
	}
	
	@ResponseBody
	@PostMapping(value = "pofolWrite.po", produces = "text/json; charset=UTF-8")
	public void pofolWrite(ArrayList<MultipartFile> pofolImgArr
			  , @SessionAttribute("loginUser") Member loginUser
			  , String categorySmallNo
			  ,	String pofolTitle
			  , String pofolIntro
			  , String pofolPrice
			  , String pofolContent, Model model) {
		
		int gosuNo = loginUser.getUserNo(); // 고수번호
		
		Pofol pofol = new Pofol();
		pofol.setGosuNo(gosuNo);
		pofol.setPofolService(categorySmallNo);
		pofol.setPofolTitle(pofolTitle);
		pofol.setPofolIntro(pofolIntro);
		pofol.setPofolPrice(pofolPrice);
		pofol.setPofolContent(pofolContent);
		
		// 게시글 먼저 등록
		boardService.insertPofol(pofol);
		
		int pofolNo = pofol.getPofolNo();

				 
		try {
			for(int i = 0; i < pofolImgArr.size(); i++) {
				String pofolImgUrl = s3Uploader.upload(pofolImgArr.get(i), "pofolImg");
				boardService.insertPofolImg(pofolImgUrl, pofolNo);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	// 포폴 상세보기
	@ResponseBody
	@RequestMapping(value = "pofolDetail.po")
	public ModelAndView pofolDetail(String pno, ModelAndView mv) {
		
		// pno는 포폴게시글 번호
		int pofolNo = Integer.parseInt(pno);
		boardService.increasePofolCount(pofolNo);
		
		ArrayList<PofolOpt> list = boardService.pofolDetail(pofolNo);
		ArrayList<PofolImg> imgList = boardService.pofolDetailImg(pofolNo);

		mv.addObject("list", list)
		.addObject("imgList", imgList)
		.setViewName("board/portfolio/pofolDetail");
		
		return mv;
	}
	
	// 포폴 수정페이지로 이동
	@ResponseBody
	@RequestMapping("sendUpdatePofol.po")
	public ModelAndView sendUpdatePofol(String pno, ModelAndView mv) {
		
		int pofolNo = Integer.parseInt(pno);
		
		ArrayList<PofolOpt> list = boardService.pofolDetail(pofolNo);
		ArrayList<PofolImg> imgList = boardService.pofolDetailImg(pofolNo);
		
		mv.addObject("list", list)
		.addObject("imgList", imgList)
		.setViewName("board/portfolio/pofolUpdate");
		
		return mv;
	}
	
	// 포폴 수정하기
	@RequestMapping("updatePofol.po")
	public String updatePofol(
			String pofolTitle
			, String pofolPrice
			, String pofolIntro
			, String pofolContent
			, String pno
			, Model model
			, HttpSession session
			, @RequestParam("pofolImgNo") ArrayList<String> imgNo
			, @RequestParam("pofolImgUrl") ArrayList<MultipartFile> imgList) {
		
		int pofolImgNo = 0;
		String pofolImgUrl = "";
		int pofolNo = Integer.parseInt(pno);
		
		int result1 = boardService.updatePofol(pofolNo, pofolTitle, pofolPrice, pofolIntro, pofolContent);
		int result2 = 0;
		
		for(int i = 0; i < imgList.size(); i++) {
			
			pofolImgNo = Integer.parseInt(imgNo.get(i));
			
			try {
				// 업로드한게 없으면 다음 차수로
				if(imgList.get(i).getOriginalFilename().isEmpty()) {
					continue;
				} else {
					pofolImgUrl = s3Uploader.upload(imgList.get(i), "pofolImgUrl");
					result2 = boardService.updatePofolImg(pofolImgNo, pofolImgUrl);
				}	
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		if(result1 * result2 > 0) {
			session.setAttribute("alertMsg", "포트폴리오 수정 성공");
			return "redirect:/sendPofol.po";
		} else {
			model.addAttribute("errorMsg", "포트폴리오 수정 실패");
			return "common/errorPage";
		}

	}
	
	@RequestMapping("deletePofol.po")
	public String deletePofol(String pno, HttpSession session, Model model) {
		
		int pofolNo = Integer.parseInt(pno);
		
		int result1 = boardService.deletePofol(pofolNo);
		int result2 = boardService.deletePofolImg(pofolNo);
		
		if(result1 * result2 > 0) {
			session.setAttribute("alertMsg", "포트폴리오 삭제 성공");
			return "redirect:/sendPofol.po";
		} else {
			model.addAttribute("errorMsg", "포트폴리오 삭제 실패");
			return "common/errorPage";
		}
		
		
	}
		
	
	@ResponseBody
	@RequestMapping(value = "gosuRlist.bo", produces = "application/json; charset=UTF-8")
	public String ajaxSelectReplyList(@RequestParam("bno") Integer bno) {
		ArrayList<ReplyDto> list = boardService.selectGosuReplyList(bno);
		return new Gson().toJson(list);
	}
	
	
	@ResponseBody
	@RequestMapping(value = "gosuRinsert.bo", produces = "text/html; charset=UTF-8")
	public String ajaxInsertGosuReply(Reply r) {
		

		int result = boardService.insertGosuReply(r);
		return (result > 0) ? "success" : "fail";
	}

	@ResponseBody
	@RequestMapping(value = "rlist.bo", produces = "application/json; charset=UTF-8")
	public String ajaxSelectReplyList(int userNo) {
		
		ArrayList<Reply> list = boardService.selectReplyList(userNo);

		
		return new Gson().toJson(list);
	}
	
	@RequestMapping("deleteBoard.bo")
	public String deleteBoard(String bno) {
		
		int boardNo = Integer.parseInt(bno);
		
		int result = boardService.deleteBoard(boardNo);
		
		return "board/tip/tipList";
	
	}
	
	
	
}