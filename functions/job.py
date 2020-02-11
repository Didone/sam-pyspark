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
    LOGGER.info(spark.version)
    LOGGER.debug(event)
    df = spark.read.format("csv").load(event.get('path'))
    return df.count()
