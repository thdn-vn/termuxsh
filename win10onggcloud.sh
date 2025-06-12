clear
echo "The owner of this script will not be responsible if any unexpected problems occur whether you edit this script or not. It will start in 10 seconds and you agree to this. To cancel press Ctrl + C."
sleep 10
clear
read -p $'\e[1;37mEnter your ngrok token: \e[0m' token
sudo apt update -y
sudo apt install apache2 ufw p7zip-full qemu-system-x86-64 -y
sudo ufw allow 'VNC'
sudo ufw status
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xvzf ngrok-v3-stable-linux-amd64.tgz
rm -rf ngrok-v3-stable-linux-amd64.tgz
./ngrok authtoken "$token"
./ngrok tcp --region ap 5900 &>/dev/null
wget -O RTL8139F.iso 'https://drive.google.com/uc?export=download&id=1wDL8vo9mmYKw1HKXZzaYHoKmzSt_wXai'
wget -O 10.7z 'https://archive.org/download/windows-10.7z_20240424/Windows%2010.7z'
7za x 10.7z
rm -rf 10.7z
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
sudo qemu-system-x86_64 -M q35 -cpu core2duo,+avx -smp sockets=1,cores=4,threads=2 -m 8G -drive file=10.qcow2,aio=threads,if=virtio,cache=unsafe -vga none -device virtio-gpu-pci -device intel-hda -device hda-duplex -device virtio-net-pci,netdev=n0 -netdev user,id=n0 -accel tcg,thread=multi,tb-size=2048 -device virtio-balloon-pci -device virtio-serial-pci -device virtio-rng-pci -device intel-iommu -vnc :0 -cdrom RTL8139F.is
