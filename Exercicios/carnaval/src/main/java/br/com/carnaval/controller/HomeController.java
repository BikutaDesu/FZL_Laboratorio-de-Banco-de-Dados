package br.com.carnaval.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.carnaval.dao.ApuracaoDAO;
import br.com.carnaval.model.Apuracao;

/**
 * Servlet implementation class HomeController
 */
@WebServlet("/")
public class HomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public HomeController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String saida = "";
		List<Apuracao> apuracoes = null;
		try {
			ApuracaoDAO apuracaoDAO = new ApuracaoDAO();
			apuracoes = apuracaoDAO.selectAll();
		} catch (ClassNotFoundException | SQLException e) {
			saida = e.getMessage();
		} finally {

			RequestDispatcher rd = request.getRequestDispatcher("home.jsp");
			request.setAttribute("apuracoes", apuracoes);
			rd.forward(request, response);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

}
