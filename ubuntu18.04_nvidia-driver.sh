dver=$(. /etc/os-release;echo $ID$VERSION_ID)
arch=$(dpkg -s libc6 | grep Architecture)

echo " check ubuntu version !"

if [ ${dver//.} = ubuntu1804 ];then
  echo "Version : ${dver}"
else
  echo "Sorry! This program is For Only Ubuntu 18.04 LTS Version !!"  # for only ubuntu 18.04 version!!
  exit
fi

sudo ubuntu-drivers devices
read -p "select your graphic's driver number from the above (ex: 440 / input number only): " input

read -p "Are you sure to want to install nvidia-driver-$input [y/n] " yn
case $yn in
	[Yy]* )	sudo apt-get purge nvidia*  # delete nvidia driver.
		sudo add-apt-repository ppa:graphics-drivers/ppa
		sudo apt-get update
		sudo apt-get install -y --no-install-recommends nvidia-driver-$input;;
	[Nn]* ) exit;;
esac

echo ""
echo "install cuda10.1"

if [ ${arch:14} = amd64 ];then # check 64bit version
	an_arch="x86_64"
else
	echo "  "
	echo "For only 64Bit! I think your ubuntu is 32Bit!! check it"
	exit
fi

# start nvidia driver installing.
wget https://developer.download.nvidia.com/compute/cuda/repos/${dver//.}/$an_arch/cuda-repo-${dver//.}_10.1.243-1_${arch:14}.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${dver//.}/$an_arch/7fa2af80.pub
sudo dpkg -i c
sudo apt-get update -y
wget http://developer.download.nvidia.com/compute/machine-learning/repos/${dver//.}/$an_arch/nvidia-machine-learning-repo-${dver//.}_1.0.0-1_${arch:14}.deb
sudo apt install -y ./nvidia-machine-learning-repo-${dver//.}_1.0.0-1_${arch:14}.deb
sudo apt-get update -y

sudo rm cuda-repo-${dver//.}_10.1.243-1_${arch:14}.deb
sudo rm nvidia-machine-learning-repo-${dver//.}_1.0.0-1_${arch:14}.deb

read -p "driver install is finish! Restart now? [y/n] " yn
case $yn in
	[Yy]* ) echo "System will restar!"
		sudo reboot;;
	[Nn]* ) exit;;
esac
