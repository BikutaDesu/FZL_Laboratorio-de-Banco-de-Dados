package br.com.exercicio.dao;

import br.com.exercicio.model.Cliente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    private Connection c;

    public ClienteDAO() throws ClassNotFoundException, SQLException {
        GenericDAO gd = new GenericDAO();
        c = gd.getConnection();
    }

    public String inserirCliente(Cliente cliente) throws SQLException {
        String sql = "{CALL sp_inserecliente(?,?,?)}";
        CallableStatement cs = c.prepareCall(sql);
        cs.setString(1, cliente.getNome());
        cs.setString(2, cliente.getTelefone());
        cs.registerOutParameter(3, Types.VARCHAR);
        cs.execute();
        String saida = cs.getString(3);
        cs.close();

        return saida;
    }

    public List<Cliente> buscarClientes() throws SQLException {
        String sql = "SELECT * FROM cliente";
        PreparedStatement ps = c.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        List<Cliente> clientes = new ArrayList<Cliente>();

        while (rs.next()){
            Cliente cliente = new Cliente();
            cliente.setId(rs.getInt("id"));
            cliente.setNome(rs.getString("nome"));
            cliente.setTelefone(rs.getString("telefone"));
            cliente.setDtRegistro(rs.getString("dt_registro"));

            clientes.add(cliente);
        }
        return clientes;
    }
}
