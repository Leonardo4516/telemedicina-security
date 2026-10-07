package com.telemedicina.application.usecase;

import com.telemedicina.application.dto.LoginRequest;
import com.telemedicina.application.dto.LoginResponse;
import com.telemedicina.domain.exceptions.InvalidCredentialsException;
import com.telemedicina.domain.model.RefreshToken;
import com.telemedicina.domain.model.User;
import com.telemedicina.domain.ports.PasswordService;
import com.telemedicina.domain.ports.RefreshTokenRepository;
import com.telemedicina.domain.ports.TokenService;
import com.telemedicina.domain.ports.UserRepository;

import java.time.LocalDateTime;
import java.util.UUID;

public class LoginUseCase {
    private final UserRepository userRepository;
    private final PasswordService passwordService;
    private final TokenService tokenService;
    private final RefreshTokenRepository refreshTokenRepository;

    public LoginUseCase(UserRepository userRepository,
                        PasswordService passwordService,
                        TokenService tokenService,
                        RefreshTokenRepository refreshTokenRepository) {
        this.userRepository = userRepository;
        this.passwordService = passwordService;
        this.tokenService = tokenService;
        this.refreshTokenRepository = refreshTokenRepository;
    }

    public LoginResponse execute(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new InvalidCredentialsException("Credenciales inválidas"));

        if (!passwordService.matches(request.password(), user.getPassword())) {
            throw new InvalidCredentialsException("Credenciales inválidas");
        }

        String accessToken = tokenService.generateAccessToken(user);
        String refreshTokenString = tokenService.generateRefreshToken(user);

        RefreshToken refreshToken = new RefreshToken(
                UUID.randomUUID(),
                user.getId(),
                refreshTokenString,
                LocalDateTime.now().plusDays(7),
                false
        );
        refreshTokenRepository.save(refreshToken);

        return new LoginResponse(accessToken, refreshTokenString, "Bearer", 900);
    }
}
