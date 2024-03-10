FROM python:3.11-slim as base

COPY requirements.txt .
COPY convert.sh .
RUN chmod u+x convert.sh
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN apt-get  --assume-yes update
RUN apt-get  --assume-yes install texlive-xetex
WORKDIR /data

CMD [ "convert.sh" ]
