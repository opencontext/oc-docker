FROM ubuntu:20.04
# Start with Ubuntu 20

# Build a working Open Context deployment from a dockerfile
USER root

# Do the apt installation also install git
RUN apt-get update && && apt-get install -y --no-install-recommends \
    make software-properties-common \
    curl \
    gcc \
    build-essential \
    mime-support \
    libgdal-dev \
    nano
RUN apt-get update --fix-missing && apt-get install -y git


# Install the postgres client
RUN apt-get update
RUN apt-get install -y postgresql-client

FROM python:3.10
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Make environment variable available when the venv is active.
ARG GIT_BRANCH
ENV OC_FOLDER="/open-context-py"

RUN mkdir -p ${OC_FOLDER}

# ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip

# Clone the Open Context git repo, checkout the desired branch
RUN git clone https://github.com/ekansa/open-context-py.git ${OC_FOLDER}

WORKDIR ${OC_FOLDER}
RUN git pull
RUN git pull
RUN git pull
RUN echo "Open Context repo contents:";
RUN echo "git checkout ${GIT_BRANCH}";
RUN git checkout ${GIT_BRANCH};
RUN pip install -r ${OC_FOLDER}/requirements.txt

COPY /secrets/secrets.json ${OC_FOLDER}/secrets.json

# COPY static/ open-context-py/static
RUN mkdir -p ${OC_FOLDER}/file_cache
RUN mkdir -p ${OC_FOLDER}/logs
RUN echo "Start of error logs...\n" > ${OC_FOLDER}/logs/error.log

COPY /oc/entrypoint.sh ${OC_FOLDER}/entrypoint.sh
RUN chmod -R 700 ${OC_FOLDER}/entrypoint.sh



WORKDIR ${OC_FOLDER}
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
