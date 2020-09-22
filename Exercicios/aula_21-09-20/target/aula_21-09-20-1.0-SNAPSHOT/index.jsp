<%--
  Created by IntelliJ IDEA.
  User: victo
  Date: 9/22/2020
  Time: 2:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Inserir Cliente</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
</head>
<body>
<div class="container">
    <div class="container">
        <form action="inserirCliente" method="post">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" class="form-control" id="nome" name="nome">
            </div>
            <div class="form-group">
                <label for="telefone">Telefone</label>
                <input type="text" class="form-control" id="telefone" name="telefone">
            </div>
            <input type="submit" class="btn btn-primary" name="enviar" id="enviar" value="Enviar">
            <c:if test="${not empty saida}">
                <div class="container">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${saida}"></c:out>
                    </div>
                </div>
            </c:if>
        </form>
    </div>
    <div class="container">
        <c:if test="${clientes != null}">
            <table class="table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Nome</th>
                    <th scope="col">Telefone</th>
                    <th scope="col">Data de Registro</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="cliente" items="${clientes}">
                    <tr>
                        <th scope="row"><c:out value="${cliente.getId()}"/></th>
                        <td><c:out value="${cliente.getNome()}"/></td>
                        <td><c:out value="${cliente.getTelefone()}"/></td>
                        <td><c:out value="${cliente.getDtRegistro()}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>
</body>
</html>
