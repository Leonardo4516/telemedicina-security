package com.telemedicina.domain.model;

import java.util.UUID;

public class Role {
    private final UUID id;
    private final String name;
    private final String authority;

    public Role(UUID id, String name, String authority) {
        this.id = id;
        this.name = name;
        this.authority = authority;
    }

    public UUID getId() { return id; }
    public String getName() { return name; }
    public String getAuthority() { return authority; }
}
