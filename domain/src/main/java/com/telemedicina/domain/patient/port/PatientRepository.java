package com.telemedicina.domain.patient.port;

import com.telemedicina.domain.patient.model.Patient;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PatientRepository {
    Patient save(Patient patient);
    Optional<Patient> findById(UUID id);
    Optional<Patient> findByDocumentNumber(String documentNumber);
    List<Patient> findAll();
}
