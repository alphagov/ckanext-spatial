FROM ckan/ckan-dev:2.10

ENV SRC /srv/app/src

RUN apk add --no-cache \
    geos \
    geos-dev \
    proj-util \
    proj-dev \
    libxml2 \
    libxslt \
    gcc \
    libxml2-dev \
    libxslt-dev

WORKDIR $SRC

COPY . $SRC/ckanext-spatial/

RUN echo "Installing harvester" && \
    git clone --depth 1 --branch v1.5.6 https://github.com/ckan/ckanext-harvest && \
    cd ckanext-harvest && \
    pip install --upgrade pip && \
    pip install -r pip-requirements.txt && \
    pip install -r dev-requirements.txt && \
    pip install -e .

RUN cd ckanext-spatial && \
    pip install -r requirements.txt && \
    pip install -e . && \
    sed -i -e 's|use = config:.*|use = config:/srv/app/src/ckan/test-core.ini|' test.ini

RUN cd ckan && \
    sed -i -e 's|sqlalchemy.url =.*|sqlalchemy.url = postgresql://ckan_default:pass@db/ckan_test|' test-core.ini && \
    sed -i -e 's|solr_url =.*|solr_url = http://solr:8983/solr/ckan|' test-core.ini && \
    sed -i -e 's|ckan.redis.url =.*|ckan.redis.url = redis://redis:6379/1|' test-core.ini

WORKDIR $SRC/ckanext-spatial/

RUN ckan -c test.ini db init
