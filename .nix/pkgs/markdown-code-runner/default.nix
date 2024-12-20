{
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "markdown-code-runner";
  version = "2.1.0";
  pyproject = true;

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-rsxWEh6+zLKpp06oGHg0hss6ZFfsXanuKmSk/IgzvPk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools_scm
  ];

  propagatedBuildInputs = [
  ];

  meta = with lib; {
    description = "Automatically execute code blocks within a Markdown file and update the output in-place";
    homepage = "https://github.com/basnijholt/markdown-code-runner";
    license = licenses.mit;
    maintainers = with maintainers; [ jraygauthier ];
    mainProgram = "markdown-code-runner";
  };
}
