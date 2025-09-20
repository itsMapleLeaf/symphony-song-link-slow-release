FROM python:3.13

# clone archipelago
RUN git clone https://github.com/ArchipelagoMW/Archipelago.git /archipelago
WORKDIR /archipelago

# ARG AP_REF=0.6.3

# the current stable AP release has a bug which causes the process to crash,
# so for now, use this ref on main
ARG AP_REF=73718bbd618651d1f75da8382944173cc6295448
RUN git checkout ${AP_REF}

# create venv (required by AP)
RUN python -m venv ./.venv && . .venv/bin/activate

# install deps
RUN python ModuleUpdate.py --yes

# copy custom data
COPY ./archipelago .

ARG LAUNCHER_COMPONENT="Text Client"
ENV LAUNCHER_COMPONENT=${LAUNCHER_COMPONENT}

ARG LAUNCHER_ARGS=""
ENV LAUNCHER_ARGS=${LAUNCHER_ARGS}

# invoke /bin/sh for correct env var expansion
CMD ["/bin/sh", "-c", "python Launcher.py \"${LAUNCHER_COMPONENT}\" -- --nogui ${LAUNCHER_ARGS}"]
