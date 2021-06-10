#!/bin/bash
################################################################################
## Firefox Security Toolkit OSINT Version
## Description:
# This script automatically transform Firefox Browser to a OSINT investigation suite.
# The script mainly focuses on downloading the required add-ons for OSINT investigations.
## Version:
# v0.7
## Homepage:
# https://github.com/mazen160/Firefox-Security-Toolkit
## Author:
# Mazin Ahmed <mazin AT mazinahmed DOT net>
################################################################################


logo() {
echo '    ______ _              ____                _____                           _  __            ______               __ __ __  _  __ '
echo '   / ____/(_)_____ ___   / __/____   _  __   / ___/ ___   _____ __  __ _____ (_)/ /_ __  __   /_  __/____   ____   / // //_/ (_)/ /_'
echo '  / /_   / // ___// _ \ / /_ / __ \ | |/_/   \__ \ / _ \ / ___// / / // ___// // __// / / /    / /  / __ \ / __ \ / // ,<   / // __/'
echo ' / __/  / // /   /  __// __// /_/ /_>  <    ___/ //  __// /__ / /_/ // /   / // /_ / /_/ /    / /  / /_/ // /_/ // // /| | / // /_  '
echo '/_/    /_//_/    \___//_/   \____//_/|_|   /____/ \___/ \___/ \__,_//_/   /_/ \__/ \__, /    /_/   \____/ \____//_//_/ |_|/_/ \__/  '
echo '                                                                                  /____/                                            '
echo "  _               __  __           _            _    _                        _  "
echo " | |__  _   _ _  |  \/  | __ _ ___(_)_ __      / \  | |__  _ __ ___   ___  __| | "
echo " | '_ \| | | (_) | |\/| |/ _\` |_  / | '_ \    / _ \ | '_ \| '_ \` _ \ / _ \/ _\` | "
echo " | |_) | |_| |_  | |  | | (_| |/ /| | | | |  / ___ \| | | | | | | | |  __/ (_| | "
echo " |_.__/ \__, (_) |_|  |_|\__,_/___|_|_| |_| /_/   \_\_| |_|_| |_| |_|\___|\__,_| "
echo "        |___/                                                                    "
echo "v0.7"
echo "www.mazinahmed.net"
echo "twitter.com/mazen160"
}

logo

