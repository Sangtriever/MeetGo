package com.kh.meetgo.board.model.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import com.kh.meetgo.board.model.dao.BoardDao;
import com.kh.meetgo.board.model.dto.BoardDto;
import com.kh.meetgo.board.model.dto.BoardFileDto;
import com.kh.meetgo.board.model.dto.ReplyDto;
import com.kh.meetgo.board.model.vo.Board;
import com.kh.meetgo.board.model.vo.Board_File;
import com.kh.meetgo.board.model.vo.Reply;
import com.kh.meetgo.common.model.vo.PageInfo;
import com.kh.meetgo.gosu.model.dto.PofolOpt;
import com.kh.meetgo.gosu.model.vo.Pofol;
import com.kh.meetgo.gosu.model.vo.PofolImg;

// @Component
@Service
@EnableTransactionManagement // 트랜잭션 관리를 하겠다.
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDao boardDao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public int selectGosuReqListCount() {
		return boardDao.selectGosuReqListCount(sqlSession);
	}
	
	// 고수찾아요 게시판 리스트 
	@Override
	public ArrayList<Board> selectGosuReqList(PageInfo pi) {
		return boardDao.selectGosuReqList(sqlSession, pi);
	}
	
	// 고수찾아요 작성하기
	@Override
	@Transactional 
	public int insertGosuReqBoard(Board gosuReq) {
		return boardDao.insertGosuReqBoard(sqlSession, gosuReq);
	}
	
	@Override
	@Transactional
	public int increaseGosuReqCount(int boardNo) {
		return boardDao.increaseGosuReqCount(sqlSession, boardNo);
	}
	
	// 고수이미지
	@Override
	public int insertGosuReqImg(String filePath, int boardNo) {
		return boardDao.insertGosuReqImg(sqlSession, filePath, boardNo);
	}
	
	public ArrayList<Board_File> selectGosuReqImgList(int boardNo){
		return boardDao.selectGosuReqImgList(sqlSession, boardNo);
	}
	
	
	@Override
	public int selectTipListCount() {
		return boardDao.selectTipListCount(sqlSession);
	}
	
	// 팁노하우 게시판 리스트 
	@Override
	public ArrayList<BoardFileDto> selectTipList(PageInfo pi) {
		return boardDao.selectTipList(sqlSession, pi);
	}

	
	// 팁노하우 작성하기
	@Override
	@Transactional 
	public int insertTipBoard(BoardFileDto tipDto ) {
		return boardDao.insertTipBoard(sqlSession, tipDto);
	}
	
	@Override
	@Transactional
	public int increaseTipCount(int boardNo) {
		return boardDao.increaseTipCount(sqlSession, boardNo);
	}
	
	@Override
	public int insertTipImg(String filePath, int boardNo) {
		return boardDao.insertTipImg(sqlSession, filePath, boardNo);
	}
	
	public ArrayList<BoardFileDto> selectTipImgList(int boardNo){
		return boardDao.selectTipImgList(sqlSession, boardNo);
	}
	
	@Override
	public ArrayList<ReplyDto> selectGosuReplyList(int boardNo) {
		return boardDao.selectGosuReplyList(sqlSession, boardNo);
	}

	@Override
	public int insertGosuReply(Reply r) {
		return boardDao.insertGosuReply(sqlSession, r);
	}
	
	@Override
	@Transactional
	public int increaseNoticeCount(int boardNo) {
		return boardDao.increaseNoticeCount(sqlSession, boardNo);
	}
	

	

	

	public int countPofolList() {
		return boardDao.countPofolList(sqlSession);
	}
	@Override
	public ArrayList<PofolOpt> selectPofolList(PageInfo pi, String standard, int categoryBigNo) {
		return boardDao.selectPofolList(sqlSession, pi, standard, categoryBigNo);
	}
	@Override
	public ArrayList<String> getLoginUserCtgName(int userNo) {
		return boardDao.getLoginUserCtgName(sqlSession, userNo);
	}

	@Override
	public BoardDto selectGosuReqBoard(int boardNo) {
		return boardDao.selectGosuReqBoard(sqlSession, boardNo);
	}

	@Override
	public BoardFileDto selectTipBoard(int boardNo) {
		return boardDao.selectTipBoard(sqlSession, boardNo);
	}

	
	@Override
	public int selectNoticeListCount() {
		return boardDao.selectNoticeListCount(sqlSession);
	}
	
	
	@Override
	public ArrayList<BoardDto> selectNoticeList(PageInfo pi) {
		return boardDao.selectNoticeList(sqlSession, pi);
	}
	
	@Override
	public int insertPofol(Pofol pofol) {
		return boardDao.insertPofol(sqlSession, pofol);
	}
	
	@Override
	public int insertPofolImg(String pofolImgUrl, int pofolNo) {
		return boardDao.insertPofolImg(sqlSession, pofolImgUrl, pofolNo);
	}
	
	@Override
	public int increasePofolCount(int pofolNo) {
		return boardDao.increasePofolCount(sqlSession, pofolNo);
	}
	
	@Override
	public ArrayList<PofolOpt> pofolDetail(int pofolNo) {
		return boardDao.pofolDetail(sqlSession, pofolNo);
	}
	@Override
	public ArrayList<PofolImg> pofolDetailImg(int pofolNo) {
		return boardDao.pofolDetailImg(sqlSession, pofolNo);
	}
	
	@Override
	public int updatePofol(int pofolNo, String pofolTitle, String pofolPrice, String pofolIntro, String pofolContent) {
		return boardDao.updatePofol(sqlSession, pofolNo, pofolTitle, pofolPrice, pofolIntro, pofolContent);
	}
	@Override
	public int updatePofolImg(int pofolImgNo, String pofolImgUrl) {
		return boardDao.updatePofolImg(sqlSession, pofolImgNo, pofolImgUrl);
	}
	
	@Override
	public int deletePofol(int pofolNo) {
		return boardDao.deletePofol(sqlSession, pofolNo);
	}
	@Override
	public int deletePofolImg(int pofolNo) {
		return boardDao.deletePofolImg(sqlSession, pofolNo);
	}

	@Override
	public int countAllMyPost(int userNo) {
		return boardDao.countAllMyPost(sqlSession, userNo);
	}

	@Override
	public ArrayList<Board> selectAllMyPost(PageInfo pi, int userNo) {
		return boardDao.selectAllMyPost(sqlSession, pi, userNo);
	}


	@Override
	public ArrayList<Reply> selectReplyList(int userNo) {
		// TODO Auto-generated method stub
		return boardDao.selectReplyList(sqlSession,userNo);
	}

	@Override
	public int insertReply(Reply r) {
		// TODO Auto-generated method stub
		return 0;
	}



	@Override
	@Transactional 
	public int insertNoticeBoard(Board m) {
		return boardDao.insertNoticeBoard(sqlSession, m);
	}

	@Override
	public BoardDto selectNoticeBoard(int boardNo) {
		return boardDao.selectNoticeBoard(sqlSession, boardNo);
	}

	@Override
	public int deleteBoard(int bno) {
		return boardDao.deleteBoard(sqlSession, bno);
	}

	
	
	}















