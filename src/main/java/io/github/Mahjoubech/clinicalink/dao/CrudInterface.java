package io.github.Mahjoubech.clinicalink.dao;

import java.util.List;
import java.util.Optional;

public interface CrudInterface <T>{
        T save(T t);
        void delete(String id);
        T update(T t);
        Optional<T> findById(String id);
        List<T> findAll();

}
