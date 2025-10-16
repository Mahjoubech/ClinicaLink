package io.github.Mahjoubech.clinicalink.service;

import io.github.Mahjoubech.clinicalink.dao.MedcenDAO;
import io.github.Mahjoubech.clinicalink.dao.MedcenDaoInterface;
import io.github.Mahjoubech.clinicalink.dto.MedcenDTO;
import io.github.Mahjoubech.clinicalink.entity.Medcen;
import io.github.Mahjoubech.clinicalink.enums.Role;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class MedcenServiceTest {

    private MedcenDaoInterface medcenDAO;
    private MedcenServiceInterface service;

    @BeforeEach
    void setUp() {
        medcenDAO = mock(MedcenDAO.class);
        service = new MedcenService(medcenDAO);
    }

    @Test
    void testEmailExiste() {
        Medcen m1 = new Medcen();
        m1.setEmail("test@example.com");

        when(medcenDAO.findAll()).thenReturn(Arrays.asList(m1));

        assertTrue(service.emailExiste("test@example.com"));
        assertFalse(service.emailExiste("nonexistent@example.com"));
    }

    @Test
    void testRegisterMedcen() {
        MedcenDTO dto = new MedcenDTO("New User", "hh@gmail.com", "+21252633256", "password", Role.INFIRMER);
        when(medcenDAO.findAll()).thenReturn(Arrays.asList());

        boolean result = service.registerMedcen(dto);
        assertTrue(result);
        verify(medcenDAO, times(1)).save(any(Medcen.class));
    }

    @Test
    void testFindByEmail() {
        Medcen m = new Medcen();
        m.setEmail("findme@example.com");

        when(medcenDAO.findAll()).thenReturn(Arrays.asList(m));

        Optional<Medcen> opt = service.findByEmail("findme@example.com");
        assertTrue(opt.isPresent());
        assertEquals("findme@example.com", opt.get().getEmail());
    }

    @Test
    void testDeleteMedcen() {
        Medcen m = new Medcen();
        m.setEmail("delete@example.com");

        when(medcenDAO.findAll()).thenReturn(Arrays.asList(m));

        boolean deleted = service.deleteMedcen("delete@example.com");
        assertTrue(deleted);

        verify(medcenDAO, times(1)).delete(m);
    }
}
