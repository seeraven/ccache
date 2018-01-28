#
# Install CUDA.
#
# Version is given in the CUDA variable. If left empty, this script does
# nothing. As variables are exported by this script, "source" it rather than
# executing it.
#

if [ -n "$CUDA" ]; then
    if [ -z "$CUDA_REPO" ]; then
       CUDA_REPO=trusty
    fi

    echo "Installing CUDA support"
    if [ "$CUDA_REPO" == "xenial" ]; then
	travis_retry sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
	CUDA_PKG_NAME=cuda-repo-ubuntu1604_${CUDA}_amd64.deb
	CUDA_PKG_URL=http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_PKG_NAME}
    else
	CUDA_PKG_NAME=cuda-repo-ubuntu1404_${CUDA}_amd64.deb
	CUDA_PKG_URL=http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/${CUDA_PKG_NAME}
    fi

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
