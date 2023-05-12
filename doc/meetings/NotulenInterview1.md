# Interview notulen
## Algemene notulen
- Niet voor 2 dezelfde activiteiten inschrijven of voor 2 activiteiten op dezelfde tijd.
- moet je uitschrijven machine reservering voordat je kan inschrijven van een les tegelijk
  - je kan dan reservering aanpassen
- history behouden van elke tabel! (Loggen per tabel) (los van huidige tabel)
- wekelijkse meeting: Matthijs is in Arnhem op maandagochtend, donderdagen 
- volgende meeting: donderdag 13:30!

## Casus vragen
## Abonnementen
- Wat voor een abonnementen zijn er?
  - Verschillende abonnementen, verschillende lengte, onbeperkt maand sporten, per week, per jaar. abonnementen verschillen per lengte en wat je ermee kan.
    Ook moet je kortingen kunnen geven op abonnementen, bijvoorbeeld op het jaar abonnement dat als je deze in july aanschaft dat je bepaald % korting krijgt.
  - abonnementen kunnen alleen voor 1 sport zijn of alle.
  - je kan meerdere abonnementen hebben.
- Zijn er proefversies van abonnementen?
  - Proefweek abonnement is gratis, bijhouden welk abonnement iemand heeft gehad. 
  - Proefversie is algemeen dat je een week alles kan proberen.
- Is er een minimale leeftijd voor een abonnement?
  - abonnement typen hebben leeftijdsgrenzen.
- Is het mogelijk om een abonnement op te zeggen?
  - abonnement typen hebben een minimale lengte die je moet volgen.
  - abonnementen hebben opzegtermijn.
- Zijn de groepslessen en squashbanen beschikbaar voor alle leden, of zijn deze alleen voor specifieke soorten abonnementen?
  - 

## Groepslessen
- Moet je je inschrijven voor groeplessen?
  - ja. en je moet een abonnement hebben die gekoppeld is aan groepsles. 
- Wat zijn de mogelijke activiteiten voor groepslessen?
  - maakt niet uit voor datasysteem. 
  - groepslessen kunnen middelen hebben (machines etc)
- 

## Medewerkers
- Moet er een instructeur of medewerker aanwezig zijn bij de squashbanen?
  - squashbaan heeft geen medewerker die het overzicht heeft.
- Zijn er genoeg gecertificeerde trainers om vier keer dezelfde groepslessen te geven of is er maar een trainer per soort les?
  - ja, er zijn 4 ruimtes beschikbaar dus 4 lessen kunnen gegeven worden. 
- Zijn er specifieke regels voor een certified instructor?
  - per begeleider vastleggen welke lessen hij of zij mag geven. Certificaat mag achterwegen blijven.
- Kan een instructeur ook een medewerker(staff member) zijn?
  - Zijn gewoon begeleiders. Het kan een medewerker zijn die groepslessen geeft.
- medewerker kan bepaalde lessen geven. 

## Ruimtes
- Is er een speciale ruimte waar alle fitness machines in staan, of staan deze in een van de vier grote ruimtes?
  - Je hebt zalen voor groepslessen, je hebt een algemene fitnesszaal. Entiteiten: ruimtes waar je groepslessen hebt en fitness zalen.
  - 
- Wat is het maximale aantal mensen dat in een squashbaan mag?
  - reservering gaat met 1 persoon. Max via business. 
- Hebben de vier kamers specifieke identificatie?
  - maakt niet uit. 
- ruimte slaat aantal personen op. 1 lid reserveert

## Machines
- Is het mogelijk om meerdere machines tegelijk te reserveren?
  -  
- Voor hoe lang kan je reserveren bij fitness machines?
  -  misschien later een max reserving lengte. Maar niet voor nu. 
- Hoe vaak per week kan een persoon reserveren voor fitness machines?
  -  
- Is het mogelijk om een reservering voor een machine te annuleren?
  -  ja. 
- Zou het kunnen dat machines niet gereserveerd moeten kunnen worden omdat ze bijvoorbeeld kapot zijn?
  -  later misschien. 

## Klanten
- Moet er worden bijgehouden of iemand boven of onder de 18 is?
  -  Bij minderjarige iemand die toezegging heeft gedaan opslaan.
- Zijn er verder nog COVID-19-maatregelen die gehandhaafd moeten worden?
  -  per lessen een maximaal aantal deelnemers opslaan
- Wat houdt de contactinformatie van een klant in?
  -  hangt van abonnement af. betalingswijze mogen we weglaten. Wel aangeven of het al betaald is (/actief), naam, email, telefoonnummer, geboortedatum
- ouders moeten een minderjarige hun abonnement regelen. Dus voogd info opslaan (naam, email, telefoonnummer, geboortedatum)
- Covid-19 boeit niet meer


# Informatie vragen
- Wat voor documenten/informatie heeft u voor ons wat ons kan helpen met de casus?
  -  niets. 
- Heeft u testdata die gebruikt kan worden voor het ontwikkelproces?
  - Faker testdata genereren.
  - python libraries kunnen we gebruiken. 
# Technische vragen
- Aan welke eisen moet de staging area die wij gaan maken voldoen?
  -  
- Zijn er specifieke systemen die u wilt dat wij gebruiken, bijvoorbeeld MongoDB
  -  Niet met MongoDB! met SQLServer!

# Overige vragen
- Welke producten verwacht u dat wij aan het eind van het project opleveren? (frontend/backend/database?)
  -sql code(unit test wel, testdata niet) , testrapport/plan, FO & TO, installatiehandleiding 
  - PvA sturen wij vrijdag ook!

docker gebruiken! Vindt matthijs wel leuk

# Staging area
- lesrooster via een appje. Je kan je lessen zien. Dat rooster staat niet direct in de database
- reddish cash? in-memory database
- aan het einde info vanuit db naar een roosters zichtbaar krijgen
- maken sql query (view) en die kan worden aangeroepen. 
- 1 keer per dag lesrooster voor alle gebruikers
  - maakt niet uit wanneer
- als je een member id hebt kan je een rooster ophalen voor de komende weken
  - platte records met member id, datum, tijd etc die je per gebruiker kan filteren.



