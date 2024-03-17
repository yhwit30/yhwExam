package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.MemoRepository;
import com.example.demo.vo.Memo;

@Service
public class MemoService {
	
	@Autowired
	private MemoRepository memoRepository;

	public List<Memo> getMemoRepair() {
		return memoRepository.getMemoRepair();
	}

	public Memo getMemoRepairRd(int id) {
		return memoRepository.getMemoRepairRd(id);
	}

}
