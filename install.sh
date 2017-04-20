tput clear


echo " "
echo -e "\e[7m                                    \e[27m"
echo -e "\e[7m  Willkommen beim TYPO3 Installer!  \e[27m"
echo -e "\e[7m                                    \e[27m"
echo " "

# TYPO3
echo -e "\e[36m\e[40mTYPO3\e[0m"
echo -e "\e[1mTYPO3 Version\e[0m \e[2m(z.B. current, 6.2, 7.6)\e[0m"
read t3version

# GET DOWNLOADED T3 FILE AND FOLDER NAME (VAR)
T3Filename=$(wget --spider --server-response get.typo3.org/$t3version 2>&1 | grep -o -E 'filename=.*$' | sed -e 's/filename="//' -e 's/"$//')
T3Foldername="${T3Filename%.tar.gz}"

echo " "
echo -e "\e[1mURL\e[0m \e[2m(z.B. www.kunde.ch)\e[0m"
read t3url
echo " "
echo -e "\e[1mKunden bzw. Firmenname\e[0m \e[2m(z.B. Muster AG)\e[0m"
read t3client
echo " "
echo -e "\e[1mT3 Admin Benutzername\e[0m"
read t3adminbn
echo " "
echo -e "\e[1mT3 Admin Passwort\e[0m"
read -s t3adminpw


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# DB
echo -e "\e[36m\e[40mDatenbank\e[0m"
echo -e "\e[1mDB Server\e[0m \e[2m(default = localhost)\e[0m"
read dbserver
echo " "
echo -e "\e[1mDB Name\e[0m"
read dbname
echo " "
echo -e "\e[1mDB Benutzername\e[0m"
read dbun
echo " "
echo -e "\e[1mDB PW\e[0m"
read -s dbpw


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# CHECK
echo -e "\e[36m\e[40mÜberprüfung\e[0m"
echo -e "\e[1mTYPO3 Version:\e[0m	$t3version"
echo -e "\e[1mURL:\e[0m		$t3url"
echo -e "\e[1mKunde:\e[0m		$t3client"
echo -e "\e[1mAdmin User:\e[0m	$t3adminbn"
echo -e "\e[1mAdmin PW:\e[0m	$t3adminpw"
echo " "
echo -e "\e[1mDB Server:\e[0m	$dbserver"
echo -e "\e[1mDB Name:\e[0m	$dbname"
echo -e "\e[1mDB User:\e[0m	$dbun"
echo -e "\e[1mDB PW:\e[0m		$dbpw"

echo " "
echo " "

while true; do
    read -p "Sind diese Daten Korrekt (y/n)?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo -e "Bitte mit Ja \e[2m(Y / y)\e[0m oder Nein \e[2m(N / n)\e[0m bestätigen!";;
    esac
done


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# T3 DOWNLOAD
echo -e "\e[36m\e[40mHerunterladen des T3 Core\e[0m"
echo -e "\e[2mDownloading T3 Core...\e[0m"
sleep 2
wget get.typo3.org/$t3version --content-disposition
echo -e "\e[2mDownload Abgeschlossen\e[0m"
sleep 3


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# EXTRACT T3 FILE
echo -e "\e[36m\e[40mEntpacken des T3 Core\e[0m"
echo -e "\e[2mT3 Datei wird entpackt\e[0m"
sleep 2
tar -xvf $T3Filename
echo -e "\e[2mT3 Datei erfolgreich entpackt\e[0m"
sleep 3

tput clear

# REMOVE T3 FILE
echo -e "\e[36m\e[40mEntfernen der T3 Zip Datei\e[0m"
echo -e "\e[2mT3 Datei wird entfernt\e[0m"
sleep 2
rm $T3Filename
echo -e "\e[2mT3 Datei wurde erfolgrecih entfernt\e[0m"
sleep 3


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# LINKING T3 FOLDER AND FILES TO WEB FOLDER
echo -e "\e[36m\e[40mErstellung von Verlinkungen in den Web Ordner\e[0m"
ls -l
echo " "
echo -e "\e[1mIn welchem Ordner befindet sich das Web?\e[0m \e[2m(z.B. public_html)\e[0m"
read webfolder
cd $webfolder

t3sFolder="typo3_src"
if [ -d $t3sFolder ]; then
    echo -e "\e[41m\e[97mDer Ordner Link für $t3sFolder exisitert bereits!\e[0m"
	echo -e "\e[1mSoll dieser gelöscht und neu verlinkt werden?\e[0m"
	while true; do
	    read -p "" yn
	    case $yn in
	        [Yy]* ) rm $t3sFolder; ln -s ../$T3Foldername $t3sFolder; echo " "; break;;
	        [Nn]* ) echo " "; break;;
	        * ) echo -e "Bitte mit Y für «neu verlinken» oder N für «nicht neu verlinken»!"; echo " ";;
	    esac
	done
else
	ln -s ../$T3Foldername $t3sFolder
fi

t3Folder="typo3"
if [ -d $t3Folder ]; then
    echo -e "\e[41m\e[97mDer Ordner Link für $t3Folder exisitert bereits!\e[0m"
	echo -e "\e[1mSoll dieser gelöscht und neu verlinkt werden?\e[0m"
	while true; do
	    read -p "" yn
	    case $yn in
	        [Yy]* ) rm $t3Folder; ln -s $t3sFolder/$t3Folder $t3Folder; echo " "; break;;
	        [Nn]* ) echo " "; break;;
	        * ) echo -e "Bitte mit Y für «neu verlinken» oder N für «nicht neu verlinken»!"; echo " ";;
	    esac
	done
