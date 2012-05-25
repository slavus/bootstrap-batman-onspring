package net.slavus.repository;

import net.slavus.model.Task;

import org.springframework.data.jpa.repository.JpaRepository;

public interface TasksRepository extends JpaRepository<Task, Long> {
    Task findByDescription(String description);
}
