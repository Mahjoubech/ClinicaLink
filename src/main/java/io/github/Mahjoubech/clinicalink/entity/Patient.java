package io.github.Mahjoubech.clinicalink.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "patients")
@ToString(exclude = {"vitalSigns"})
public class Patient implements Serializable {

    @Id
    @Column(length = 50)
    private String id;

    private String nameComplet;
    private LocalDate birthDate;
    private String socialSecurityNumber;
    private String phone;

    @Column(unique = true)
    private String email;

    @Column(length = 2000)
    private String antecedents;

    @Column(length = 1000)
    private String allergies;

    @Column(length = 2000)
    private String traitementsEnCours;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<VitalSigns> vitalSigns;


    public Patient(String id , String nameComplet, LocalDate birthDate, String socialSecurityNumber, String phone,
                   String email, String antecedents, String allergies,
                   String traitementsEnCours) {
        this.id = id;
        this.nameComplet = nameComplet;
        this.birthDate = birthDate;
        this.socialSecurityNumber = socialSecurityNumber;
        this.phone = phone;
        this.email = email;
        this.antecedents = antecedents;
        this.allergies = allergies;
        this.traitementsEnCours = traitementsEnCours;
    }
}
