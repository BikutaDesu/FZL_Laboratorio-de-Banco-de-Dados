package br.com.exercicio.controller;

import br.com.exercicio.dao.ClienteDAO;
import br.com.exercicio.model.Cliente;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/inserirCliente")
public class ClienteServlet extends HttpServlet {

    public ClienteServlet() {
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("index.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cliente cliente = new Cliente();
        cliente.setNome(req.getParameter("nome"));
        cliente.setTelefone(req.getParameter("telefone"));

        String saida = "";
        List<Cliente> clientes = null;
        try {
            ClienteDAO clienteDAO = new ClienteDAO();
            saida = clienteDAO.inserirCliente(cliente);
            clientes = clienteDAO.buscarClientes();
        } catch (ClassNotFoundException | SQLException e) {
            saida = e.getMessage();
        } finally {
            RequestDispatcher rd = req.getRequestDispatcher("index.jsp");
            req.setAttribute("saida", saida);
            req.setAttribute("clientes", clientes);
            rd.forward(req, resp);
        }
    }
}
