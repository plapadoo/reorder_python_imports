let
  src = builtins.fetchTarball {
    name = "nixos-unstable";
    url = https://github.com/nixos/nixpkgs/archive/fa82ebccf66eef185d063d49a9e294a7a1e15d36.tar.gz;
    # git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable
    sha256 = "1clkiyx8qljwq0b09l9l6qls8m0ffz059qfkraxzhmjgzj7mpkdw";
  };
  pkgs = import src {};
  packageOverrides = self: super: {
    aspy_refactorimports = super.buildPythonPackage rec {
        pname = "aspy.refactor_imports";
        version = "0.5.3";

        src = self.fetchPypi {
          sha256 = "082l3wskijkaq1y3dn18na833ii4bk9zxcdy61rkzzis96gbr3zi";
          inherit pname version;
        };

        buildInputs = [ ];
        propagatedBuildInputs = [ super.cached-property ];
    };
  };
  allPkgs = pkgs;
  python = pkgs.python3.override { inherit packageOverrides; };
  pythonPkgs = python.pkgs;
in
pythonPkgs.buildPythonPackage rec {
  pname = "reorder_python_imports";
  version = "1.3.6";

  src = ./.;

  buildInputs = [ ];
  doCheck = false;
  propagatedBuildInputs = [ pythonPkgs.aspy_refactorimports ];
}
