clear
echo "The owner of this script will not be responsible if any unexpected problems occur whether you edit this script or not. It will start in 10 seconds and you agree to this. To cancel press Ctrl + C."
sleep 10
clear

# Cài đặt Playit thông qua APT repository
echo "Adding Playit repository..."
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list
sudo apt update
sudo apt install playit -y

# Cài đặt các gói cần thiết khác
sudo apt install apache2 ufw p7zip-full qemu-system-x86-64 -y
sudo ufw allow 'VNC'
sudo ufw status

# Tải và cài đặt file ISO
wget -O RTL8139F.iso 'https://drive.google.com/uc?export=download&id=1wDL8vo9mmYKw1HKXZzaYHoKmzSt_wXai'
wget -O 10.7z 'https://archive.org/download/windows-10.7z_20240424/Windows%2010.7z'
7za x 10.7z
rm -rf 10.7z

# Khởi động Playit và tạo đường hầm TCP cho VNC
echo "Starting Playit and creating TCP tunnel for VNC..."
playit -t tcp -p 5900

# Lấy thông tin đường hầm từ Playit
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'

# Khởi động QEMU
echo "Starting QEMU..."
sudo qemu-system-x86_64 -M q35 -cpu core2duo,+avx -smp sockets=1,cores=4,threads=2 -m 8G -drive file=10.qcow2,aio=threads,if=virtio,cache=unsafe -vga none -device virtio-gpu-pci -device intel-hda -device hda-duplex -device virtio-net-pci,netdev=n0 -netdev user,id=n0 -accel tcg,thread=multi,tb-size=2048 -device virtio-balloon-pci -device virtio-serial-pci -device virtio-rng-pci -device intel-iommu -vnc :0 -cdrom RTL8139F.iso
