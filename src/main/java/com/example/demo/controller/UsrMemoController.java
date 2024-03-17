package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.BuildingService;
import com.example.demo.service.MemoService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Building;
import com.example.demo.vo.Memo;
import com.example.demo.vo.Rq;

@Controller
public class UsrMemoController {

	@Autowired
	private Rq rq;

	@Autowired
	private MemoService memoService;
	
	@Autowired
	private BuildingService buildingService;

	// 액션 메소드
	@RequestMapping("/usr/bg12343/memo/notice")
	public String showNotice(Model model) {

//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		return "usr/bg12343/memo/notice";
	}
	
	@RequestMapping("/usr/bg12343/memo/expenses")
	public String showExpenses(Model model) {
//		건물 변환 버튼용
		List<Building> buildings = buildingService.getForPrintBuildings();

		model.addAttribute("buildings", buildings);
		return "usr/bg12343/memo/expenses";
	}
	
	@RequestMapping("/usr/bg12343/memo/memoAdd")
	public String showMemoAdd(Model model) {

		return "usr/bg12343/memo/memoAdd";
	}

	@RequestMapping("/usr/bg12343/memo/doMemoAdd")
	@ResponseBody
	public String doMemoAdd(int boardId, String title, String body, String afterLoginUri) { // 매개변수 뭘 줄지
		// 로그인 체크 인터셉터에서

		// 제목 내용 빈 칸 확인
		if (Ut.isEmpty(boardId)) {
			return Ut.jsHistoryBack("F-1", "세입자이름을 입력해주세요");
		}
		if (Ut.isNullOrEmpty(title)) {
			return Ut.jsHistoryBack("F-2", "세입자휴대폰번호를 입력해주세요");
		}
		if (Ut.isNullOrEmpty(body)) {
			return Ut.jsHistoryBack("F-2", "세입자차량번호를 입력해주세요");
		}

//		ResultData memoAddRd = memoService.addMemo(rq.getLoginedMemberId(), boardId, title, body);
//
//		// 작성된 게시글 번호 가져오기
//		int id = (int) memoAddRd.getData1();
//
//		if (afterLoginUri.length() > 0) {
//			return Ut.jsReplace(memoAddRd.getResultCode(), memoAddRd.getMsg(), afterLoginUri);
//		}
//		return Ut.jsReplace(memoAddRd.getResultCode(), memoAddRd.getMsg(), "../bg12343/dashboard");
		return null;
	}

	@RequestMapping("/usr/bg12343/memo/memoModify")
	public String showMemoModify(Model model) {

		return "usr/bg12343/memo/memoModify";
	}

	@RequestMapping("/usr/bg12343/memo/doMemoModify")
	@ResponseBody
	public String doMemoModify(int[] id, String[] tenantName, int[] tenantPhone, String[] tenantCarNum,
			String[] tenantMemo) {

return null;
//		return Ut.jsReplace(roomModifyRd.getResultCode(), roomModifyRd.getMsg(), "../bg12343/tenant");
	}

	
	@RequestMapping("/usr/bg12343/memo/repair")
	public String showRepair(Model model) {

		List<Memo> memoRepair = memoService.getMemoRepair();
		int memoRepairCnt = memoRepair.size();
		
		model.addAttribute("memoRepair", memoRepair);
		model.addAttribute("memoRepairCnt", memoRepairCnt);
		return "usr/bg12343/memo/repair";
	}

	@RequestMapping("/usr/bg12343/memo/repairDetail")
	public String showRepairDetail(Model model, int id) {
		
		Memo memoRepairRd = memoService.getMemoRepairRd(id);
		
		model.addAttribute("memoRepairRd", memoRepairRd);
		return "usr/bg12343/memo/repairDetail";
	}
	
	@RequestMapping("/usr/bg12343/memo/repairModify")
	public String showRepairModify(Model model) {
		
		return "usr/bg12343/memo/repairModify";
	}

	@RequestMapping("/usr/bg12343/memo/addRepair")
	@ResponseBody
	public String doRepairAdd(int boardId, String title, String body, String afterLoginUri) { // 매개변수 뭘 줄지
		// 로그인 체크 인터셉터에서

		// 제목 내용 빈 칸 확인
		if (Ut.isEmpty(boardId)) {
			return Ut.jsHistoryBack("F-1", "세입자이름을 입력해주세요");
		}
		if (Ut.isNullOrEmpty(title)) {
			return Ut.jsHistoryBack("F-2", "세입자휴대폰번호를 입력해주세요");
		}
		if (Ut.isNullOrEmpty(body)) {
			return Ut.jsHistoryBack("F-2", "세입자차량번호를 입력해주세요");
		}

//		ResultData memoAddRd = memoService.addMemo(rq.getLoginedMemberId(), boardId, title, body);
//
//		// 작성된 게시글 번호 가져오기
//		int id = (int) memoAddRd.getData1();
//
//		if (afterLoginUri.length() > 0) {
//			return Ut.jsReplace(memoAddRd.getResultCode(), memoAddRd.getMsg(), afterLoginUri);
//		}
//		return Ut.jsReplace(memoAddRd.getResultCode(), memoAddRd.getMsg(), "../bg12343/dashboard");
		return null;
	}
	
}
