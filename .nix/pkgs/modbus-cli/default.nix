{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "modbus-cli";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "favalex";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p/UsJEkhGwEsvZg9uN0/Hzjp8s8/H0l/C3MOEOfD2hw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    umodbus
    colorama
  ];

  meta = with lib; {
    description = "Access Modbus devices from the command line";
    homepage = "https://github.com/favalex/modbus-cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
    mainProgram = "modbus";
  };
}
