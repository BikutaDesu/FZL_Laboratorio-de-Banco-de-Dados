package com.lbd.gp.repository;

import java.sql.SQLException;
import java.util.List;

import com.lbd.gp.model.Ranking;

public interface RankingRepository {

	public List<Ranking> findByFaseAndProva(Boolean fase, Integer prova) throws SQLException;
	
}
