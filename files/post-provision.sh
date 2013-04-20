#!/bin/bash
set -e

# By this point, the Puppet manifest for this box should have run. Included
# in the manifest for this box is a template for /home/vagrant/.bashrc which
# has the lines required by virtualenvwrapper to run.

# Fetch the WORKON_HOME value from .bashrc so we don't have to keep this file
# synced with the .bashrc template. The template's the truth source.
VENV_ROOT=$(grep -R "WORKON_HOME" /home/vagrant/.bashrc | awk -F "=" '{print $2}' 2>&1)
PYTHON=$VENV_ROOT/smartclip/bin/python
SMARTCLIP_DB=scdb

if ! which mkvirtualenv; then
    source /usr/local/bin/virtualenvwrapper.sh
    export WORKON_HOME=$VENV_ROOT
fi

if ! lsvirtualenv | grep -q "smartclip"; then
    echo $VENV_ROOT
    virtualenv $VENV_ROOT/smartclip
fi

# Put the root of the smartclip project on the PYTHONPATH.
echo "/opt/apps/smartclip" > $VENV_ROOT/smartclip/lib/python2.7/site-packages/smartclip.pth

# Should be an idempotent operation.
$VENV_ROOT/smartclip/bin/pip install -r /opt/apps/smartclip/requirements.txt

# Create the database if it doesn't exist already.
PSQL_PARAMS="--username=postgres --host=localhost --port=6432"
if ! psql $PSQL_PARAMS -c "SELECT * FROM pg_catalog.pg_database WHERE datname='$SMARTCLIP_DB'" postgres | \
    grep -q "$SMARTCLIP_DB"; then
    createdb $PSQL_PARAMS --owner=postgres -w $SMARTCLIP_DB
fi

# Sync our DB and run migrations. This should be an idempotent operation.
$PYTHON /opt/apps/smartclip/manage.py syncdb --noinput --settings=smartclip.settings
$PYTHON /opt/apps/smartclip/manage.py migrate --settings=smartclip.settings

