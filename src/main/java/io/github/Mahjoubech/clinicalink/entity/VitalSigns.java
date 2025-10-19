package io.github.Mahjoubech.clinicalink.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "vitalsigns")
@ToString(exclude = {"patient"})
public class VitalSigns {
    @Id
    private String id;
    private double temperature;
    private double bloodPressure;
    private int heartRate;
    private int respiratoryRate;
    private double height;
    private double weight;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id",nullable = false)
    private Patient patient;
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public String getFormattedCreatedAt(){
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")) : "";
    }
    public VitalSigns(String id ,Patient patient, double bloodPressure, int heartRate,
                      double temperature, int respiratoryRate, double weight, double height) {
        this.id = id;
        this.patient = patient;
        this.bloodPressure = bloodPressure;
        this.heartRate = heartRate;
        this.temperature = temperature;
        this.respiratoryRate = respiratoryRate;
        this.weight = weight;
        this.height = height;
    }





}
