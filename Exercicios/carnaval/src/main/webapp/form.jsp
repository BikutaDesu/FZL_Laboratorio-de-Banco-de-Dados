<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Inserir notas</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
	crossorigin="anonymous">
</head>
<body>
	<section class="container">
		<div class="jumbotron">
			<h1 class="display-3">Carnaval 2014</h1>
			<p class="lead">Apuração das notas</p>
			<hr class="my-4">
			<p>Os jurados, notas e quesitos são atualizados automaticamente</p>
			<a class="btn btn-primary btn-lg" href="/carnaval" role="button">Voltar
				para o ranking</a>
		</div>
		<form action="/carnaval/inserir" method="post">
			<div class="form-group">
				<label for="escolaSelect">Escola</label> <select
					class="form-control" id="escolaSelect" name="escolaSelect">
					<c:if test="${escolas != null }">
						<c:forEach var="escola" items="${escolas}">
							<option value="${escola.getId()}">${escola.getNome()}</option>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<div class="form-group">
				<label for="juradoSelect">Jurado</label> <select
					class="form-control" id="juradoSelect" name="juradoSelect">
					<c:if test="${jurados != null }">
						<c:forEach var="jurado" items="${jurados}">
							<option value="${jurado.getId()}">${jurado.getNome()}</option>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<div class="form-group">
				<label for="quesitoSelect">Quesito</label> <select
					class="form-control" id="quesitoSelect" name="quesitoSelect">
					<c:if test="${quesitos != null }">
						<c:forEach var="quesito" items="${quesitos}">
							<option value="${quesito.getId()}">${quesito.getNome()}</option>
						</c:forEach>
					</c:if>
				</select>
			</div>
			<div class="form-group">
				<label for="inputNota" />Nota</label> <input type="text"
					class="form-control" id="inputNota" name="inputNota">
			</div>
			<button type="submit" class="btn btn-primary">Inserir nota</button>
		</form>
		<c:if test="${saida != null }">
			<div class="alert alert-danger" role="alert">
				<c:out value="${saida }"></c:out>
			</div>
		</c:if>
	</section>
</body>
</html>