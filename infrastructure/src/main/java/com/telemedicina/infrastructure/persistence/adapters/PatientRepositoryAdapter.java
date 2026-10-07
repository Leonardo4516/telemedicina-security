package com.telemedicina.infrastructure.persistence.adapters;

import com.telemedicina.domain.patient.model.Patient;
import com.telemedicina.domain.patient.port.PatientRepository;
import com.telemedicina.infrastructure.persistence.entity.PatientJpaEntity;
import com.telemedicina.infrastructure.persistence.repository.PatientJpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class PatientRepositoryAdapter implements PatientRepository {
    private final PatientJpaRepository jpaRepository;

    public PatientRepositoryAdapter(PatientJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Patient save(Patient patient) {
        PatientJpaEntity entity = new PatientJpaEntity();
        entity.setId(patient.getId());
        entity.setUserId(patient.getUserId());
        entity.setDocumentTypeId(patient.getDocumentTypeId());
        entity.setDocumentNumber(patient.getDocumentNumber());
        entity.setFirstName(patient.getFirstName());
        entity.setMiddleName(patient.getMiddleName());
        entity.setLastName(patient.getLastName());
        entity.setSecondLastName(patient.getSecondLastName());
        entity.setBirthDate(patient.getBirthDate());
        entity.setBiologicalSexId(patient.getBiologicalSexId());
        entity.setEmail(patient.getEmail());
        entity.setPhone(patient.getPhone());
        entity.setAddress(patient.getAddress());
        entity.setActive(patient.isActive());
        entity.setCreatedAt(LocalDateTime.now());
        entity.setUpdatedAt(LocalDateTime.now());

        PatientJpaEntity saved = jpaRepository.save(entity);
        return toDomain(saved);
    }

    @Override
    public Optional<Patient> findById(UUID id) {
        return jpaRepository.findById(id).map(this::toDomain);
    }

    @Override
    public Optional<Patient> findByDocumentNumber(String documentNumber) {
        return jpaRepository.findByDocumentNumber(documentNumber).map(this::toDomain);
    }

    @Override
    public List<Patient> findAll() {
        return jpaRepository.findAll().stream().map(this::toDomain).toList();
    }

    private Patient toDomain(PatientJpaEntity e) {
        return new Patient(
                e.getId(),
                e.getUserId(),
                e.getDocumentTypeId(),
                e.getDocumentNumber(),
                e.getFirstName(),
                e.getMiddleName(),
                e.getLastName(),
                e.getSecondLastName(),
                e.getBirthDate(),
                e.getBiologicalSexId(),
                e.getEmail(),
                e.getPhone(),
                e.getAddress(),
                e.isActive()
        );
    }
}
