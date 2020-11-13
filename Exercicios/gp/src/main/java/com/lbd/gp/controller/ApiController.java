package com.lbd.gp.controller;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lbd.gp.dao.RankingDAO;
import com.lbd.gp.model.Ranking;
import com.lbd.gp.repository.ProvaRepository;
import com.lbd.gp.repository.RankingRepository;

@Controller
@RequestMapping("api")
public class ApiController {

	@Autowired
	private ProvaRepository provaRepository;

	private RankingRepository rankingRepository;

	@GetMapping("ranking/{id}/{fase}")
	@ResponseBody
	public List<Ranking> provas(@PathVariable(name = "id") Integer id, @PathVariable(name = "fase") Boolean fase)
			throws ClassNotFoundException, SQLException {
		rankingRepository = new RankingDAO();

		List<Ranking> rankings = rankingRepository.findByFaseAndProva(fase, id);

		return rankings;
	}

}
