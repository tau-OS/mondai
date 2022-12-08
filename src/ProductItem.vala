enum Mondai.Product {
  HELIUM_SHELL,
  FYRA_ACCOUNTS,
  FERMION,
  ABACUS,
  MODI,
  ENIGMA,
  KAIROS,
  BUDS,
  VICTROLA,
  NIXIE;

  public string id() {
    switch (this) {
      case HELIUM_SHELL:
        return "helium-shell";
      case FYRA_ACCOUNTS:
        return "fyra-accounts";
      case FERMION:
        return "fermion";
      case ABACUS:
        return "abacus";
      case MODI:
        return "modi";
      case ENIGMA:
        return "enigma";
      case KAIROS:
        return "kairos";
      case BUDS:
        return "buds";
      case VICTROLA:
        return "victrola";
      case NIXIE:
        return "nixie";
      default:
        return "";
    }
  }

  public string title() {
    switch (this) {
      case HELIUM_SHELL:
        return "Helium Shell";
      case FYRA_ACCOUNTS:
        return "Fyra Accounts";
      case FERMION:
        return "Fermion";
      case ABACUS:
        return "Abacus";
      case MODI:
        return "Modi";
      case ENIGMA:
        return "Enigma";
      case KAIROS:
        return "Kairos";
      case BUDS:
        return "Buds";
      case VICTROLA:
        return "Victrola";
      case NIXIE:
        return "Nixie";
      default:
        return "";
    }
  }

  public string description() {
    switch (this) {
      case HELIUM_SHELL:
        return "The tauOS desktop enviroment";
      case FYRA_ACCOUNTS:
        return "One account, for all your devices";
      case FERMION:
        return "Use the command line";
      case ABACUS:
        return "Calculate stuff";
      case MODI:
        return "Display pictures";
      case ENIGMA:
        return "A simple text editor";
      case KAIROS:
        return "Check the weather outside";
      case BUDS:
        return "A contacts app";
      case VICTROLA:
        return "Play your music, in an elegant way";
      case NIXIE:
        return "A simple clock app";
      default:
        return "";
    }
  }
}

class Mondai.ProductItem : He.MiniContentBlock {
  private Product _product;
  public Product product {
    get {
      return _product;
    }

    set {
      this.title = value.title();
      this.subtitle = value.description();
      this._product = value;
    }
  }
}