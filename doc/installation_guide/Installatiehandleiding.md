# Installatie handleiding

## Inhoudsopgave
- [1 Inleiding](#1-inleiding)
- [2 System requirements](#2-system-requirements)
    - [2.1 Hardware requirements](#21-hardware-requirements)
    - [2.2 Software requirements](#22-software-requirements)
        - [2.2.1 Docker Desktop](#221-docker-desktop)
        - [2.2.2 Python](#222-python)
- [3 Installatie](#3-installatie)
- [4 Log in gegevens](#4-login-gegevens)
- [5 Opstarten](#5-opstarten)
- [6 Testen](#6-testen)


## 1 Inleiding

Om te zorgen dat het BestFit Gym datasysteem en staging area gedraaid kan worden, zijn enkele stappen nodig. Deze
stappen worden in dit document uitgelicht. Er wordt beschreven welke systeemvereisten er zijn, hoe de software
geïnstalleerd moet worden en hoe de software opgestart kan worden.

## 2 System requirements

Om de software te kunnen installeren zijn er een paar programma's nodig. Deze zijn hieronder beschreven.

### 2.1 Hardware requirements

Per OS zijn er verschillende hardware specificaties nodig om de applicatie op te kunnen starten.

* Windows
    * 64-bit processor met SLAT
    * 4GB RAM
    * BIOS-level hardware virtualization support moet aanstaan in de BIOS. Gebruik
      hiervoor <a href="https://bce.berkeley.edu/enabling-virtualization-in-your-pc-bios.html">deze</a> handleiding
* Mac
    * 4GB RAM
* Linux
    * 64-bit kernel en CPU support voor virtualization
    * 4GB RAM

### 2.2 Software requirements

### 2.2.1 Docker Desktop

De gehele applicatie draait in een Docker container, om dit te kunnen draaien is Docker Desktop nodig. 
Deze kan hier gedownload worden: https://www.docker.com/products/docker-desktop
Gedurende het project is gebruik gemaakt van Docker Desktop versie 23.0.6, maar de laatste versie die op deze site
te vinden is, kan gebruikt worden.

<i>
Let op: Docker Desktop heeft per OS verschillende systeemvereisten. Per OS zijn deze hieronder beschreven.

* Windows
    * Windows 11 64-bit: Home of Pro versie 21H2 of hoger, of Enterprise of Education versie 21H2 of hoger
    * Windows 10 64-bit: Home of Pro 21H1 (build 19043) of hoger, of Enterprise of Education 20H2 (build 19042) of
      hoger
    * Zet de WSL 2 feature aan in Windows. Om dit te doen, volg
      de <a href="https://docs.microsoft.com/en-us/windows/wsl/install-win10">documentatie van Microsoft</a>
    * Download
      de <a href="https://learn.microsoft.com/en-gb/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package">
      Linux Kernel update package</a>
* Mac
    * macOS 11.0 of nieuwer. Dit houdt in: Big Sur (11), Monterey (12), of Ventura (13). De nieuwste versie is
      aangeraden
    * VirtualBox versies voor versie 4.3.30 zijn niet compatibel met Docker Desktop. Zorg ervoor dat je de
      nieuwste versie van VirtualBox hebt geïnstalleerd

* Linux
    * KVM virtualization support, kijk of dit aan staat met behulp van
      <a href="https://docs.docker.com/desktop/install/linux-install/#kvm-virtualization-support">deze</a> handleiding
    * QEMU moet versie 5.2 of hoger zijn. De nieuwste versie is aangeraden
    * systemd init system
    * Gnome, KDE of Mate Desktop Environment
    * ID mapping moet aanstaan in user namespaces, dit zet je aan met behulp van
      <a href="https://docs.docker.com/desktop/faqs/linuxfaqs/#how-do-i-enable-file-sharing">deze</a> handleiding

</i>

### 2.2.2 Python

Om de staging area te kunnen draaien is een versie van Python 3.11 nodig. Deze kan hier gedownload 
worden: https://www.python.org/downloads/. Gedurende het project is gebruik gemaakt van Python 3.11.4, maar de 
laatste versie die op deze site te vinden is, kan gebruikt worden.

<i>
Let op: Voor het geval dat op het huidige OS geen aanwezige versie is van C++, is het nodig om de Microsoft Visual
C++ Build Tools te installeren. Deze kan hier gedownload worden: <a href="https://visualstudio.microsoft.com/visual-cpp-build-tools/">
https://visualstudio.microsoft.com/visual-cpp-build-tools/</a>. Hiervan kan de laatste versie gebruikt worden.
</i>

## 3 Installatie

Deze installatie handleiding gaat ervan uit dat op het huidige OS Docker Desktop en een versie van Python 3.11 is geïnstalleerd en dat
het systeem voldoet aan de minimale specificaties.

Het is van belang dat na het installeren van Docker Desktop en Python 3.11, de computer opnieuw opgestart wordt.
Dit kan anders problemen veroorzaken bij het installeren en draaien van de applicatie.

1. De code
Voor de laatste versie van de code kan de volgende link gebruikt worden:
https://bitbucket.aimsites.nl/projects/JYKGOJ/repos/best-fit-gym/browse?at=refs%2Fheads%2Fmaster
Hier kan je de code downloaden als zip bestand of de code clonen met behulp van Git.

Zet deze code in een map naar keuze.

2. Python dependencies

Om de Python dependencies te installeren, open een terminal en run het volgende commando:

```powershell
pip install poetry==1.5.0 python-dateutil==2.8.2 redis==4.5.5 pandas==2.0.1 pyodbc==4.0.34 sqlalchemy==2.0.15 faker==18.9.0 pytest==7.3.1 pytest-cov==4.1.0 pytest-html==3.2.0
```

Bij elke package staat een versienummer, dit zijn de versies die gebruikt zijn gedurende het project.

Ga vervolgens naar de map waar de code staat en verplaats je door middel van het volgende commando naar de map
staging_area/bestfit:
```powershell
cd staging_area/bestfit
```

Run daarna de volgende commando's:

```powershell
poetry env use python # Als deze commando niet werkt, kan je OS de executable opgeslagen hebben als python3.11, dan moet je dat gebruiken
poetry lock
poetry install
```

3. ODBC 18 Driver For SQL Server

Om vanuit de staging area data te kunnen schrijven naar de database, is het nodig om de ODBC 18 Driver For SQL Server te
installeren. Deze kan hier gedownload worden:
https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver16. Hiervan
kan de laatste versie gebruikt worden.

## 4 Login gegevens

De volgende login gegevens worden gebruikt in de applicatie, het is van belang, wanneer de applicatie naar productie
gaat, dat deze gegevens worden aangepast.

```
Database:
Login: LOG_BEST_FIT_ADMIN
Password: BestFitAdminExamplePassword0?

Staging area:
Login: LOG_BEST_FIT_STAGING
Password: BestFitStagingExamplePassword0?
```

De staging area user heeft alleen rechten op de tabellen en stored procedures die nodig zijn voor de staging area.
Waar de admin user rechten heeft op alle tabellen en stored procedures.

## 5 Opstarten

Om de applicatie op te starten moet Docker Desktop aan staan. Als dit het geval is, kan de applicatie opgestart worden
door naar de volgende map te gaan vanuit de hoofdmap van het project:
```powershell
docker/
```

En vervolgens het volgende commando uit te voeren:
```powershell
docker compose up --build
```

Dit kan even duren, maar in de terminal zal te zien zijn wanneer de applicatie klaar is om gebruikt te worden.
Tijdens het opstarten worden een aantal dingen gedaan:

1. Er wordt een login aangemaakt voor de DB admin user
2. De database wordt opgezet
3. De test database wordt opgezet
4. De rechten voor de databases worden gegeven aan de DB admin user
5. Alle stored procedures, triggers en tests hiervoor worden toegevoegd aan de test database
6. Deze tests worden uitgevoerd
7. Alle stored procedures, triggers en views worden toegevoegd aan de database
8. De algemene data wordt toegevoegd aan de database
9. De user wordt aangemaakt voor de staging area

Om deze container weer af te sluiten, kan het volgende commando gebruikt worden:
```powershell
docker compose down
```

## 6 Testen

Om de tests te runnen, moet de applicatie opgestart zijn. Dit kan gedaan worden door de applicatie op te starten met
de handleiding in hoofdstuk 5.

Voor beide de staging area en de database zijn tests geschreven en is een manier om deze tests te runnen gedocumenteerd.
Dit is te vinden in de inleiding van het meegeleverde testrapport.

<i>
Let op: Als je probeert PowerShell scripts te runnen op een Mac of Linux OS, moet je eerst PowerShell downloaden. 
Dit kan voor Mac OS hier <a href="https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.3">
https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.3</a>
En voor Linux hier <a href="https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.3">
https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.3</a>.
</i>