package com.telemedicina.application.patient.command;

import java.time.LocalDate;
import java.util.UUID;

public record RegisterPatientCommand(
        UUID userId,
        UUID documentTypeId,
        String documentNumber,
        String firstName,
        String middleName,
        String lastName,
        String secondLastName,
        LocalDate birthDate,
        UUID biologicalSexId,
        String email,
        String phone,
        String address
) {}
