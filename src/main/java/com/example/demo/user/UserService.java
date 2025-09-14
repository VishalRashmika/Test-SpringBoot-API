package com.example.demo.user;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    private final UserRepository repo;

    public UserService(UserRepository repo) {
        this.repo = repo;
    }

    public List<User> list() {
        return repo.findAll();
    }

    public User get(long id) {
        return repo.findById(id);
    }
}
