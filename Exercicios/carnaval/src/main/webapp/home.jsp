<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Carnaval 2014</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
	crossorigin="anonymous">
</head>
<body>
	<section class="container">
		<div class="jumbotron">
			<h1 class="display-3">Carnaval 2014</h1>
			<p class="lead">Ranking das escolas de samba do carnaval de 2014.</p>
			<hr class="my-4">
			<p>Para inserir uma nota clique no link abaixo</p>
			<a class="btn btn-primary btn-lg" href="/carnaval/inserir"
				role="button">Inserir Notas</a>
		</div>
		<c:if test="${apuracoes != null}">
			<c:forEach var="apuracao" items="${apuracoes}">
				<div class="mt-5">
					<p class="display-4"><c:out value="${apuracao.getEscola().getNome() }" /></p>
					<table class="table">
						<thead class="thead-dark">
							<tr>
								<th scope="col">Quesito</th>
								<th scope="col">Nota 1</th>
								<th scope="col">Nota 2</th>
								<th scope="col">Nota 3</th>
								<th scope="col">Nota 4</th>
								<th scope="col">Nota 5</th>
								<th scope="col">Menor nota</th>
								<th scope="col">Maior nota</th>
								<th scope="col">Média Total</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="quesito" items="${apuracao.getQuesitos()}">
							<tr>
								<th scope="row"><c:out value="${quesito.getNome()}"/></th>
								<c:forEach var="nota" items="${quesito.getNotas()}">
									<td><c:out value="${nota}"/></td>
								</c:forEach>
								<td><c:out value="${quesito.getMenorNota()}" /></td>
								<td><c:out value="${quesito.getMaiorNota()}" /></td>
								<td><c:out value="${quesito.getNotaTotal()}" /></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</c:forEach>
		</c:if>




	</section>
</body>
</html>