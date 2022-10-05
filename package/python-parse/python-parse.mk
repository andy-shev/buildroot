################################################################################
#
# python-parse
#
################################################################################

PYTHON_PARSE_VERSION = 1.19.0
PYTHON_PARSE_SOURCE = parse-$(PYTHON_PARSE_VERSION).tar.gz
PYTHON_PARSE_SITE = https://files.pythonhosted.org/packages/89/a1/82ce536be577ba09d4dcee45db58423a180873ad38a2d014d26ab7b7cb8a
PYTHON_PARSE_SETUP_TYPE = setuptools
PYTHON_PARSE_LICENSE = MIT-like
PYTHON_PARSE_LICENSE_FILES = LICENSE

$(eval $(python-package))
