FROM python

RUN apt update -y && \
    apt install -y cmake make expat libopenscap8 libxml2-utils ninja-build xsltproc && \
    pip install PyYAML Jinja2
