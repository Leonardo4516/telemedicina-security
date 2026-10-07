package com.telemedicina.application.dto;

import java.util.UUID;

public record RoleResponse(UUID id, String name, String authority) {}
