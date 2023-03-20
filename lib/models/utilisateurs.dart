class Utilisateur {
  final String nom;
  final String phone;
  final String code;
  final String ask;
  final String answer;

  Utilisateur(this.nom, this.phone, this.code, this.ask, this.answer);

  Utilisateur.empty()
      : nom = '',
        phone = '',
        code = '',
        ask = '',
        answer = '';
}
