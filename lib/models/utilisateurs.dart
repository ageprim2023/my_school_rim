class Utilisateur {
  late final String nom;
  final String phone;
  late final String code;
  late final String ask;
  late final String answer;
  final String token;
  final bool isNewToken;

  Utilisateur(this.nom, this.phone, this.code, this.ask, this.answer,
      this.token, this.isNewToken);

  Utilisateur.empty()
      : nom = '',
        phone = '',
        code = '',
        ask = '',
        answer = '',
        token = '',
        isNewToken = false;
}
