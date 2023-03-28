class School {
  final String nomAr;
  final String nomFr;
  final String nomDr;
  final int phoneDr;
  final int numero;
  final int annee;
  final String adresse;

  School(this.nomAr, this.nomFr, this.nomDr, this.phoneDr, this.numero,
      this.annee, this.adresse);

  School.empty()
      : nomAr = '',
        nomFr = '',
        nomDr = '',
        phoneDr = 0,
        numero = 0,
        annee = 0,
        adresse = '';
}
