FROM python:3.9-slim as builder
RUN apt-get update \
&& apt-get install gcc libpq-dev -y \
&& apt-get clean
WORKDIR app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

FROM gcr.io/distroless/python3
WORKDIR /srv/app/conf/
COPY --from=builder /root/.local /root/.local
COPY app /srv/app
COPY --from=builder /usr/lib/x86_64-linux-gnu/libgmp.so.10 /usr/lib/x86_64-linux-gnu/libhogweed.so.6 /usr/lib/x86_64-linux-gnu/libnettle.so.8 /usr/lib/x86_64-linux-gnu/libtasn1.so.6 /usr/lib/x86_64-linux-gnu/libunistring.so.2 /usr/lib/x86_64-linux-gnu/libidn2.so.0 /usr/lib/x86_64-linux-gnu/libp11-kit.so.0 /usr/lib/x86_64-linux-gnu/libgnutls.so.30 /usr/lib/x86_64-linux-gnu/libsasl2.so.2 /usr/lib/x86_64-linux-gnu/liblber-2.4.so.2 /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 /usr/lib/x86_64-linux-gnu/libkrb5.so.3 /usr/lib/x86_64-linux-gnu/libpq.so.5 /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 /usr/lib/x86_64-linux-gnu/libldap_r-2.4.so.2 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libkeyutils.so.1 /lib/x86_64-linux-gnu/
CMD ["/srv/app/web.py"]
