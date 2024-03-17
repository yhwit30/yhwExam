package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.stereotype.Component;

@Component
public class UsrCrawlingNews {

	public List<String> naver() {

		// 결과 담을 변수
		List<String> naverNews = new ArrayList<>();

		// 크롬 드라이버 경로 설정 (크롬 드라이버 설치 필요)
		System.setProperty("webdriver.chrome.driver", "C:/work/chromedriver.exe");

		// 크롬 옵션 설정
		ChromeOptions options = new ChromeOptions();
//		options.addArguments("--headless"); // 브라우저를 표시하지 않고 실행할 경우

		// 웹 드라이버 초기화
		WebDriver driver = new ChromeDriver(options);

		try {
			// 크롤링할 웹 페이지 URL
			String naver = "https://search.naver.com/search.naver?where=news&ie=utf8&sm=nws_hty&query=%EB%B6%80%EB%8F%99%EC%82%B0";

			// 웹 페이지 열기
			driver.get(naver);

			// 정보를 담고 있는 요소들 찾기
			List<WebElement> elements = driver.findElements(By.cssSelector(".news_contents"));

			// 결과를 파일에 저장
//			saveToFile(elements, "output.txt");

			// 결과를 콘솔에 출력
			for (WebElement element : elements) {
				String news = element.getText();
				System.out.println(news);

				naverNews.add(news);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 웹 드라이버 종료
			driver.quit();
		}

		return naverNews;
	}

//	private void saveToFile(List<WebElement> elements, String fileName) throws IOException {
//		FileWriter writer = new FileWriter(fileName);
//		for (WebElement element : elements) {
//			String title = element.findElement(By.cssSelector(".ellipsis.rank01")).getText();
//			writer.write(title + "\n");
//		}
//		writer.close();
//		System.out.println("데이터를 파일에 저장했습니다.");
//	}

	public List<String> daum() {

		// 결과 담을 변수
		List<String> daumNews = new ArrayList<>();

		// 크롬 드라이버 경로 설정 (크롬 드라이버 설치 필요)
		System.setProperty("webdriver.chrome.driver", "C:/work/chromedriver.exe");

		// 크롬 옵션 설정
		ChromeOptions options = new ChromeOptions();
//		options.addArguments("--headless"); // 브라우저를 표시하지 않고 실행할 경우

		// 웹 드라이버 초기화
		WebDriver driver = new ChromeDriver(options);

		try {
			// 크롤링할 웹 페이지 URL
			String daum = "https://search.daum.net/search?w=news&nil_search=btn&DA=NTB&enc=utf8&cluster=y&cluster_page=1&q=%EB%B6%80%EB%8F%99%EC%82%B0";

			// 웹 페이지 열기
			driver.get(daum);

			// 정보를 담고 있는 요소들 찾기
			List<WebElement> elements = driver.findElements(By.cssSelector(".c-item-content"));

			// 결과를 콘솔에 출력
			for (WebElement element : elements) {
				String title = element.findElement(By.cssSelector(".item-title")).getText();
				System.out.println(title);
				String body = element.findElement(By.cssSelector(".item-contents")).getText();
				System.out.println(body);

				String news = title + "/" + body;

				daumNews.add(news);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 웹 드라이버 종료
			driver.quit();
		}
		return daumNews;
	}

	public List<String> google() {

		// 결과 담을 변수
		List<String> googleNews = new ArrayList<>();

		// 크롬 드라이버 경로 설정 (크롬 드라이버 설치 필요)
		System.setProperty("webdriver.chrome.driver", "C:/work/chromedriver.exe");

		// 크롬 옵션 설정
		ChromeOptions options = new ChromeOptions();
//		options.addArguments("--headless"); // 브라우저를 표시하지 않고 실행할 경우

		// 웹 드라이버 초기화
		WebDriver driver = new ChromeDriver(options);

		try {
			// 크롤링할 웹 페이지 URL
			String google = "https://www.google.com/search?q=%EB%B6%80%EB%8F%99%EC%82%B0&sca_esv=43fd76e6b38462bb&biw=1558&bih=833&tbm=nws&sxsrf=ACQVn0_YfNQ_wKMSbUIvj1SvOl35C1eVyQ%3A1710211199964&ei=f8DvZe3BOrqVvr0P4eK0iAE&udm=&ved=0ahUKEwit_cGY2e2EAxW6iq8BHWExDREQ4dUDCA0&uact=5&oq=%EB%B6%80%EB%8F%99%EC%82%B0&gs_lp=Egxnd3Mtd2l6LW5ld3MiCeu2gOuPmeyCsDILEAAYgAQYsQMYgwEyCxAAGIAEGLEDGIMBMgsQABiABBixAxiDATILEAAYgAQYsQMYgwEyCxAAGIAEGLEDGIMBMgsQABiABBixAxiDATILEAAYgAQYsQMYgwEyCxAAGIAEGLEDGIMBMgsQABiABBixAxiDATILEAAYgAQYsQMYgwFI6wFQAFgAcAB4AJABAJgBiAGgAYgBqgEDMC4xuAEDyAEA-AEBmAIBoAKRAZgDAJIHAzAuMaAHvgU&sclient=gws-wiz-news";

			// 웹 페이지 열기
			driver.get(google);

			// 정보를 담고 있는 요소들 찾기
			List<WebElement> elements = driver.findElements(By.cssSelector(".SoaBEf"));

			// 결과를 콘솔에 출력
			for (WebElement element : elements) {
				String news = element.getText();
				System.out.println(news);

				googleNews.add(news);

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 웹 드라이버 종료
			driver.quit();
		}
		return googleNews;
	}

}
