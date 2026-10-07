package com.telemedicina.application.usecase;

import com.telemedicina.application.dto.RoleResponse;
import com.telemedicina.application.dto.UserResponse;
import com.telemedicina.domain.exceptions.UserNotFoundException;
import com.telemedicina.domain.model.User;
import com.telemedicina.domain.ports.UserRepository;

import java.util.UUID;

public class GetCurrentUserUseCase {
    private final UserRepository userRepository;

    public GetCurrentUserUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserResponse execute(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("Usuario no encontrado"));

        return new UserResponse(
                user.getId(),
                user.getEmail(),
                user.getRoles().stream().map(r -> new RoleResponse(r.getId(), r.getName(), r.getAuthority())).toList(),
                user.getStatus().name()
        );
    }
}
