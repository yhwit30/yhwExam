package com.example.demo.service;

import java.awt.Color;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.MaintenanceFeeRepository;
import com.example.demo.vo.MaintenanceFee;
import com.lowagie.text.Cell;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import jakarta.servlet.http.HttpServletResponse;

@Service
public class PdfService {

	@Autowired
	private MaintenanceFeeRepository maintenanceFeeRepository;

	private void writeTableData(PdfPTable table, Font font, MaintenanceFee maintenanceFee) {
		// header용 셀
		PdfPCell cell = new PdfPCell();
		cell.setBackgroundColor(Color.LIGHT_GRAY);
		cell.setPadding(5);
		cell.setHorizontalAlignment(Element.ALIGN_CENTER);

		// 표 단락 나누기용 셀
		PdfPCell cellFloat = new PdfPCell();
		cellFloat.setColspan(2);
		cellFloat.setFixedHeight(20);
		cellFloat.setBorder(0);

		cell.setPhrase(new Phrase("건물", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getBldgName(), font));

		cell.setPhrase(new Phrase("호실", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getRoomNum(), font));

		cell.setPhrase(new Phrase("이름", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getTenantName(), font));

		table.addCell(cellFloat);

		cell.setPhrase(new Phrase("항목", font));
		table.addCell(cell);

		cell.setPhrase(new Phrase("세부금액", font));
		table.addCell(cell);
		
		table.addCell(new Phrase("엘리베이터", font));
		table.addCell(new Phrase("" + maintenanceFee.getElevater()));
		table.addCell(new Phrase("소방안전", font));
		table.addCell(new Phrase("" + maintenanceFee.getFireSafety()));
		table.addCell(new Phrase("인터넷,TV", font));
		table.addCell(new Phrase("" + maintenanceFee.getInternetTV()));
		table.addCell(new Phrase("공용전기", font));
		table.addCell(new Phrase("" + maintenanceFee.getCommonElec()));
		table.addCell(new Phrase("사용전기", font));
		table.addCell(new Phrase("" + maintenanceFee.getElecUse()));
		table.addCell(new Phrase("전기비용", font));
		table.addCell(new Phrase("" + maintenanceFee.getElecBill()));
		table.addCell(new Phrase("공용수도", font));
		table.addCell(new Phrase("" + maintenanceFee.getCommonWater()));
		table.addCell(new Phrase("사용수도", font));
		table.addCell(new Phrase("" + maintenanceFee.getWaterUse()));
		table.addCell(new Phrase("수도비용", font));
		table.addCell(new Phrase("" + maintenanceFee.getWaterBill()));
		table.addCell(new Phrase("가스사용", font));
		table.addCell(new Phrase("" + maintenanceFee.getGasUse()));
		table.addCell(new Phrase("가스비용", font));
		table.addCell(new Phrase("" + maintenanceFee.getGasBill()));

		table.addCell(cellFloat);

		cell.setPhrase(new Phrase("당월계", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getMonthlyMaintenanceFee()));

		cell.setPhrase(new Phrase("연체료", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getLateFee()));
		
		cell.setPhrase(new Phrase("납기 후 금액", font));
		table.addCell(cell);
		table.addCell(new Phrase("" + maintenanceFee.getLateMaintenanceFee()));
	}

	public void export(HttpServletResponse response, int tenantId, int bldgId, Integer year, String month)
			throws DocumentException, IOException {

		// 관리비 데이터 가져오기
		MaintenanceFee maintenanceFee = maintenanceFeeRepository.getMaintenanceFee(tenantId, bldgId, 2024, month);

		// pdf 파일 만들기
		Document document = new Document(PageSize.A4);
		PdfWriter.getInstance(document, response.getOutputStream());

		document.open();

		// 폰트설정
		Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA_BOLD);
		fontTitle.setSize(18);
		Font fontParagraph = FontFactory.getFont(FontFactory.HELVETICA);
		fontParagraph.setSize(10);
		// 한글은 추가로 폰트 넣어줘야함
		BaseFont baseFont = BaseFont.createFont("c:/windows/fonts/malgun.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
		Font font = new Font(baseFont, 10);
		Font titleFont = new Font(baseFont, 18);

		// 내용설정
		Paragraph title = new Paragraph(month + "월 관리비 고지서", titleFont);
		title.setAlignment(Paragraph.ALIGN_CENTER);

//		Paragraph paragraph2 = new Paragraph("This is a paragraph", fontParagraph);
//		paragraph2.setAlignment(Paragraph.ALIGN_LEFT);
//
//		Paragraph paragraph3 = new Paragraph("한글은 나오려나", font);
//		paragraph2.setAlignment(Paragraph.ALIGN_LEFT);
//
//		Paragraph paragraph4 = new Paragraph(maintenanceFee.getTenantName(), font);
//		paragraph2.setAlignment(Paragraph.ALIGN_LEFT);
//
//		Paragraph paragraph5 = new Paragraph(maintenanceFee.getLeaseType(), font);
//		paragraph2.setAlignment(Paragraph.ALIGN_LEFT);

		PdfPTable col2table = new PdfPTable(2);
		col2table.setWidthPercentage(100);
		col2table.setSpacingBefore(15);
//		table.setWidths(new float[] {1.5f, 3.5f});

		writeTableData(col2table, font, maintenanceFee);

		// pdf파일 그리기
		document.add(title);
//		document.add(paragraph2);
//		document.add(paragraph3);
//		document.add(paragraph4);
//		document.add(paragraph5);

		document.add(col2table);

		document.close();

	}

}
