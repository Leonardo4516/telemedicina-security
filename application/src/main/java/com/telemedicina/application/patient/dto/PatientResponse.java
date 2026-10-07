package com.telemedicina.application.patient.dto;

import java.time.LocalDate;
import java.util.UUID;

public record PatientResponse(
        UUID id,
        UUID userId,
        UUID documentTypeId,
        String documentNumber,
        String fullName,
        LocalDate birthDate,
        String email,
        String phone,
        String address,
        boolean active
) {}
