FROM ubuntu:latest

# Préparation de l'environnement
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends curl nodejs git libssl-dev libffi-dev ca-certificates \
    && useradd -m docker

# Déclaration et passage des variables
ARG GH_TOKEN
ARG GH_OWNER
ARG GH_REPOSITORY
ARG GH_IS_ORGANISATION
ENV GH_TOKEN=${GH_TOKEN}
ENV GH_OWNER=${GH_OWNER}
ENV GH_REPOSITORY=${GH_REPOSITORY}
ENV GH_IS_ORGANISATION=${GH_IS_ORGANISATION}

# Préparation et installation du GitHub Actions Runner
RUN mkdir /home/docker/actions-runner && chown docker:docker /home/docker/actions-runner
USER docker
WORKDIR /home/docker/actions-runner
RUN curl -o actions-runner-linux-x64-2.312.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.312.0/actions-runner-linux-x64-2.312.0.tar.gz \
    && echo "85c1bbd104d539f666a89edef70a18db2596df374a1b51670f2af1578ecbe031  actions-runner-linux-x64-2.312.0.tar.gz" | shasum -a 256 -c \
    && tar xzf ./actions-runner-linux-x64-2.312.0.tar.gz

# Configuration dynamique du runner avec vérification des conditions
RUN if [ "${GH_IS_ORGANISATION}" = "true" ]; then \
        if [ -z "${GH_REPOSITORY}" ]; then \
            ./config.sh --unattended --url https://github.com/${GH_OWNER} --token ${GH_TOKEN}; \
        else \
            ./config.sh --unattended --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${GH_TOKEN}; \
        fi \
    else \
        if [ -z "${GH_REPOSITORY}" ]; then \
            echo "GH_REPOSITORY est obligatoire lorsque GH_IS_ORGANISATION est défini sur false." && exit 1; \
        else \
            ./config.sh --unattended --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${GH_TOKEN}; \
        fi \
    fi

# Définition du répertoire de travail et de la commande par défaut
WORKDIR /home/docker
CMD ["/home/docker/actions-runner/run.sh"]
