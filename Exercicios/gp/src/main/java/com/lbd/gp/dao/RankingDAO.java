package com.lbd.gp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.lbd.gp.model.Ranking;
import com.lbd.gp.repository.RankingRepository;

public class RankingDAO implements RankingRepository {

	private Connection c;

	public RankingDAO() throws ClassNotFoundException, SQLException {
		GenericDAO gDao = new GenericDAO();
		c = gDao.getConnection();
	}

	@Override
	public List<Ranking> findByFaseAndProva(Boolean fase, Integer prova) throws SQLException {
		String sql = "SELECT * FROM dbo.f_melhores(?, ?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setBoolean(1, fase);
		ps.setInt(2, prova);
		ResultSet rs = ps.executeQuery();

		List<Ranking> rankings = new ArrayList<Ranking>();

		while (rs.next()) {
			Ranking ranking = new Ranking();
			ranking.setProva(rs.getString("prova"));
			ranking.setIdAtleta(rs.getInt("atleta_id"));
			ranking.setNomeAtleta(rs.getString("atleta"));
			ranking.setScore(rs.getString("score"));
			ranking.setPais(rs.getString("pais"));

			rankings.add(ranking);
		}
		c.close();

		return rankings;
	}

}
