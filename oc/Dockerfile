# Build a working Open Context deployment from a dockerfile
# Example invocation:
#
# DOCKER_BUILDKIT=1 docker build --ssh github=~/.ssh/oc_docker_id_rsa -t buildtest .

ARG GIT_BRANCH
ENV GIT_BRANCH=${GIT_BRANCH}
ENV OC_FOLDER=/open-context-py

# Start with Ubuntu 20
FROM ubuntu:20.04
USER root

# Do the apt installation also install git
RUN apt-get update
RUN apt-get install -y make software-properties-common
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends gcc
RUN apt-get install -y --no-install-recommends build-essential
RUN apt-get install -y --no-install-recommends mime-support
RUN apt-get install -y --no-install-recommends libgdal-dev
RUN apt-get install -y --no-install-recommends nano
RUN apt-get update --fix-missing && apt-get install -y git


# For some reason, I can't clone a repo from Github this way, leave it for now.
# Set up SSH key directories, needed for interacting with GitHub
# RUN mkdir -p 700 /root/.ssh
# RUN chmod 700 /root/.ssh
# ARG SSH_PRIVATE_KEY
# RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
# Github requires a private key with strict permission settings
# RUN chmod 400 /root/.ssh/id_rsa
# RUN ls -la /root/.ssh/
# RUN touch 600 /root/.ssh/known_hosts
# RUN chmod 600 /root/.ssh/known_hosts
# RUN ssh-keyscan github.com > /root/.ssh/known_hosts
# RUN printf "Host github.com\nHostName github.com\nUser git\nIdentitiesOnly yes\nIdentityFile ~/.ssh/id_rsa\n" > /root/.ssh/config
# RUN chmod 600 /root/.ssh/config
# RUN cat /root/.ssh/config

# Now install components required to run Open Context
# We will probably need to use these eventually, so make sure this works
# then possibly comment out.
# RUN apt-get update
# RUN apt-get install -y nodejs
# RUN apt-get install -y npm
# RUN npm install --global yarn


# Install the postgres client
RUN apt-get update
RUN apt-get install -y postgresql-client

# Install the redis cache
# RUN apt-get update
# RUN apt-get install -y redis-server
# RUN redis-server &


FROM python:3.10
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Now install pip
# RUN apt-get install -y python3-pip
# RUN groupadd -r oc
# RUN useradd -m -r -g oc -G sudo oc
# USER oc
# ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip

 # WORKDIR /home/oc
# Clone the Open Context git repo, checkout the desired branch
RUN git clone https://github.com/ekansa/open-context-py.git

WORKDIR ${OC_FOLDER}
RUN cd open-context-py; git checkout origin/${GIT_BRANCH};
RUN git reset --hard origin/${GIT_BRANCH};
RUN pip install -r ${OC_FOLDER}/requirements.txt

COPY /secrets/secrets.json ${OC_FOLDER}/secrets.json

# COPY static/ open-context-py/static
RUN mkdir -p ${OC_FOLDER}/file_cache
RUN mkdir -p ${OC_FOLDER}/logs
RUN echo "Start of error logs...\n" > ${OC_FOLDER}/logs/error.log

COPY /oc/entrypoint.sh ${APP_ROOT}/entrypoint.sh
RUN chmod -R 700 ${APP_ROOT}/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["run_oc"]
WORKDIR ${OC_FOLDER}

# Expose ports.
# Open Context Django
EXPOSE 8000
# Postgres
EXPOSE 5432
# Refine
EXPOSE 3333
# Solr
EXPOSE 8983
# Redis
EXPOSE 6379