welcome() {
echo -e "\n\n"
echo -e "Usage:\n\t"
echo -e "bash $0 run"
echo -e "\n"
echo -e '[%%] Available Add-ons:'
echo 'User-Agent Switcher and Manager
IP Address and Domain Information
Privacy Badger
uBlock Origin
Wayback Machine
Sputnik
Search by Image
Buster: Captcha Solver for Humans
I don´t care about cookies
Copyfish
Wappalyzer
Vulners Web Scanner
Undo Close Tab
HTTP Header Live
Google Dork Builder
Disable WebRTC
Shodan.io
'

#'[%%] Additions & Features:'
#echo '* Downloading Burp Suite certificate'
#echo '* Downloading a large user-agent list for User-Agent Switcher'
#echo -e "\n\n"
#echo "[$] Legal Disclaimer: Usage of Firefox Security Toolkit for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program"
#}

if [[ $1 != 'run' ]];then
  welcome
  exit 0
else
  echo -en "\n\n[#] Click [Enter] to start. "; read -r
fi

if [[ -z $FIREFOXPATH ]]; then
  if [[ ! -z $(which firefox) ]]; then
    FIREFOXPATH=$(which firefox)
  elif [[ "$(uname)" == "Darwin" ]];then
    FIREFOXPATH="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
  else
    FIREFOXPATH='/usr/bin/firefox'
  fi
fi


# checking whether Firefox is installed.
if [[ ! -f "$FIREFOXPATH" ]]; then
  echo -e "[*] Firefox does not seem to be installed.\n[*]Quitting..."
  exit 1
fi

echo "[*] Firefox path: $FIREFOXPATH"

# creating a tmp directory.
scriptpath=$(mktemp -d)
echo -e "[*] Created a tmp directory at [$scriptpath]."

# inserting a "Installation is Finished" page into $scriptpath.
echo '<!DOCTYPE HTML><html><center><head><h1>Installation is Finished</h1></head><body><p><h2>You can close Firefox.</h2><h3><i>Firefox Security Toolkit</i></h3></p></body></center></html>' > "$scriptpath/.installation_finished.html"

# checks whether the user would like to download Burp Suite certificate.
echo -n "[@] Would you like to download Burp Suite certificate? [y/n]. (Note: Burp Suite should be running in your machine): "; read -r burp_cert_answer
  burp_cert_answer=$(echo -n "$burp_cert_answer" | tr '[:upper:]' '[:lower:]')
  if [[ ( $burp_cert_answer == 'y' ) || ( $burp_cert_answer == 'yes' ) ]];then
    echo -n "[@] Enter Burp Suite proxy listener's port (Default: 8080): "; read -r burp_port
    if [[ $burp_port == '' ]]; then
      burp_port='8080'
    fi
    wget "http://127.0.0.1:$burp_port/cert" -o /dev/null -O "$scriptpath/cacert.der"
    if [ -s "$scriptpath/cacert.der" ];then
      echo -e "[*] Burp Suite certificate has been downloaded, and can be found at [$scriptpath/cacert.der]."
    else
      echo "[!]Error: Firefox Security Toolkit was not able to download Burp Suite certificate, you need to do this task manually."
    fi
  fi

# downloading packages.
echo -e "[*] Downloading Add-ons."

# User-Agent Switcher and Manager
wget "https://addons.mozilla.org/firefox/downloads/file/3769639/user_agent_switcher_and_manager-0.4.7.1-an+fx.xpi" -o /dev/null -O "$scriptpath/user_agent_switcher_and_manager-0.4.7.1-an+fx.xpi"

# IP Address and Domain Information
wget "https://addons.mozilla.org/firefox/downloads/file/3637661/ip_address_and_domain_information-4.0.6.0-fx.xpi" -o /dev/null -O "$scriptpath/ip_address_and_domain_information-4.0.6.0-fx.xpi"

# Privacy Badger
wget "https://addons.mozilla.org/firefox/downloads/file/3719726/privacy_badger-2021.2.2-an+fx.xpi" -o /dev/null -O "$scriptpath/privacy_badger-2021.2.2-an+fx.xpi"

# uBlock Origin
wget "https://addons.mozilla.org/firefox/downloads/file/3768975/ublock_origin-1.35.2-an+fx.xpi" -o /dev/null -O "$scriptpath/ublock_origin-1.35.2-an+fx.xpi"

# Wayback Machine
wget "https://addons.mozilla.org/firefox/downloads/file/929315/wayback_machine-1.8.6-an+fx.xpi" -o /dev/null -O "$scriptpath/wayback_machine-1.8.6-an+fx.xpi"

# Sputnik
wget "https://addons.mozilla.org/firefox/downloads/file/3752246/sputnik-1.28-fx.xpi" -o /dev/null -O "$scriptpath/sputnik-1.28-fx.xpi"

# Search by Image
wget "https://addons.mozilla.org/firefox/downloads/file/3767226/search_by_image-3.6.2-an+fx.xpi" -o /dev/null -O "$scriptpath/search_by_image-3.6.2-an+fx.xpi"

# Buster: Captcha Solver for Humans
wget "https://addons.mozilla.org/firefox/downloads/file/3768455/buster_captcha_solver_for_humans-1.2.0-an+fx.xpi" -o /dev/null -O "$scriptpath/buster_captcha_solver_for_humans-1.2.0-an+fx.xpi"

# I don't care about cookies
wget "https://addons.mozilla.org/firefox/downloads/file/3761156/i_dont_care_about_cookies-3.3.0-an+fx.xpi" -o /dev/null -O "$scriptpath/i_dont_care_about_cookies-3.3.0-an+fx.xpi"

# Copyfish
wget "https://addons.mozilla.org/firefox/downloads/file/3765111/copyfish-5.1.9-fx.xpi" -o /dev/null -O "$scriptpath/copyfish-5.1.9-fx.xpi"

# Wappalyzer
wget "https://addons.mozilla.org/firefox/downloads/file/3789734/wappalyzer-6.7.4-fx.xpi" -o /dev/null -O "$scriptpath/wappalyzer-6.7.4-fx.xpi"

# Vulners Web Scanner
wget "https://addons.mozilla.org/firefox/downloads/file/817904/vulners_web_scanner-1.0.6-an+fx-linux.xpi" -o /dev/null -O "$scriptpath/vulners_web_scanner-1.0.6-an+fx-linux.xpi"

# HTTP Header Live
wget "https://addons.mozilla.org/firefox/downloads/file/3384326/http_header_live-0.6.5.2-fx.xpi" -o /dev/null -O "$scriptpath/http_header_live-0.6.5.2-fx.xpi"

# Google Dork Builder
wget "https://addons.mozilla.org/firefox/downloads/file/3614823/google_dork_builder-0.8-fx.xpi" -o /dev/null -O "$scriptpath/google_dork_builder-0.8-fx.xpi"

# Undo Close Tab
wget "https://addons.mozilla.org/firefox/downloads/file/3674240/geschlossenen_tab_wiederherstellen-7.1.0-an+fx.xpi" -o /dev/null -O "$scriptpath/geschlossenen_tab_wiederherstellen-7.1.0-an+fx.xpi"

# Disable WebRTC
wget "https://addons.mozilla.org/firefox/downloads/file/3551985/disable_webrtc-1.0.23-an+fx.xpi" -o /dev/null -O "$scriptpath/disable_webrtc-1.0.23-an+fx.xpi"

# Shodan.io
wget "https://addons.mozilla.org/firefox/downloads/file/788781/shodanio-0.3.2-an+fx.xpi" -o /dev/null -O "$scriptpath/shodanio-0.3.2-an+fx.xpi"

# checks whether to download user-agent list for User-Agent Switcher add-on.
echo -n "[@] Would you like to download user-agent list for User-Agent Switcher add-on? [y/n]: "; read -r useragent_list_answer
  useragent_list_answer=$(echo -n "$useragent_list_answer" | tr '[:upper:]' '[:lower:]')
  if [[ ( $useragent_list_answer == 'y' ) || ( $useragent_list_answer == 'yes' ) ]]; then
    wget 'https://techpatterns.com/downloads/firefox/useragentswitcher.xml' -o /dev/null -O "$scriptpath/useragentswitcher.xml"
    echo -e "[*]Additional user-agents has been downloaded for \"User-Agent Switcher\" add-on, you can import it manually. It can be found at: [$scriptpath/useragentswitcher.xml]."
  fi

# messages.
echo -e "[*] Downloading add-ons completed.\n";
echo -en "[@@] Click [Enter] to run Firefox to perform the task. (Note: Firefox will be restarted) "; read -r
echo -e "[*] Running Firefox to install the add-ons.\n"
echo -e "Click confirm on the prompt, and close Firefox, until all addons are installed"
# installing the add-ons.
# the process needs to be semi-manually due to Mozilla Firefox security policies.

# stopping Firefox if it's running.
killall firefox &> /dev/null
# installing
# "$FIREFOXPATH" "$scriptpath/"*.xpi "$scriptpath/.installation_finished.html" &> /dev/null
for extension in $(find $scriptpath -type f -name "*.xpi"); do
  echo "- $extension"
  "$FIREFOXPATH" --new-tab "$extension"
done
"FIREFOXPATH" "$scriptpath/.installation_finished.html"

####

# in case you need to delete the tmp directory, uncomment the following line.
#rm -rf "$scriptpath"; echo -e "[*]Deleted the tmp directory."
echo -e "[**] Firefox Security Toolkit is finished\n"
echo -e "Have a nice day! - Mazin Ahmed"

# END #
