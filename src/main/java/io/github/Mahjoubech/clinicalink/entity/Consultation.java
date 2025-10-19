package io.github.Mahjoubech.clinicalink.entity;

import com.mysql.cj.protocol.ColumnDefinition;
import io.github.Mahjoubech.clinicalink.enums.StatusRendezVous;
import io.github.Mahjoubech.clinicalink.utils.Helper;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="consultations")
public class Consultation {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "patient_id",nullable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "generalist_id",nullable = false)
    private Generaliste generalist;

    private String motive;
    private String observations;
    private double cost = 150.00;

    @Column(columnDefinition = "TEXT")
    private String diagnosis;

    @Column(columnDefinition = "TEXT")
    private String treatment;

    @Enumerated(EnumType.STRING)
    private StatusRendezVous status = StatusRendezVous.EN_COURS;
    @CreationTimestamp
    private LocalDateTime createdAt;

    public String getFormattedCreatedAt(){
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")) : "";
    }

    public Consultation(Patient patient,Generaliste generalist,String motive,String observations){
        this.id = Helper.generateConsultationCode();
        this.patient = patient;
        this.generalist = generalist;
        this.motive = motive;
        this.observations = observations;
    }

}