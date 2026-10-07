package com.telemedicina.domain.model;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class User {
    private final UUID id;
    private String email;
    private String password;
    private Set<Role> roles;
    private UserStatus status;

    public User(UUID id, String email, String password, Set<Role> roles, UserStatus status) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.roles = roles != null ? roles : new HashSet<>();
        this.status = status;
    }

    public UUID getId() { return id; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public Set<Role> getRoles() { return roles; }
    public UserStatus getStatus() { return status; }

    public void changePassword(String newPassword) {
        this.password = newPassword;
    }

    public void assignRole(Role role) {
        this.roles.add(role);
    }
}
