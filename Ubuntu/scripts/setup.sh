#echo "Fixing Ubuntu 17.04 WiFi bug..."
#echo "\n[device]\nwifi.scan-rand-mac-address=no\n\n" | sudo tee -a /etc/NetworkManager/NetworkManager.conf
#sudo service network-manager restart

echo "Setting up Apple Keyboard"
echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
echo options hid_apple swap_opt_cmd=1 | sudo tee -a /etc/modprobe.d/hid_apple.conf

sudo update-initramfs -u -k all

echo "You should reboot..."
