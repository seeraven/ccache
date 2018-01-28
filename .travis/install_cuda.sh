#
# Install CUDA.
#
# Version is given in the CUDA variable. If left empty, this script does
# nothing. As variables are exported by this script, "source" it rather than
# executing it.
#
# Known versions:
#  CUDA=5.5  => CUDA_REPO=ubuntu1404 CUDA_VERSION=5.5-54
#  CUDA=6.5  => CUDA_REPO=ubuntu1404 CUDA_VERSION=6.5-19
#  CUDA=7.0  => CUDA_REPO=ubuntu1404 CUDA_VERSION=7.0-28
#  CUDA=7.5  => CUDA_REPO=ubuntu1404 CUDA_VERSION=7.5-18
#  CUDA=8.0  => CUDA_REPO=ubuntu1404 CUDA_VERSION=8.0.61-1
#  CUDA=9.0  => CUDA_REPO=ubuntu1604 CUDA_VERSION=9.0.176-1
#  CUDA=9.1  => CUDA_REPO=ubuntu1604 CUDA_VERSION=9.1.85-1

if [ -n "$CUDA" ]; then
    case "$CUDA" in
	"5.5")
	    CUDA_REPO=ubuntu1404
	    CUDA_VERSION=5.5-54
	    ;;
	"6.5")
	    CUDA_REPO=ubuntu1404
	    CUDA_VERSION=6.5-19
	    ;;
	"7.0")
	    CUDA_REPO=ubuntu1404
	    CUDA_VERSION=7.0-28
	    ;;
	"7.5")
	    CUDA_REPO=ubuntu1404
	    CUDA_VERSION=7.5-18
	    ;;
	"8.0")
	    CUDA_REPO=ubuntu1404
	    CUDA_VERSION=8.0.61-1
	    ;;
	"9.0")
	    CUDA_REPO=ubuntu1604
	    CUDA_VERSION=9.0.176-1
	    ;;
	"9.1")
	    CUDA_REPO=ubuntu1604
	    CUDA_VERSION=9.1.85-1
	    ;;
	*)
	    echo "Unsupported CUDA version $CUDA."
	    exit 1
    esac

    echo "Installing CUDA support"
    if [ "$CUDA_REPO" == "ubuntu1604" ]; then
	travis_retry sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
    fi
    CUDA_PKG_NAME=cuda-repo-${CUDA_REPO}_${CUDA_VERSION}_amd64.deb
    CUDA_PKG_URL=http://developer.download.nvidia.com/compute/cuda/repos/${CUDA_REPO}/x86_64/${CUDA_PKG_NAME}

    travis_retry wget $CUDA_PKG_URL
    travis_retry sudo dpkg -i $CUDA_PKG_NAME
    travis_retry sudo apt-get update -qq
    export CUDA_APT=${CUDA:0:3}
    export CUDA_APT=${CUDA_APT/./-}

    travis_retry sudo apt-get install -y cuda-command-line-tools-${CUDA_APT}
    travis_retry sudo apt-get clean

    export CUDA_HOME=/usr/local/cuda-${CUDA:0:3}
    export LD_LIBRARY_PATH=${CUDA_HOME}/nvvm/lib64:${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}

    nvcc --version
else
    echo "CUDA is NOT installed."
fi
