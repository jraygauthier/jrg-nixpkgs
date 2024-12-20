{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "node-bcat";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "kessler";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bSVLcLhEPKvC/YFKW19EGJ3MdgRya5kY6rpCiWvCwGw=";
  };

  npmDepsHash = "sha256-+rTuJeN0752YFCn2ymLWJ905sLHboRQMiyky3dGMwkg=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Pipe to the browser utility, Very useful for log tail fun :)";
    homepage = "https://github.com/kessler/node-bcat";
    license = licenses.mit;
    maintainers = with maintainers; [ jraygauthier ];
    mainProgram = "bcat";
  };
}
