# -*- coding: utf-8 -*-

import pytest

from ckan import model
from ckan.model import Session, meta
from ckanext.spatial.geoalchemy_common import postgis_version
from ckanext.spatial.model.package_extent import setup as spatial_db_setup
from ckanext.harvest.model import setup as harvest_model_setup
import ckanext.harvest.model as harvest_model

# to prevent all tables from being deleted
model.repo.tables_created_and_initialised = True


@pytest.fixture
def harvest_setup():
    harvest_model.setup()
