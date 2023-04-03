class Utilisateur {
   final String nom;
  final String phone;
   final String code;
   final String ask;
   final String answer;
  final String token;
  final bool isNewToken;
  final List schools;

  Utilisateur(this.nom, this.phone, this.code, this.ask, this.answer,
      this.token, this.isNewToken, this.schools);

  Utilisateur.empty()
      : nom = '',
        phone = '',
        code = '',
        ask = '',
        answer = '',
        schools = [],
        token = '',
        isNewToken = false;
}
