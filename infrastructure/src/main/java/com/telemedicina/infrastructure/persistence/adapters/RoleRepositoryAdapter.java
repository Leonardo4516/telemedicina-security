package com.telemedicina.infrastructure.persistence.adapters;

import com.telemedicina.domain.model.Role;
import com.telemedicina.domain.ports.RoleRepository;
import com.telemedicina.infrastructure.persistence.entity.RoleEntity;
import com.telemedicina.infrastructure.persistence.repository.RoleJpaRepository;

import java.util.Optional;
import java.util.UUID;

public class RoleRepositoryAdapter implements RoleRepository {
    private final RoleJpaRepository jpaRepository;

    public RoleRepositoryAdapter(RoleJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Optional<Role> findByName(String name) {
        return jpaRepository.findByName(name).map(this::toDomain);
    }

    @Override
    public Optional<Role> findById(UUID id) {
        return jpaRepository.findById(id).map(this::toDomain);
    }

    @Override
    public Role save(Role role) {
        RoleEntity entity = new RoleEntity(role.getId(), role.getName(), role.getAuthority());
        RoleEntity saved = jpaRepository.save(entity);
        return toDomain(saved);
    }

    private Role toDomain(RoleEntity entity) {
        return new Role(entity.getId(), entity.getName(), entity.getAuthority());
    }
}
