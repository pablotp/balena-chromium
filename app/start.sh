#!/bin/bash


# By default docker gives us 64MB of shared memory size but to display heavy
# pages we need more.
umount /dev/shm && mount -t tmpfs shm /dev/shm
rm /tmp/.X0-lock &>/dev/null || true

# set hostname based on balena uuid
HNAME="bk-rpi-${BALENA_DEVICE_UUID:0:7}"
echo $HNAME > /etc/hostname
hostname $HNAME

# changing xwrapper config to run for any user
sed -i -e 's/console/anybody/g' /etc/X11/Xwrapper.config

# adding user to run chromium since it will not run as root
useradd chromium -m -s /bin/bash -G root
usermod -a -G root,tty chromium

# adding script to start chromium
echo "#!/bin/bash" > /home/chromium/xstart.sh
echo "chromium-browser --kiosk $URL_LAUNCHER_URL --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --window-size=1920,1080 --start-fullscreen --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI" >> /home/chromium/xstart.sh
chmod 770 /home/chromium/xstart.sh
chown chromium:chromium /home/chromium/xstart.sh

echo "#!/bin/bash" > /home/chromium/dashboard_a.sh
echo "chromium-browser --kiosk $DASHBOARD_A --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --window-size=1920,1080 --start-fullscreen --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI" >> /home/chromium/dashboard_a.sh
chmod 770 /home/chromium/dashboard_a.sh
chown chromium:chromium /home/chromium/dashboard_a.sh

echo "#!/bin/bash" > /home/chromium/dashboard_b.sh
echo "chromium-browser --kiosk $DASHBOARD_B --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage --window-size=1920,1080 --start-fullscreen --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI" >> /home/chromium/dashboard_b.sh
chmod 770 /home/chromium/dashboard_b.sh
chown chromium:chromium /home/chromium/dashboard_b.sh



# starting chromium as chrome user
#su -c 'startx /home/chromium/xstart.sh' chromium

