package com.example.demo.user;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class UserRepository {

    private final JdbcTemplate jdbc;

    public UserRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    private static final RowMapper<User> USER_ROW_MAPPER = new RowMapper<>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new User(
                    rs.getLong("id"),
                    rs.getString("first_name"),
                    rs.getString("last_name"),
                    rs.getString("email")
            );
        }
    };

    public List<User> findAll() {
        return jdbc.query(
                "SELECT id, first_name, last_name, email FROM users ORDER BY id",
                USER_ROW_MAPPER
        );
    }

    public User findById(long id) {
        return jdbc.query(
                "SELECT id, first_name, last_name, email FROM users WHERE id = ?",
                USER_ROW_MAPPER,
                id
        ).stream().findFirst().orElse(null);
    }
}