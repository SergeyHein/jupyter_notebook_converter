FROM python:3.11-slim as base

COPY requirements.txt .
COPY ./src/convert.sh .
RUN chmod u+x convert.sh
RUN apt-get  --assume-yes update
RUN apt-get  --assume-yes install texlive-xetex
RUN apt-get  --assume-yes install pandoc
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

WORKDIR /data

CMD [ "convert.sh" ]
