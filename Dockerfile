FROM python:alpine

ARG CELERY_VERSION=5.3.6
ARG FLOWER_VERSION=2.0.1

# Get latest root certificates
RUN apk add --no-cache ca-certificates && update-ca-certificates

# Install the required packages
RUN pip install -U pip setuptools
RUN pip install --no-cache-dir celery==${CELERY_VERSION} flower==${FLOWER_VERSION} redis

# PYTHONUNBUFFERED: Force stdin, stdout and stderr to be totally unbuffered. (equivalent to `python -u`)
# PYTHONHASHSEED: Enable hash randomization (equivalent to `python -R`)
# PYTHONDONTWRITEBYTECODE: Do not write byte files to disk, since we maintain it as readonly. (equivalent to `python -B`)
ENV PYTHONUNBUFFERED=1 PYTHONHASHSEED=random PYTHONDONTWRITEBYTECODE=1

ENV PROJECT_CELERY_BROKER_URL=redis://192.168.23.96:6379/0

# Default port
EXPOSE 5555

# Run as a non-root user by default, run as user with least privileges.
USER nobody

ENTRYPOINT celery --broker=$PROJECT_CELERY_BROKER_URL flower
