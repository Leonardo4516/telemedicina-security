package com.telemedicina.infrastructure.persistence.adapters;

import com.telemedicina.domain.model.Role;
import com.telemedicina.domain.model.User;
import com.telemedicina.domain.ports.UserRepository;
import com.telemedicina.infrastructure.persistence.entity.RoleEntity;
import com.telemedicina.infrastructure.persistence.entity.UserEntity;
import com.telemedicina.infrastructure.persistence.repository.RoleJpaRepository;
import com.telemedicina.infrastructure.persistence.repository.UserJpaRepository;

import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

public class UserRepositoryAdapter implements UserRepository {
    private final UserJpaRepository userJpaRepository;
    private final RoleJpaRepository roleJpaRepository;

    public UserRepositoryAdapter(UserJpaRepository userJpaRepository, RoleJpaRepository roleJpaRepository) {
        this.userJpaRepository = userJpaRepository;
        this.roleJpaRepository = roleJpaRepository;
    }

    @Override
    public User save(User user) {
        Set<RoleEntity> roleEntities = user.getRoles().stream()
                .map(r -> roleJpaRepository.findById(r.getId())
                        .orElseGet(() -> new RoleEntity(r.getId(), r.getName(), r.getAuthority())))
                .collect(Collectors.toSet());

        UserEntity entity = new UserEntity(
                user.getId(),
                user.getEmail(),
                user.getPassword(),
                roleEntities,
                user.getStatus()
        );
        UserEntity saved = userJpaRepository.save(entity);
        return toDomain(saved);
    }

    @Override
    public Optional<User> findById(UUID id) {
        return userJpaRepository.findById(id).map(this::toDomain);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userJpaRepository.findByEmail(email).map(this::toDomain);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userJpaRepository.existsByEmail(email);
    }

    private User toDomain(UserEntity entity) {
        Set<Role> roles = entity.getRoles().stream()
                .map(r -> new Role(r.getId(), r.getName(), r.getAuthority()))
                .collect(Collectors.toSet());

        return new User(
                entity.getId(),
                entity.getEmail(),
                entity.getPassword(),
                roles,
                entity.getStatus()
        );
    }
}
