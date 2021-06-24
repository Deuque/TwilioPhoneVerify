class EmailChannelConfiguration {
  String from;
  String from_name;
  String template_id;
  String usernameSubstitution;

  EmailChannelConfiguration(
      {this.from, this.from_name, this.template_id, this.usernameSubstitution});

  Map<String, dynamic> toMap() {
    return {
      'from': this.from,
      'from_name': this.from_name,
      'template_id': this.template_id,
      'substitutions': {
        if (this.usernameSubstitution != null)
          "username": this.usernameSubstitution
      }
    };
  }
}