else
	ln -s $t3sFolder/$t3Folder $t3Folder
fi

indexFile="index.php"
if [ -f $indexFile ]; then
    echo -e "\e[41m\e[97mDie Datei $indexFile exisitert bereits!\e[0m"
	echo -e "\e[1mSoll diese gelöscht und aus dem TYPO3 repository neu verlinkt werden?\e[0m"
	while true; do
	    read -p "" yn
	    case $yn in
	        [Yy]* ) rm $indexFile; ln -s $t3sFolder/$indexFile $indexFile; echo " "; break;;
	        [Nn]* ) echo " "; break;;
	        * ) echo -e "Bitte mit Y für «neu verlinken» oder N für «nicht neu verlinken»!"; echo " ";;
	    esac
	done
else
	ln -s $t3sFolder/$indexFile $indexFile
fi

htaccessFile=".htaccess"
if [ -f $htaccessFile ]; then
    echo -e "\e[41m\e[97mDie Datei $htaccessFile exisitert bereits!\e[0m"
	echo -e "\e[1mSoll diese gelöscht und aus dem TYPO3 repository neu verlinkt werden?\e[0m"
	while true; do
	    read -p "" yn
	    case $yn in
	        [Yy]* ) rm $htaccessFile; cp $t3sFolder/_.htaccess $htaccessFile; echo " "; break;;
	        [Nn]* ) echo " "; break;;
	        * ) echo -e "Bitte mit Y für «neu verlinken» oder N für «nicht neu verlinken»!"; echo " ";;
	    esac
	done
else
	cp $t3sFolder/_.htaccess $htaccessFile
fi

touch FIRST_INSTALL
cd ../


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# RUNNING INSTALL T3 TOOL
echo -e "\e[36m\e[40mTYPO3 Installations Tool\e[0m"
echo -e "\e[2mT3 Installation wird gestartet\e[0m"
sleep 2
setHash () {
    HASH=$(curl -skL "http://${t3url}/typo3/sysext/install/Start/Install.php" 2>&1 | grep 'token' | grep -m 1 -Po '(?<=value=").*(?=")')
}
curl "http://${t3url}/typo3/sysext/install/Start/Install.php" -H 'Content-Type: application/x-www-form-urlencoded' --data "install%5Baction%5D=environmentAndFolders&install%5Bset%5D=execute"
setHash
curl "http://${t3url}/typo3/sysext/install/Start/Install.php?install\[redirectCount\]=0&install\[context\]=standalone&install\[controller\]=step&install\[action\]=databaseConnect" -H 'Content-Type: application/x-www-form-urlencoded' --data "install%5Bcontroller%5D=step&install%5Baction%5D=databaseConnect&install%5Btoken%5D=${HASH}&install%5Bcontext%5D=standalone&install%5Bset%5D=execute&install%5Bvalues%5D%5Busername%5D=${dbun}&install%5Bvalues%5D%5Bpassword%5D=${dbpw}&install%5Bvalues%5D%5Bhost%5D=${dbserver}&install%5Bvalues%5D%5Bsocket%5D="
setHash
curl "http://${t3url}/typo3/sysext/install/Start/Install.php?install\[redirectCount\]=2&install\[context\]=standalone&install\[controller\]=step&install\[action\]=databaseSelect" -H 'Content-Type: application/x-www-form-urlencoded' --data "install%5Bcontroller%5D=step&install%5Baction%5D=databaseSelect&install%5Btoken%5D=${HASH}&install%5Bcontext%5D=standalone&install%5Bset%5D=execute&install%5Bvalues%5D%5Btype%5D=existing&install%5Bvalues%5D%5Bexisting%5D=${dbname}&install%5Bvalues%5D%5Bnew%5D="
setHash
curl "http://${t3url}/typo3/sysext/install/Start/Install.php?install\[redirectCount\]=3&install\[context\]=standalone&install\[controller\]=step&install\[action\]=databaseData" -H 'Content-Type: application/x-www-form-urlencoded' --data "install%5Bcontroller%5D=step&install%5Baction%5D=databaseData&install%5Btoken%5D=${HASH}&install%5Bcontext%5D=standalone&install%5Bset%5D=execute&install%5Bvalues%5D%5Busername%5D=${t3adminbn}&install%5Bvalues%5D%5Bpassword%5D=${t3adminpw}&install%5Bvalues%5D%5Bsitename%5D=${t3client}"
echo -e "\e[2mT3 Installaltion beendet\e[0m"
sleep 3


# ===SPACER====
echo " "
echo " "
tput clear
# ===SPACER====


# ZUSÄTZLICHES (robots.txt)
# users for command line usage
# robots.txt erstellen?
# RealURL / SEOBasics / MagnificPopup


echo " "
echo -e "\e[7m                                     \e[27m"
echo -e "\e[7m  TYPO3 Installation Abgeschlossen!  \e[27m"
echo -e "\e[7m                                     \e[27m"
echo " "






# TEST STUFF

# Using wget
#wget get.typo3.org/current --content-disposition
# Using cURL (e.g., when wget fails with SSL error)
#curl -L -o typo3_src.tgz get.typo3.org/current


# while true; do
#     read -p "Do you wish to install this program?" yn
#     case $yn in
#         [Yy]* ) make install; break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done
