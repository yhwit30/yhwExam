package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.vo.Rq;

@Controller
public class UsrHomeController {
	
	@Autowired
	private Rq rq;

	@RequestMapping("/usr/home/main")
	public String showMain() {

		if(rq.isLogined()) {
			return "/usr/home/main";
		}
		
		return "/usr/member/login";
	}

	@RequestMapping("/")
	public String showRoot() {

		if(rq.isLogined()) {
			return "redirect:/usr/home/main";
		}
		
		return "redirect:/usr/member/login";
	}
}

