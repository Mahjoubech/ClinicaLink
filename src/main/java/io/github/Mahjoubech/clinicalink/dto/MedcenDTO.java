package io.github.Mahjoubech.clinicalink.dto;

import io.github.Mahjoubech.clinicalink.enums.Role;

public class MedcenDTO {
    private String nomComplet;
    private String email;
    private String tele;
    private String password;
    private Role role;
    private String specialite;
    private double tarif;

    public MedcenDTO(String nomComplet, String email, String tele,String password ,  Role role ) {

        this.nomComplet = nomComplet;
        this.email = email;
        this.tele = tele;
        this.password = password;
        this.role = role;

    }
    public String getNomComplet() { return nomComplet; }
    public String getEmail() { return email; }
    public String getTele() { return tele; }
    public String getPassword() { return password; }
    public Role getRole() { return role; }
    public String getSpecialite() { return specialite; }
    public double getTarif() { return tarif;}
    public void setSpecialite(String spt){
        this.specialite = spt;}
    public void setTarif(double trf){ this.tarif = trf;}


}
