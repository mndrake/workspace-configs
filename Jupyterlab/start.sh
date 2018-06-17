#!/bin/bash
set -o nounset -o errexit -o pipefail

IP_ADDR=$(/sbin/ifconfig eth0 | grep "inet addr" | cut -d ":" -f2 | cut -d " " -f1)
CONF_DIR="$HOME/.ipython/profile_default"
CONF_FILE="${CONF_DIR}/ipython_notebook_config.py"

mkdir -p "${CONF_DIR}"

cat <<EOF >>"${CONF_FILE}"
c = get_config()
c.NotebookApp.tornado_settings = {'headers': {'Content-Security-Policy': 'frame-ancestors *'}}
c.NotebookApp.token = ''
EOF

# need to start jupyterlab in desired working directory
# https://github.com/jupyterlab/jupyterlab/issues/2980
COMMAND='cd ${DOMINO_WORKING_DIR}; jupyter-lab --config="$CONF_FILE" --no-browser --ip=* 2>&1'
FINAL_COMMAND=$(echo "${COMMAND}" | sed "s/--ip=\\*/--ip=${IP_ADDR}/")

eval ${FINAL_COMMAND}
