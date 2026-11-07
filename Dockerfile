# Poste.io for Railway: the upstream all-in-one mail server with the Railway defaults baked in and
# the first-run install wizard answered from variables, so a deploy needs no browser step.
FROM analogic/poste.io:2.5.22@sha256:d528c284d754a5e17bc55f854a40bfc2132c72a5dbb2eab142804b0ab410265b
LABEL org.opencontainers.image.source="https://github.com/bon5co/poste-railway"
LABEL org.opencontainers.image.description="Poste.io mail server with Railway defaults and a headless first-run install"
# ClamAV alone holds over a gigabyte of resident memory; Rspamd stays on for spam scoring.
# Any non-empty value switches ClamAV off.
ENV DISABLE_CLAMAV=TRUE
COPY entrypoint.sh /usr/local/bin/railway-entrypoint.sh
COPY rootfs/ /
RUN chmod +x /usr/local/bin/railway-entrypoint.sh /etc/services.d/railway-bootstrap/run
EXPOSE 8080 25 465 587 143 993 110 995 4190
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
