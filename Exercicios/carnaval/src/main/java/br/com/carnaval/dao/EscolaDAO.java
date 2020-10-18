package br.com.carnaval.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.carnaval.model.Escola;

public class EscolaDAO {
	
	private Connection c;

	public EscolaDAO() throws ClassNotFoundException, SQLException {
		GenericDAO gd = new GenericDAO();
		c = gd.getConnection();
	}
	
	public List<Escola> selectAll() throws SQLException{
		String sql = "SELECT * FROM escolas";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		List<Escola> escolas = new ArrayList<Escola>();
		
		while (rs.next()) {
			Escola escola = new Escola();
			escola.setId(rs.getLong("id"));
			escola.setNome(rs.getString("nome"));
			escola.setNotaTotal(rs.getFloat("total_pontos"));
			
			escolas.add(escola);
		}
		c.close();
		return escolas;
	}
	
	public Escola selectById(Integer id) throws SQLException{
		String sql = "SELECT * FROM escolas WHERE id = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, id);
		ResultSet rs = ps.executeQuery();
		
		Escola escola = new Escola();
		while (rs.next()) {
			escola.setId(rs.getLong("id"));
			escola.setNome(rs.getString("nome"));
			escola.setNotaTotal(rs.getFloat("total_pontos"));
		}
		c.close();
		return escola;
	}
}
