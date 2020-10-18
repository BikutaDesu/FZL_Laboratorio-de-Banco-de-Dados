package br.com.carnaval.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.com.carnaval.model.Jurado;

public class JuradoDAO {

	private Connection c;
	
	public JuradoDAO() throws ClassNotFoundException, SQLException {
		GenericDAO gd = new GenericDAO();
		c = gd.getConnection();
	}
	
	public List<Jurado> selectAll() throws SQLException{
		String sql = "SELECT * FROM jurados";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		List<Jurado> jurados = new ArrayList<Jurado>();
		
		while (rs.next()) {
			Jurado jurado = new Jurado();
			jurado.setId(rs.getLong("id"));
			jurado.setNome(rs.getString("nome"));
			
			jurados.add(jurado);
		}
		return jurados;
	}
	
}
