package com.example.demo.user;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserService svc;

    public UserController(UserService svc) {
        this.svc = svc;
    }

    @GetMapping
    public List<User> all() {
        return svc.list();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> one(@PathVariable long id) {
        User u = svc.get(id);
        return u == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(u);
    }
}
