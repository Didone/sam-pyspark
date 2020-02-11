"""
PySpark Hello World
"""
import logging
import os

logging.basicConfig()
LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(getattr(logging, os.environ.get('LOG_LEVEL','INFO')))
LOGGER.debug(__name__)

def run(event, spark):
    """ Staring Function """
    LOGGER.debug(spark)
    LOGGER.debug(event)
    return spark.version
