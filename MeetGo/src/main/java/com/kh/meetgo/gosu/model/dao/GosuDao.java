package com.kh.meetgo.gosu.model.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.meetgo.common.model.vo.PageInfo;
import com.kh.meetgo.gosu.model.dto.GosuOpt;
import com.kh.meetgo.gosu.model.dto.PofolOpt;
import com.kh.meetgo.gosu.model.vo.GosuImg;
import com.kh.meetgo.member.model.vo.Gosu;

@Repository
public class GosuDao {
	
	// 고수 회원수 조회
	public int selectOptionalGosuCount(SqlSessionTemplate sqlSession, String region
									  , String regionSub, int categoryBigNo, int categorySmallNo, String keyword) {
		
		Map<String, Object> params = new HashMap<>();
	    params.put("region", region);
	    params.put("regionSub", regionSub);
	    params.put("categoryBigNo", categoryBigNo);
	    params.put("categorySmallNo", categorySmallNo);
	    params.put("keyword", keyword);
		
		return sqlSession.selectOne("gosuMapper.selectOptionalGosuCount", params);
	}
	// 고수 회원 조회결과
	public ArrayList<GosuOpt> selectOptionalGosu(SqlSessionTemplate sqlSession, String region
			  , String regionSub, int categoryBigNo, int categorySmallNo, String keyword, String filter, PageInfo pi){
		
		Map<String, Object> params = new HashMap<>();
	    params.put("region", region);
	    params.put("regionSub", regionSub);
	    params.put("categoryBigNo", categoryBigNo);
	    params.put("categorySmallNo", categorySmallNo);
	    params.put("keyword", keyword);
		params.put("filter", filter);
	    
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		return (ArrayList)sqlSession.selectList("gosuMapper.selectOptionalGosu", params, rowBounds);
	}
	
	// 고수찾기 상세정보
	public ArrayList<GosuOpt> gosuDetail(SqlSessionTemplate sqlSession, int gosuNo) {	
		return (ArrayList)sqlSession.selectList("gosuMapper.gosuDetail", gosuNo);
	}
	
	// 고수이미지 불러오기
	public ArrayList<GosuImg> getGosuImg(SqlSessionTemplate sqlSession, int gosuNo) {
		return (ArrayList)sqlSession.selectList("gosuMapper.getGosuImg", gosuNo);
	}
	
	// 고수찾기 상세 - 포트폴리오 정보 불러오기
	public ArrayList<PofolOpt> showGosuPofol(SqlSessionTemplate sqlSession, int gosuNo) {
		return (ArrayList)sqlSession.selectList("gosuMapper.showGosuPofol", gosuNo);
	}
	
	// 고수찾기 상세 - 리뷰 정보 불러오기
	public ArrayList<GosuOpt> getGosuReview(SqlSessionTemplate sqlSession, int gosuNo) {
		return (ArrayList)sqlSession.selectList("gosuMapper.getGosuReview", gosuNo);
	}
	public ArrayList<GosuOpt> getGosuReviewImg(SqlSessionTemplate sqlSession, int gosuNo) {
		return (ArrayList)sqlSession.selectList("gosuMapper.getGosuReviewImg", gosuNo);
	}
	
	// 고수좋아요 검사
	public int countGosuLike(SqlSessionTemplate sqlSession, int userNo, int gosuNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("userNo", userNo);
	    params.put("gosuNo", gosuNo);
		return sqlSession.selectOne("gosuMapper.countGosuLike", params);
	}
	// 고수 좋아요 삭제 or 추가
	public int deleteGosuLike(SqlSessionTemplate sqlSession, int userNo, int gosuNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("userNo", userNo);
	    params.put("gosuNo", gosuNo);
		return sqlSession.delete("gosuMapper.deleteGosuLike", params);
	}
	public int insertGosuLike(SqlSessionTemplate sqlSession, int userNo, int gosuNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("userNo", userNo);
	    params.put("gosuNo", gosuNo);
		return sqlSession.insert("gosuMapper.insertGosuLike", params);
	}
	
	// 고수 등록용 메소드
	public int insertGosu(SqlSessionTemplate sqlSession, Gosu gosu) {
		
		return sqlSession.insert("gosuMapper.insertGosu", gosu);
	}
	
	// 고수 서비스 등록용 메소드
	public int insertGosuCate(SqlSessionTemplate sqlSession, int service, int gosuNo) {
		
		Map<String, Object> params = new HashMap<>();
	    params.put("service", service);
	    params.put("gosuNo", gosuNo);
		    
		return sqlSession.insert("gosuMapper.insertGosuCate", params);
	}
	
	// 고수로 상태변경용 메소드
	public int changeStatus(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.update("gosuMapper.changeStatus", userNo);
	}
	// 고수 비활성화 메소드
	public int deleteGosu(SqlSessionTemplate sqlSession, String userId) {
		// TODO Auto-generated method stub
		return sqlSession.update("gosuMapper.deleteGosu",userId);
	}
	public int gosuActivate(SqlSessionTemplate sqlSession, String userId) {
		// TODO Auto-generated method stub
		return sqlSession.update("gosuMapper.gosuActivate", userId);
	}
	
}
