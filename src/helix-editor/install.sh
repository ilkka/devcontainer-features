#!/bin/sh
set -e

echo "Activating feature 'helix-editor'"
echo "Installing version ${HELIX_VERSION}"

install_debian_packages() {
	apt-get -y update
	DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends curl
	apt-get -y upgrade --no-install-recommends
	apt-get -y autoremove
	apt-get -y clean
	rm -rf /var/lib/apt/lists/*
}

install_redhat_packages() {
	local install_cmd=dnf
    if ! type dnf > /dev/null 2>&1; then
        install_cmd=yum
    fi
    ${install_cmd} -y install curl
	${install_cmd} upgrade -y
}

install_alpine_packages() {
	apk update && apk add --no-cache curl
}

# ADJUSTED_ID stuff copied from devcontainers/features/common-utils
# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
    ADJUSTED_ID="rhel"
elif [ "${ID}" = "alpine" ]; then
    ADJUSTED_ID="alpine"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

case "${ADJUSTED_ID}" in
	"debian")
		install_debian_packages
		;;
	"rhel")
		install_redhat_packages
		;;
	"alpine")
		install_alpine_packages
		;;
esac

cd /tmp
curl -fsSLO https://github.com/helix-editor/helix/releases/download/${VERSION}/helix-${VERSION}-x86_64-linux.tar.xz
tar xJf helix-${VERSION}-x86_64-linux.tar.xz
rm -f helix-${VERSION}-x86_64-linux.tar.xz
mkdir -p  ${_CONTAINER_USER_HOME}/.local/bin
mv helix-${VERSION}-x86_64-linux/hx ${_CONTAINER_USER_HOME}/.local/bin
mkdir -p  ${_CONTAINER_USER_HOME}/.config/helix
mv helix-${VERSION}-x86_64-linux/runtime ${_CONTAINER_USER_HOME}/.config/helix
rm -rf helix-${VERSION}-x86_64-linux

echo "Helix ${VERSION} installed as ${_CONTAINER_USER_HOME}/.local/bin/hx"