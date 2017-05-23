# Matthew M Reid. install open mpi shell script
 
# install destination
installDIR="/usr/local"
# First get necessary dependencies
sudo apt-get update
sudo apt-get install -y autotools-dev autoconf-dev automake-dev g++ build-essential gfortran
# remove any obsolete libraries
sudo apt-get autoremove
 
# Build using maximum number of physical cores
n=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $NF}'`
 
# grab the necessary files
# NOTE: see this page:
# https://www.open-mpi.org/software/ompi
# to check the latest OpenMPI version.
MPI_VERSION_MAIN=2.1  # 1.6
MPI_VERSION_SUB=2.1.1 # 1.6.5
wget http://www.open-mpi.org/software/ompi/v${MPI_VERSION_MAIN}/downloads/openmpi-${MPI_VERSION_SUB}.tar.gz
tar xzvf openmpi-${MPI_VERSION_SUB}.tar.gz
cd openmpi-${MPI_VERSION_SUB}
 
echo "Beginning the installation..."
./configure --prefix=$installDIR
make -j $n
sudo make install				# TIENE q ser con sudo!!!
# with environment set do ldconfig
sudo ldconfig
echo
echo "...done."
