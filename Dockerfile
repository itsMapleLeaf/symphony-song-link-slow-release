FROM python:3.13

# ARG AP_REF=0.6.3

# the current stable AP release has a bug which causes the process to crash,
# so for now, use this ref on main
ARG AP_REF=73718bbd618651d1f75da8382944173cc6295448

ARG SLOW_RELEASE_TIME=0
ENV SLOW_RELEASE_TIME=${SLOW_RELEASE_TIME}

# clone archipelago
RUN git clone https://github.com/ArchipelagoMW/Archipelago.git /archipelago
WORKDIR /archipelago
RUN git checkout ${AP_REF}

# create venv
RUN python -m venv ./.venv && . .venv/bin/activate

# install deps
RUN python ModuleUpdate.py --yes

# copy custom data
COPY ./archipelago .

# invoke /bin/sh for correct env var expansion
CMD ["/bin/sh", "-c", "python Launcher.py 'Slow Release Client' -- --nogui --name SongLink --connect archipelago.gg:50299 --time ${SLOW_RELEASE_TIME}"]
