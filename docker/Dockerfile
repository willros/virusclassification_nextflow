FROM mambaorg/micromamba:0.25.1
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
USER root 
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes
WORKDIR /app