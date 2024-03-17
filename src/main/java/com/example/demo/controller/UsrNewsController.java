package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UsrNewsController {
	
	@Autowired
	private UsrCrawlingNews news;

	@RequestMapping("/usr/news/news")
	public String showNews(Model model) {

//		UsrCrawlingNews news = new UsrCrawlingNews();
		
		List<String> daumNews = news.daum();
		List<String> naverNews = news.naver();
		List<String> googleNews = news.google();
		
		model.addAttribute("daumNews", daumNews);
		model.addAttribute("naverNews", naverNews);
		model.addAttribute("googleNews", googleNews);
		return "usr/news/news";

	}

}