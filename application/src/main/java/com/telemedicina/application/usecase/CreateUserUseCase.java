package com.telemedicina.application.usecase;

import com.telemedicina.application.dto.RegisterRequest;
import com.telemedicina.application.dto.RoleResponse;
import com.telemedicina.application.dto.UserResponse;
import com.telemedicina.domain.exceptions.DomainException;
import com.telemedicina.domain.model.Role;
import com.telemedicina.domain.model.User;
import com.telemedicina.domain.model.UserStatus;
import com.telemedicina.domain.ports.PasswordService;
import com.telemedicina.domain.ports.RoleRepository;
import com.telemedicina.domain.ports.UserRepository;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class CreateUserUseCase {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordService passwordService;

    public CreateUserUseCase(UserRepository userRepository,
                             RoleRepository roleRepository,
                             PasswordService passwordService) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordService = passwordService;
    }

    public UserResponse execute(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new DomainException("El email ya está registrado");
        }

        Role defaultRole = roleRepository.findByName("USER")
                .orElseGet(() -> roleRepository.save(new Role(UUID.randomUUID(), "USER", "ROLE_USER")));

        Set<Role> roles = new HashSet<>();
        roles.add(defaultRole);

        String encodedPassword = passwordService.encode(request.password());
        User newUser = new User(
                UUID.randomUUID(),
                request.email(),
                encodedPassword,
                roles,
                UserStatus.ACTIVE
        );

        User saved = userRepository.save(newUser);
        return new UserResponse(
                saved.getId(),
                saved.getEmail(),
                saved.getRoles().stream().map(r -> new RoleResponse(r.getId(), r.getName(), r.getAuthority())).toList(),
                saved.getStatus().name()
        );
    }
}
