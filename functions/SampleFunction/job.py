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
    # spark.read.format("com.databricks.spark.csv").option("header", "true").option("delimiter", ";").option("inferSchema", "false").option("parserLib", "univocity").option("multiLine","true").option("quote", '"').option("escape", '"').option("mode", "DROPMALFORMED").load(s_from[0]).repartition("dt")
    return spark.version
