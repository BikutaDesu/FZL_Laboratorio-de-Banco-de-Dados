package com.lbd.gp.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.lbd.gp.model.Prova;

@Repository
public interface ProvaRepository extends JpaRepository<Prova, Pageable> {
	
}
