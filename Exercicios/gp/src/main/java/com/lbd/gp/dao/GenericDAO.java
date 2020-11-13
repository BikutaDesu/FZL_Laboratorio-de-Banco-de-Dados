package com.lbd.gp.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDAO {

	private Connection c;
	
	public Connection getConnection() throws ClassNotFoundException, SQLException {
		
		String hostName = "127.0.0.1";
        String dbName ="gp";
        String user ="sa";
        String senha ="Victor@123";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        c = DriverManager.getConnection(String.format("jdbc:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s;", hostName, dbName, user, senha));

        return c;
	}
	
}
