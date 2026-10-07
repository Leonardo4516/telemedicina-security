package com.telemedicina.domain.ports;

import com.telemedicina.domain.model.Role;

import java.util.Optional;
import java.util.UUID;

public interface RoleRepository {
    Optional<Role> findByName(String name);
    Optional<Role> findById(UUID id);
    Role save(Role role);
}
