package com.telemedicina.infrastructure.adapters.in.rest.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.UUID;

public record CreatePatientRequest(
        UUID userId,
        @NotNull UUID documentTypeId,
        @NotBlank String documentNumber,
        @NotBlank String firstName,
        String middleName,
        @NotBlank String lastName,
        String secondLastName,
        @NotNull LocalDate birthDate,
        @NotNull UUID biologicalSexId,
        String email,
        String phone,
        String address
) {}
