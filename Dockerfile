# The upstream image is flattened into a single layer on purpose. Its layers carry OCI whiteouts and
# opaque-directory markers (e.g. /opt/admin/config/services_pro.yaml, /opt/admin/src/API/Controller/
# LogController.php, /etc/nginx/*) that Railway's runtime does not honour: the deleted Pro files
# reappear, Symfony fails to compile and the database schema is never created. One layer has no
# whiteouts, so what was deleted upstream stays deleted.
FROM analogic/poste.io:2.5.22@sha256:d528c284d754a5e17bc55f854a40bfc2132c72a5dbb2eab142804b0ab410265b AS upstream

FROM scratch
LABEL org.opencontainers.image.source="https://github.com/bon5co/poste-railway"
LABEL org.opencontainers.image.description="Poste.io mail server with Railway defaults and a headless first-run install"
COPY --from=upstream / /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    APP_ENV=dev \
    MODE=free \
    HTTPS=OFF \
    HTTP_PORT=8080 \
    HTTPS_PORT=443 \
    DISABLE_CLAMAV=TRUE
COPY entrypoint.sh /usr/local/bin/railway-entrypoint.sh
COPY rootfs/ /
RUN chmod +x /usr/local/bin/railway-entrypoint.sh /etc/services.d/railway-bootstrap/run
VOLUME ["/data"]
EXPOSE 8080 25 465 587 143 993 110 995 4190
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
