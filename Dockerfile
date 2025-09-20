FROM python:3.13

# ARG AP_REF=0.6.3

# the current stable AP release has a bug which causes the process to crash,
# so for now, use this ref on main
ARG AP_REF=73718bbd618651d1f75da8382944173cc6295448

ARG LAUNCHER_ARGS="\'Text Client' -- --nogui"
ENV LAUNCHER_ARGS=${LAUNCHER_ARGS}

# clone archipelago
RUN git clone https://github.com/ArchipelagoMW/Archipelago.git /archipelago
WORKDIR /archipelago
RUN git checkout ${AP_REF}

# create venv (required by AP)
RUN python -m venv ./.venv && . .venv/bin/activate

# install deps
RUN python ModuleUpdate.py --yes

# copy custom data
COPY ./archipelago .

# invoke /bin/sh for correct env var expansion
CMD ["/bin/sh", "-c", "python Launcher.py ${LAUNCHER_ARGS}"]
