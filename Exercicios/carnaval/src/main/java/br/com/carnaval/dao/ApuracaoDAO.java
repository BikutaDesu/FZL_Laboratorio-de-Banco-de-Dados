package br.com.carnaval.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import br.com.carnaval.model.Apuracao;
import br.com.carnaval.model.Escola;
import br.com.carnaval.model.Jurado;
import br.com.carnaval.model.Quesito;

public class ApuracaoDAO {

	private Connection c;
	
	public ApuracaoDAO() throws ClassNotFoundException, SQLException {
		GenericDAO gd = new GenericDAO();
		c = gd.getConnection();
	}
	
	public void insert(Jurado jurado, Quesito quesito, Escola escola, Float nota) throws SQLException {
		String sql = "{CALL sp_inserirNota(?,?,?,?)}";
        CallableStatement cs = c.prepareCall(sql);
        cs.setLong(1, jurado.getId());
        cs.setLong(2, quesito.getId());
        cs.setLong(3, escola.getId());
        cs.setFloat(4, nota);
        cs.execute();
        cs.close();
	}
	
	public List<Apuracao> selectAll() throws ClassNotFoundException, SQLException{
		List<Apuracao> apuracoes = new ArrayList<Apuracao>();
		for (int i = 1; i <= 14; i++) {
			Apuracao apuracao = new Apuracao();
			apuracao = selectByEscola(i);
			apuracoes.add(apuracao);
		}
		c.close();
		return apuracoes;
	}
	
	public Apuracao selectByEscola(Integer idEscola) throws ClassNotFoundException, SQLException {
		Escola escola = new Escola();
		escola = new EscolaDAO().selectById(idEscola);
		
		List<Quesito> quesitos = new ArrayList<Quesito>();
		
		for (int i = 1; i <= 9; i++) {
			Quesito quesito = new Quesito();
			quesito = new QuesitoDAO().selectByEscolaAndId(idEscola, i);
			quesitos.add(quesito);
		}
		
		Apuracao apuracao = new Apuracao();
		apuracao.setEscola(escola);
		apuracao.setQuesitos(quesitos);
		
		return apuracao;
	}
	
}
