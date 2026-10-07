package com.telemedicina.domain.ports;

import com.telemedicina.domain.model.User;

import java.util.Map;

public interface TokenService {
    String generateAccessToken(User user);
    String generateRefreshToken(User user);
    boolean validateToken(String token);
    String getUserIdFromToken(String token);
    String getEmailFromToken(String token);
    Map<String, Object> getClaimsFromToken(String token);
}
