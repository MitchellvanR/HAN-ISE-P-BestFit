# Elaboratie onderzoek

Casus: "Best Fit" gym \
Groep: ISE B1 \
Datum: 24-04-2023 \
Versie: 1

## Inhoudsopgave
- [1 Inleiding](#1-inleiding)
- [2 Elaboratie onderdelen](#2-elaboratie-onderdelen)
  - [2.1 Staging area](#21-staging-area)
  - [2.2 Faker](#22-faker)
  - [2.3 Docker](#23-docker)
- [3 Methoden](#3-methoden)
  - [3.1 Prototype](#31-prototype)
- [4 Resultaten](#4-resultaten)
  - [4.1 Staging area](#41-staging-area)
  - [4.2 Faker](#42-faker)
  - [4.3 Docker](#43-docker)
- [5 Conclusie](#5-conclusie)

## 1 Inleiding

Dit document heeft als doel om te beschrijven op welke manier er onderzoek is gedaan naar verschillende technische
methoden die wij van plan zijn om te gebruiken in het project.

Om dit goed in kaart te brengen is het document onderverdeeld in verschillende hoofdstukken. Eerst worden alle
onderdelen beschreven die wij van plan zijn om te onderzoeken, gevolgd door de methode hoe dit gedaan wordt.
Daarna worden de resultaten van de onderzoeken beschreven en tot slot wordt er een conclusie getrokken op basis van 
deze resultaten.

## 2 Elaboratie onderdelen

Om de technische methoden die wij van plan zijn te gebruiken tijdens dit project te kunnen realiseren, worden
deze methoden eerst getest. Om dat te doen hebben wij deze methoden onderverdeeld in drie verschillende onderdelen.
Deze onderdelen staan hieronder beschreven.

### 2.1 Staging area

Voor de staging area had de opdrachtgever een aantal wensen. 
De staging area moet bestaan uit een Microsoft SQL Server (MSSQL) database en een Redis caching systeem.
Er moet een manier komen om data uit de MSSQL database te halen, om vervolgens deze data eventueel te transformeren
en daarna op te slaan in een Redis cache.
Daarna moeten leden of medewerkers hun persoonlijke rooster met al hun reserveringen kunnen ophalen. Om dat te doen,
moet er in de Redis cache gekeken worden om de specifieke data van de gebruiker op te halen en deze te tonen.

### 2.2 Faker

Om aan de benodigde data te komen waarmee het informatiesysteem getest kan worden, moet er een manier komen om
test data te genereren. De opdrachtgever heeft ons aanbevolen te kijken naar de "Faker" Python library, die de 
mogelijkheid heeft om data te genereren volgens een bepaalde structuur, datatypes en kwantiteit.
Hiervoor is een script nodig die, met behulp van de Faker library, data genereert en deze opslaat in de MSSQL database.

### 2.3 Docker

Als laatste wens heeft de opdrachtgever dat het informatiesysteem makkelijk op te zetten moet zijn met behulp van 
Docker. Hierbij is het de bedoeling dat alles met een klik op de knop opgestart wordt.
Naast het kunnen opstarten van het informatiesysteem, is het ook wenselijk dat de database en de
Redis cache voor het ontwikkelteam makkelijk op te zetten zijn.

## 3 Methoden

Om de gewenste technische methoden te kunnen testen die wij van plan zijn om te gebruiken in het huidige 
project, maken wij gebruik van prototypes. 
Per prototype wordt er op verschillende manieren gekeken of de methoden werken zoals wij verwachten.

### 3.1 Prototype

Per elaboratie onderdeel gedefinieerd in hoofdstuk 2, wordt een prototype gemaakt om de basis van de 
functionaliteiten die wij verwachten te kunnen testen.

Voor de staging area wordt getest of er met behulp van Python een connectie met MSSQL mogelijk is, 
om vervolgens de data op te halen en op te slaan in een Redis-cache.
Ook wordt getest of er met behulp van Python een connectie met een Redis-cache kan worden gemaakt om
vervolgens hieruit data op te halen en op te slaan in een CSV-bestand.

Bij Faker, die uiteindelijk onze testdata gaat genereren, wordt getest of op basis van een kolomstructuur en de 
kwantiteit van de data die wij willen genereren, de data gegenereerd kan worden.
Dit wordt ook gedaan met behulp van Python, die de gegenereerde data uiteindelijk in de MSSQL zet.

Voor Docker wordt getest of er een Docker container opgezet kan worden met behulp van Docker Compose. Deze docker
container moet Microsoft SQL Server en een Redis cache hosten.

## 4 Resultaten

Voor elk elaboratie onderdeel zijn prototypes gemaakt, voor elk prototype zijn hieronder de resultaten opgeschreven 
van onze ondervindingen op de methoden. 

### 4.1 Staging area

Per onderdeel van het uiteindelijke prototype is er een aparte test gedaan. Als eerst is het geschreven script 
geslaagd om een connectie te maken met de MSSQL database en daar data uit te halen. 
Vervolgens is een tweede script erin geslaagd om een connectie te maken met de Redis-cache en daar data in op te slaan.
Deze twee scripts zijn gecombineerd in één script dat de eerste functionaliteit van de staging area vervult. Ook het script dat 
data op zou moeten halen uit de Redis cache heeft met succes data uit de Redis cache gehaald.

### 4.2 Faker

Het script dat met behulp van de Faker library testdata moest genereren heeft met succes een variabele 
hoeveelheid data kunnen genereren en op kunnen slaan in de MSSQL database. Om de hoeveelheid data variabel te houden is
een functionaliteit in het prototype ingebouwd waarbij een waarde wordt gevraagd voor het aantal data dat het script
opslaat in de MSSQL database. Dit script vraagt ook een waarde voor het aantal data wat deze moet genereren, zodat je
zelf controle hebt over de kwantiteit van de testdata die gegenereerd wordt.

### 4.3 Docker

De volledige functionaliteit die wij van de Docker verwacht hadden, was aardig snel opgezet. Na twee middagen
stond er een Docker Compose bestand die een instantie van MSSQL en Redis opstart. Daarnaast voert Docker
SQL-scripts in een bepaalde map uit op alfabetische volgorde tijdens het opstarten, zodat je een create- en insert 
script kan uitvoeren.

## 5 Conclusie

Voor elk elaboratie onderdeel is een prototype gemaakt en getest. Hieruit is gebleken dat de methoden die wij
gebruiken voor de staging area, faker en docker werken zoals wij en de opdrachtgever verwachten. 
Op basis van de prototypes gaan wij deze onderdelen tijdens het project verder uitwerken zodat het de 
functionaliteiten bevat die deze onderdelen aan het eind van het project moeten hebben.