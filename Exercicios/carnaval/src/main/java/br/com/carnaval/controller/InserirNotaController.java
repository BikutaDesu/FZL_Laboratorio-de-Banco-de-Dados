package br.com.carnaval.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.carnaval.dao.ApuracaoDAO;
import br.com.carnaval.dao.EscolaDAO;
import br.com.carnaval.dao.JuradoDAO;
import br.com.carnaval.dao.QuesitoDAO;
import br.com.carnaval.model.Escola;
import br.com.carnaval.model.Jurado;
import br.com.carnaval.model.Quesito;

@WebServlet("/inserir")
public class InserirNotaController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public InserirNotaController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String saida = "";
		List<Escola> escolas = null;
		List<Jurado> jurados = null;
		List<Quesito> quesitos = null;

		try {
			EscolaDAO escolaDao = new EscolaDAO();
			escolas = escolaDao.selectAll();
			JuradoDAO juradoDao = new JuradoDAO();
			jurados = juradoDao.selectAll();
			QuesitoDAO quesitoDao = new QuesitoDAO();
			quesitos = quesitoDao.selectAll();

		} catch (ClassNotFoundException | SQLException e) {
			saida = e.getMessage();
		} finally {
			RequestDispatcher rd = request.getRequestDispatcher("form.jsp");
			request.setAttribute("escolas", escolas);
			request.setAttribute("jurados", jurados);
			request.setAttribute("quesitos", quesitos);
			rd.forward(request, response);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String saida = "";
		Quesito quesito = new Quesito();
		quesito.setId(Long.parseLong(request.getParameter("quesitoSelect")));
		
		Jurado jurado = new Jurado();
		jurado.setId(Long.parseLong(request.getParameter("juradoSelect")));
		
		Escola escola = new Escola();
		escola.setId(Long.parseLong(request.getParameter("escolaSelect")));
		
		Float nota = Float.parseFloat(request.getParameter("inputNota").replace(',', '.'));
		DecimalFormat df = new DecimalFormat("00.0");
		df.format(nota);
		
		try {
			ApuracaoDAO apuracaoDao = new ApuracaoDAO();
			apuracaoDao.insert(jurado, quesito, escola, nota);
		} catch (ClassNotFoundException | SQLException e) {
			saida = e.getMessage();
			RequestDispatcher rd = request.getRequestDispatcher("/carnaval/inserir");
			request.setAttribute("saida", saida);
			rd.forward(request, response);
		} finally {
			response.sendRedirect("/carnaval");
		}
		
		
		
	}

}
