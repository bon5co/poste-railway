# poste-railway

[Poste.io](https://poste.io) 2.5.22 (open-source all-in-one mail server) packaged for Railway.

Built on the upstream `analogic/poste.io` image, pinned by digest. Changes:

- `HTTPS=OFF` and `HTTP_PORT=$PORT`: the Railway edge terminates TLS, and Railway's healthcheck
  dials the injected `PORT`.
- `DISABLE_CLAMAV=TRUE`: ClamAV alone needs over a gigabyte of resident memory. Rspamd stays on.
- An s6 service (`railway-bootstrap`) answers the install wizard once from variables
  (`POSTE_HOSTNAME`, `POSTE_ADMIN_EMAIL`, `POSTE_ADMIN_PASSWORD`). The wizard counts as finished when
  `/data/server.ini` exists, so a redeploy with the volume attached skips it. If
  `POSTE_ADMIN_PASSWORD` is unset the wizard is left for the browser.

Mount a volume at `/data`.

Image: `ghcr.io/bon5co/poste:2.5.22`, built by GitHub Actions on push to `main`.

Poste.io is a product of Analogic; this repo only wraps their image. MIT licence covers the wrapper
files, not the upstream software.
