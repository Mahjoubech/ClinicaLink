package io.github.Mahjoubech.clinicalink.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "liste_attente")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ListAttente {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @OneToOne
    @JoinColumn(name = "patient_id",nullable = false,unique = true)
    private Patient patient;

    @CreationTimestamp
    @Column(name = "arrival_Time",nullable = false)
    private LocalDateTime arrivalTime;

    public ListAttente(Patient patient){
        this.patient = patient;
    }
}
