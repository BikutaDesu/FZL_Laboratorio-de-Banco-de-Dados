package br.com.carnaval.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import br.com.carnaval.model.Quesito;

public class QuesitoDAO {

	private Connection c;

	public QuesitoDAO() throws ClassNotFoundException, SQLException {
		GenericDAO gd = new GenericDAO();
		c = gd.getConnection();
	}

	public List<Quesito> selectAll() throws ClassNotFoundException, SQLException {
		String sql = "SELECT * FROM quesitos";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		List<Quesito> quesitos = new ArrayList<Quesito>();

		while (rs.next()) {
			Quesito quesito = new Quesito();
			quesito.setId(rs.getLong("id"));
			quesito.setNome(rs.getString("nome"));

			quesitos.add(quesito);
		}
		c.close();
		return quesitos;
	}

	public Quesito selectByEscolaAndId(Integer idEscola, Integer idQuesito)
			throws ClassNotFoundException, SQLException {
		String sql = "SELECT * FROM dbo.fn_tabelaNotasQuesitoEscola(?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, idEscola);
		ps.setInt(2, idQuesito);
		ResultSet rs = ps.executeQuery();

		Quesito quesito = new Quesito();
		while (rs.next()) {
			quesito.setId(rs.getLong("id"));
			quesito.setNome(rs.getString("quesito"));
			List<Float> notas = Arrays.asList(rs.getFloat("nota1"), rs.getFloat("nota2"), rs.getFloat("nota3"),
					rs.getFloat("nota4"), rs.getFloat("nota5"));
			quesito.setNotas(notas);
			quesito.setMaiorNota(rs.getFloat("maior_nota"));
			quesito.setMenorNota(rs.getFloat("menor_nota"));
			quesito.setNotaTotal(rs.getFloat("nota_final"));
		}
		c.close();
		return quesito;
	}
}
