# Plan van aanpak - Best Fit Gym

## Inhoudsopgave
- [1 Inleiding](#1-inleiding)
- [2 Achtergrond van het project](#2-achtergrond-van-het-project)
- [3 Doelstelling, opdracht en op te leveren resultaten voor het bedrijf](#3-doelstelling-opdracht-en-op-te-leveren-resultaten-voor-het-bedrijf)
- [4 Projectgrenzen](#4-projectgrenzen)
- [5 Randvoorwaarden](#5-randvoorwaarden)
- [6 Op te leveren producten en kwaliteitseisen](#6-op-te-leveren-producten-en-kwaliteitseisen)
- [7 Ontwikkelmethode](#7-ontwikkelmethode)
- [8 Projectorganisatie en communicatie](#8-projectorganisatie-en-communicatie)
- [9 Planning](#9-planning)
- [10 Risico's](#10-risicos)

## Accordering

Opdrachtgever akkoord:

| **Naam**          | **Datum**  | **Accordering** |
|-------------------|------------|-----------------|
| Matthijs de Jonge | 26-04-2023 | Akkoord         |

Projectbegeleider akkoord:

| **Naam**        | **Datum**  | **Accordering** |
|-----------------|------------|-----------------|
| Frank Tempelman | 26-04-2023 | Akkoord         |

## 1. Inleiding
Het doel van dit document is om een algemene visie te beschrijven en afspraken te maken met de opdrachtgever en het team onderling over het project. 
Met behulp van het plan van aanpak kunnen eventuele obstakels en risico's vastgesteld worden en hier strategieën voor gemaakt worden.

De opdracht van dit project is om een database te ontwikkelen dat de bedrijfsprocessen van Best Fit ondersteunt. 
Best Fit is een sportschool die verschillende fitnessgerelateerde diensten aanbiedt, zoals cardio- en krachttraining, groepslessen en squashbanen. 
Het systeem moet abonnementen en informatie over klanten vastleggen en groepsles- en machine-reserveringen beheren van de sportschool.

In dit document worden verschillende onderdelen besproken zodat alle zaken rondom het project voor de opdrachtgever en 
het ontwikkelteam duidelijk zijn. Eerst wordt de achtergrond van het project besproken waarin de aanleiding, context en 
motivatie van het project worden uitgelegd. Hierna staan de doelstelling, de opdracht en de verwachte resultaten, waar het uiteindelijke beeld van 
het project wordt geschetst. Om duidelijkheid te krijgen wat er van het ontwikkelteam precies verwacht wordt, worden de projectgrenzen vastgesteld,
waarin te vinden is wat net binnen of buiten de scope van het project valt. Dit wordt vervolgd met de randvoorwaarden 
die nodig zijn om het project te laten slagen. Vervolgens wordt vastgesteld welke ontwikkelmethode het team gaat gebruiken en hoe dit in het huidige project wordt 
toegepast. Binnen het team zijn verschillende afspraken en onderverdelingen vastgesteld, deze staan zijn vermeld in de projectorganisatie.
Verder staat de planning voor het aankomende project beschreven met daarbij per projectfase de tijdsduur en welk deelproduct aan het eind van de fase wordt
verwacht. Tot slot worden de mogelijke project- en technische risico's vastgelegd, met daarbij de tegenmaatregels en 
uitwijkstrategieën, zodat we zo veel mogelijk problemen zo snel mogelijk kunnen oppakken.

## 2 Achtergrond van het project
Best Fit is een moderne sportschool die een breed scala aan fitnessgerelateerde diensten aanbiedt. 
Er zijn veel machines beschikbaar voor cardio- en krachttraining, terwijl Best Fit ook groepslessen aanbiedt voor 
activiteiten zoals spinning, kickboksen, yoga en hip hop dansen. 
De sportschool heeft vier grote kamers beschikbaar voor deze groepslessen. 
Daarnaast heeft Best Fit drie squashbanen die gebruikt kunnen worden door de leden en zijn er fitnessruimtes met machines. 
Voor deze squashbanen, groepslessen en machines is het de bedoeling dat een lid een plek reserveert om aan de betreffende activiteit mee te 
kunnen doen.

De reden dat deze opdracht nu wordt uitgevoerd, is omdat Best Fit op dit moment problemen ervaart met overzichtelijkheid 
van alle leden en reserveringen. Hiervoor is het nodig dat er een oplossing komt die helpt met het bijhouden van leden,
abonnementen en reserveringen, die hen deze overzichtelijkheid kan bieden. Deze oplossing zal de business processen van 
Best Fit moeten ondersteunen. 

### 2.1 Stakeholders

Binnen het kader van dit project worden de stakeholders gedefinieerd als de partijen die belang hebben bij het slagen van 
het project, onafhankelijk van de betrokkenheid bij de ontwikkeling hiervan. Om als stakeholder geclassificeerd te worden, 
moet een correlatie zijn tussen de belangen van de partij en het gebruiksgemak van de werkzaamheden die op het eindresultaat 
van het project worden verricht. Alle stakeholders zijn in samenspraak met de opdrachtgever in kaart gebracht. Hieronder 
staat een lijst van alle stakeholders.

- Opdrachtgever Best Fit
- Toekomstige ontwikkelaars van het resultaat van het project
- Leden van Best Fit
- Medewerkers van Best Fit

De belangen van de opdrachtgever komen voort uit de aanleiding van dit project. De opdrachtgever heeft er namelijk baat 
bij dat de business processen worden ondersteund door een overzicht te creëren van leden, abonnementen en reserveringen. 
De toekomstige ontwikkelaars van het resultaat van dit project zullen dit resultaat beheren en eventueel verder uitbreiden 
naar de wensen van de opdrachtgever. Deze ontwikkelaars hebben er dan ook belang bij dat alle werkproducten traceerbaar, 
onderhoudbaar en uitbreidbaar zijn. Wat hiervoor nodig is, is een duidelijke documentatie van alle keuzes die gemaakt zijn 
binnen het project en, wanneer er sprake is van code, dient er een goede traceerbaarheid te zijn naar de eisen die opgesteld 
zijn in het functioneel ontwerp.
Tot slot hebben de leden en medewerkers van Best Fit belang bij het succes van dit project op een niveau van gebruik en privacy. 
Voor deze leden en medewerkers moet het namelijk mogelijk zijn om sneller en met meer eenvoud persoonlijke roosters in te zien, 
reserveringen te plaatsen en voor de leden om hun abonnementen te beheren. Daarnaast worden persoonlijke gegevens opgeslagen. Het belang 
van de leden en medewerkers gaat op dit punt over de bescherming van persoonsgegevens. 

## 3. Doelstelling, opdracht en op te leveren resultaten voor het bedrijf
Om een project goed uit te kunnen voeren en de gewenste producten op te leveren bij het bedrijf is het belangrijk om duidelijk
te hebben wat de uitdaging van het bedrijf is. Het probleem van Best Fit is dat er geen goede manier was om informatie over
leden bij te houden. Voor een sportschool is het erg belangrijk dat deze informatie klopt en snel opgehaald kan worden.

Best Fit wil een informatiesysteem laten ontwikkelen dat het bedrijfsproces van Best Fit ondersteunt. Als ontwikkelteam gaan wij
dit informatiesysteem realiseren. Het moet mogelijk worden voor leden van Best Fit om
hier hun abonnement te verlengen, veranderen of opzeggen. Ook moeten leden hun rooster met inschrijvingen in kunnen zien 
en moet het mogelijk worden voor leden om zich in te schrijven voor groepslessen, fitness machines en squashbanen.

Wanneer het project afgelopen is kan Best Fit van het ontwikkelteam verwachten dat de volgende deelproducten opgeleverd zijn:
- SQL code (inclusief unit tests)
- Plan van aanpak
- Functioneel Ontwerp
- Technisch Ontwerp
- Testplan
- Testrapport
- Installatiehandleiding
- Staging area
- Docker container

## 4. Projectgrenzen
Om bij het aankomende project een inzicht te geven wat het ontwikkelteam wel en niet gaat doen, hebben we dit hieronder 
aangegeven. Het doel hiervan is het duidelijk maken wat wij verwachten en wat er van ons verwacht wordt.

### Wat kan er van het ontwikkelteam verwacht worden

| **Inhoudelijke verwachtingen**                                                                                                                     | **Procesmatige verwachtingen**                                                        |
|----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------|
| Het ontwikkelteam maakt een MSSQL database volgens de eisen van de opdrachtgever.                                                                  | Het ontwikkelteam werkt 8 uur per werkdag. Dit is inclusief 1 uur pauze.              |
| Het ontwikkelteam zorgt dat er een staging area met behulp van Redis caching is. Deze werkt samen met de MSSQL database.                           | In de 40 uur per week kan een teamlid 8 uur per week aan zijn of haar verslag werken. |
| Aan het eind van het project maakt het ontwikkelteam een docker container met de MSSQL database en een Redis cache voor Intel en ARM-architectuur. |                                                                                       |
| Alle SQL code wordt getest volgens het testplan.                                                                                                   |                                                                                       |
| Alle producten die onder hoofdstuk 6 "Op te leveren producten en kwaliteitseisen" vallen, worden opgeleverd.                                       |                                                                                       |

### Wat gaat het ontwikkelteam niet doen

| **Inhoudelijke grenzen**                                                                                                                        | **Procesmatige grenzen**                                               |
|-------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|
| Functionaliteiten die niet in een testscenario in het testplan zijn opgenomen worden niet getest. Er wordt dus niet buiten het testplan getest. | Werken aan het project na de einddatum (2023-06-09).                   |
| Het ontwerpen en realiseren van een volledige backend en frontend.                                                                              | Een teamlid kan niet verplicht worden om buiten kantooruren te werken. |
| Opzetten en onderhouden van de database op de server van de opdrachtgever.                                                                      |                                                                        |
| Het verwerken van echte- of test data in de sql script files.                                                                                   |                                                                        |
| Meer producten leveren dan benoemd in hoofdstuk 6 "Op te leveren producten en kwaliteitseisen".                                                 |                                                                        |

## 5. Randvoorwaarden
De randvoorwaarden zijn voorzieningen die wij nodig hebben om het project uit te kunnen voeren. In dit hoofdstuk vermelden
wij wat er voor dit ontwikkelteam nodig is om het werk goed te kunnen doen en wie er verantwoordelijk zijn om deze benodigdheden te regelen. 
Als deze voorzieningen niet beschikbaar zijn wanneer wij ze nodig hebben kan dit betekenen dat het project te laat of met verminderde functionaliteit opgeleverd wordt. 

Voor dit project gelden de volgende randvoorwaarden:
- De opdrachtgever is minimaal één keer per week beschikbaar voor een vergadering.
- De opdrachtgever reageert binnen twee werkdagen op een e-mail.
- De HAN-organisatie zorgt ervoor dat er tijdens werkuren werkruimtes van de HAN beschikbaar zijn.
- De procesbegeleider zorgt er voor dat er gedurende het project accounts beschikbaar zijn van Bitbucket, Jira en Microsoft Teams.

## 6. Op te leveren producten en kwaliteitseisen
Ieder op te leveren product, voor zowel de opdrachtgever als school, staat hieronder in de tabel uitgelegd. Per product
is er SMART geformuleerd aan welke kwaliteitseisen deze moet voldoen, uitgelegd welke activiteiten er gedaan moeten worden om
tot een goed product te komen en uitgelegd hoe de kwaliteit van het product gecontroleerd wordt.

| Product                | Productkwaliteitseisen                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Benodigde activiteiten om te komen tot het product                                                                                                                                                                                                                                                                                   | Proceskwaliteitseisen                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Plan van aanpak        | Aan het einde van de inceptie-fase geldt het volgende: Het Plan van Aanpak volgt de opbouw van het document 'Toelichting op PvA AIM versie 4.0'. In het Plan van Aanpak is overzichtelijk welke deelproducten opgeleverd zullen worden en is de aanleiding van het project beschreven.                                                                                                                                                                                                                                                                                                                                                          | Er worden gesprekken gevoerd met de opdrachtgever om een helder beeld van de opdracht te krijgen. De hoofdstukken uit Toelichting plan van aanpak AIM Versie 4.0 worden verwerkt in het plan van aanpak.                                                                                                                             | Wanneer een onderdeel van het Plan van Aanpak in Jira op 'review' wordt geplaatst, zal het onderdeel door twee mensen worden nagekeken volgens de definition of done en de eerder genoemde productkwaliteitseisen, zodat dit van feedback kan worden voorzien.                                                                                                                                                                                                              |
| Elaboratie onderzoek   | Tijdens de elaboratie-fase wordt onderzocht welke technische risico's een knelpunt zullen veroorzaken voor het ontwikkelteam. Hierbij wordt beschreven voor welke technische onderdelen een prototype gemaakt zal worden en op welke wijze dit zal gebeuren. Daarnaast worden concreet de resultaten van het onderzoek beschreven, waaruit blijkt of de gestelde risico's technisch mogelijk zijn.                                                                                                                                                                                                                                              | Er wordt een plan gemaakt waarop de technische risico's zullen worden onderzocht. Het onderzoek dat is opgesteld wordt uitgevoerd en de resultaten worden genoteerd. Uit de resultaten volgt een logische conclusie, die beantwoordt of het concept van het project haalbaar is.                                                     | Wanneer het Elaboratie Onderzoek op in Jira op 'review' wordt geplaatst, zal het door twee mensen worden nagekeken volgens de definition of done en de eerder genoemde productkwaliteitseisen, zodat dit van feedback kan worden voorzien.                                                                                                                                                                                                                                  |
| Functioneel ontwerp    | Aan het einde van de elaboratie-fase geldt het volgende: Er geldt een duidelijke nummering tussen user stories, functionele eisen en use cases, zodat de traceerbaarheid hiervan gewaarborgd wordt. De modellen en diagrammen dienen uniform te zijn en betrekking te hebben tot eerder benoemde use cases.                                                                                                                                                                                                                                                                                                                                     | Er worden op basis van een interview met de opdrachtgever user stories uitgewerkt. Deze user stories worden uitgebreid naar functionele eisen en uiteindelijk use cases. Op basis van de use cases worden verwoordingen gemaakt, om hierna een conceptueel datamodel op te stellen, inclusief business rules en een interactiemodel. | Wanneer een onderdeel van het Functioneel Ontwerp in Jira op 'review' wordt geplaatst, zal het door twee mensen worden nagekeken volgens de definition of done en de eerder genoemde productkwaliteitseisen. Tijdens het proces wordt bij twijfel en vragen advies gevraagd bij vakdocenten, om het eindresultaat van het product te verbeteren.                                                                                                                            |
| Technisch ontwerp      | Aan het einde van de elaboratie-fase is een eerste versie van het technisch ontwerp opgesteld. Hierbij zijn volgens een traceerbare nummering de niet-functionele eisen opgenomen, samen met een model van de systeemarchitectuur, technische gegevensstructuur (inclusief fysiek datamodel) en een technisch realisatie interface. Alle ontwerpkeuzes worden beargumenteerd vanuit de use cases en zijn traceerbaar volgens de nummeringen die in het functioneel ontwerp opgesteld zijn. Tijdens de constructie-fase wordt het technisch ontwerp aangevuld met nieuwe ontwikkelingen en functionaliteiten die op dat moment naar voren komen. | Op basis van een interview met de opdrachtgever worden niet-functionele eisen opgesteld. Op basis van zowel de functionele als niet-functionele eisen worden de modellen gemaakt die benoemd zijn bij de productkwaliteitseisen.                                                                                                     | Wanneer een onderdeel van het Technisch Ontwerp in Jira op 'review' wordt geplaatst, zal het door twee mensen worden nagekeken volgens de definition of done en de eerder genoemde productkwaliteitseisen. Tijdens het proces wordt bij twijfel en vragen advies gevraagd bij vakdocenten, om het eindresultaat van het product te verbeteren.                                                                                                                              |
| SQL code               | Aan het einde van de constructie-fase geldt het volgende: Alle procedures, triggers, views en business rules worden tijdens de ontwikkeling in de constructie-fase getest volgens het testplan. De SQL code komt overeen met het ontwerp dat gemaakt is in het Technisch Ontwerp en is traceerbaar naar het Functioneel Ontwerp. Verder voldoet de code aan de kwaliteitseisen die gegeven zijn in de definition of done.                                                                                                                                                                                                                       | Er worden SQL-scripts en tests geschreven volgens het testplan. Hierbij wordt gelet op de traceerbaarheid van de use cases. Testresultaten worden genoteerd in het testrapport en aan het eind van elke iteratie in de constructie-fase wordt de voortgang gedeeld met de opdrachtgever.                                             | Wanneer een pull request wordt aangemaakt, wordt deze door twee mensen nagekeken. Er wordt hierbij gecontroleerd of de kwaliteit van de code voldoet aan de definition of done en de productkwaliteitseisen en wordt het document grondig getest volgens het testplan. De resultaten van deze tests worden opgenomen in het testrapport.                                                                                                                                    |
| Staging area           | Aan het einde van de constructie-fase geldt het volgende: Elke keer dat een Jira code-taak wordt opgepakt, wordt de geschreven code getest volgens het testplan.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Er wordt op basis van het conceptueel datamodel in het Functioneel Ontwerp een eerste versie van de MSSQL server opgezet. Hiernaast wordt een Redis omgeving opgesteld, die de staging area zal vormen. Deze twee onderdelen worden met elkaar verbonden.                                                                            | Wanneer een pull request wordt aangemaakt, wordt deze door twee mensen nagekeken. Er wordt hierbij gecontroleerd of de functionaliteit werkt volgens de definition of done en de productkwaliteitseisen en wordt grondig getest volgens het testplan. De resultaten van deze tests worden opgenomen in het testrapport.                                                                                                                                                     | 
| Testplan               | Tijdens de constructie-fase wordt het testplan bijgehouden, zodat gecontroleerd wordt of de user stories van het Functioneel Ontwerp op een correcte wijze verwerkt zijn. In het testplan wordt genoteerd wat getest wordt, hoe dit getest wordt en welke middelen nodig zijn om het te testen. Daarbij wordt bij elke test genoteerd op welke use case dit betrekking heeft, om de traceerbaarheid te waarborgen.                                                                                                                                                                                                                              | Wanneer nieuwe code wordt geschreven, wordt het testplan aangevuld met de informatie die benoemd is in de productkwaliteitseisen.                                                                                                                                                                                                    | Wanneer een pull request wordt aangemaakt, wordt de code hierin door de reviewers getest. Hierbij worden de testscenario's uitgevoerd zoals deze beschreven zijn in het testplan. Dit wordt door zowel de auteur als de twee reviewers gedaan. De reviewers controleren of het testplan aan de definition of done en productkwaliteitseisen voldoet, zodat dit van feedback kan worden voorzien.                                                                            |
| Testrapport            | Aan het eind van de constructie-fase dient het testrapport de resultaten van de testscenario’s te bevatten. De resultaten van de tests zijn op een heldere manier uitgewerkt, zodat deze leesbaar is voor de opdrachtgever. Dit testrapport zal dan ook als een garantie gelden dat de applicatie grondig getest is.                                                                                                                                                                                                                                                                                                                            | Er worden testscenario's uitgevoerd die zijn opgesteld in het testplan. De resultaten hiervan worden beschreven. Hierbij wordt gelet op de traceerbaarheid.                                                                                                                                                                          | Wanneer het testrapport in Jira op 'review' wordt geplaatst, zal het door twee teamleden nagekeken volgens de definition of done en de eerder genoemde productkwaliteitseisen, zodat dit van feedback kan worden voorzien.                                                                                                                                                                                                                                                  |
| Installatiehandleiding | Aan de hand van de installatiehandleiding kan het eindproduct geïnstalleerd worden. Hiervoor mag geen voorkennis van de gebruikte software vereist zijn. Het document dient dus dermate duidelijk te zijn zodat iemand zonder vakkennis, de applicatie kan installeren. Dit document wordt in de transitie-fase opgeleverd.                                                                                                                                                                                                                                                                                                                     | Er wordt een stappenplan opgesteld die doorlopen moet worden om de applicatie te installeren. Dit wordt op een helder leesbare, bondige manier beschreven.                                                                                                                                                                           | Wanneer de installatiehandleiding in Jira op 'review' staat, zal een teamlid het eindproduct aan de hand van de handleiding installeren. Zo is het makkelijk in beeld te brengen of de handleiding duidelijk en nuttig is. Een ander teamlid zal de handleiding nalezen en controleren of het aan de definition of done en productkwaliteitseisen voldoet, zodat dit van feedback kan worden voorzien. Op deze manier wordt het document dus door twee teamleden nagekeken. |
| Projectverslag         | De gevraagde onderdelen die in het document 'Alle info over het schrijven van het projectverslag v21-22' staan, moeten aanwezig zijn. Het verslag moet overeen komen met de waarnemingen van de docent. De tekst moet goed onderbouwd zijn met voldoende bewijsmateriaal. Dit document wordt door het hele project heen aangevuld. De laatste versie van het verslag wordt opgeleverd aan de projectbegeleider in de transitie-fase.                                                                                                                                                                                                            | Hoofdstukken uit 'Alle info over het schrijven van het projectverslag v21-22' worden verwerkt in het projectverslag aan de hand van de eisen die geformuleerd staan in het nakijkmodel. Hierbij wordt een factsheet bijgehouden, waarin de individuele bijdrage genoteerd staat inclusief toelichting.                               | Tijdens het project wordt het projectverslag gaandeweg aangevuld. Hierover wordt wekelijks gesproken met de Professional Skills begeleider, volgens de afspraken die gemaakt zijn in hoofdstuk 8.                                                                                                                                                                                                                                                                           |

### 6.1 Definition of Done
Om per product een makkelijk overzicht te krijgen of het voldoet aan de standaard kwaliteiteisen binnen het team, zijn
hieronder eisen opgesteld waar elk product aan moet voldoen, met eerst algemene eisen die voor elk product gelden.

- Het product is door 2 groepsleden, die het product niet zelf hebben gemaakt, nagekeken.
- Het product staat op het versiebeheersysteem (BitBucket).
- Het product staat op de branch development.
- De taak staat op done op het Jira-board en de resterende tijd op de desbetreffende taak is 0 minuten.

Als het product SQL-code bevat:
- Alle SQL-code voldoet aan de guidelines van IBM (https://www.ibm.com/docs/en/opw/8.2.0?topic=guide-sql-coding-guidelines).
- Voor de SQL-code die geschreven is, zijn ook nuttige unittests geschreven.
- De unittests die geschreven zijn, zijn toegevoegd aan het testplan.
- Bij elke stored procedure, trigger of view staat commentaar om toe te lichten wat de functionaliteit is van het stuk code en bij welke user story het hoort.
- Alle code en commentaar is geschreven in het Engels.
- De reviewers hebben het testplan voor het stuk code doorlopen en de resultaten opgeschreven in het testrapport.

Als het product Python-code bevat:
- Alle Python-code voldoet aan de guidelines van Google (https://google.github.io/styleguide/pyguide.html).
- Voor de Python-code die geschreven is, zijn ook nuttige unittests geschreven.
- De unittests die geschreven zijn, zijn toegevoegd aan het testplan.
- Alle code en commentaar is geschreven in het Engels.
- De reviewers hebben het testplan voor het stuk code doorlopen en de resultaten opgeschreven in het testrapport.

Als het product documentatie bevat:
- Alle documentatie is volledig in het Nederlands, behalve vaktermen of termen die gebruikt zijn voor het project.

## 7. Ontwikkelmethode
Tijdens dit project wordt gebruik gemaakt van de projectmethode Rational Unified Process, hierna te noemen RUP. RUP is 
tot stand gekomen door aspecten te analyseren waarop projecten mislukken en op basis hiervan best practices te formuleren
om deze mislukkingen te voorkomen.

De RUP-methode incrementeel en iteratief, wat inhoudt dat het project over een herhalende 
tijd (een iteratie) in delen opgeleverd kan worden. RUP bestaat uit vier fasen, namelijk de inceptie, elaboratie, constructie 
en transitie. Tijdens deze fasen kunnen meerdere iteraties plaatsvinden. Bij elke fase hoort een aantal deelopleveringen, 
hierna te noemen deliverables. 
Tot slot kent RUP een aantal rollen. Deze rollen zijn bedacht op basis van de diverse disciplines die nodig zijn om een 
project succesvol te voltooien. Deze rollen zijn de informatie-analist, use case ontwerper, software-architect, 
programmeur en tester. Over deze rollen is later in dit hoofdstuk meer te lezen.

### 7.1 Projectfasen
Zoals eerder benoemd bestaat RUP uit vier fasen. Dit zijn de inceptie, elaboratie, constructie en transitie. Deze fasen 
hebben elk een bepaalde tijdsduur en een verzameling deliverables die aan het eind van de fase opgeleverd worden. Hieronder 
wordt per fase de manier beschreven waarop deze fasen worden toegepast binnen dit project.

#### 7.1.1 Inceptie
Het doel van de inceptie-fase is om op hoog niveau een overzicht te krijgen over de doelen van het project, waarbij de 
belangrijkste risico's in beeld zijn gebracht en een planning wordt gemaakt voor de elaboratie-fase. Bij deze fase hoort
in schoolcontext slechts één deliverable. Dit is het plan van aanpak. In dit document worden de algemene afspraken
die gelden binnen het project vastgesteld en wordt een algemene planning voor het project opgesteld.

RUP kent echter nog andere documenten in de inceptie-fase, namelijk de visie, het software development plan, de risk list, 
het use case model en het acceptatieplan. Behalve het use case model wordt de kern van elk van deze documenten opgenomen 
in het plan van aanpak. Het use case model wordt echter opgeschoven naar het functioneel ontwerp, dat opgeleverd zal worden 
in de elaboratie-fase. 

#### 7.1.2 Elaboratie
De elaboratie-fase draait om het opstellen van de meest kritische requirements en het opstellen van een stabiele 
softwarearchitectuur. Hierbij wordt een algemeen ontwerp van de software gemaakt, waarbij een stabiele architectuur 
opgesteld wordt en gekeken wordt of er een duidelijk beeld is van de planning en scope van het project. 
Verder wordt er een functioneel ontwerp gemaakt, waarin onder andere de use cases worden uitgewerkt, 
de requirements worden opgesteld en een conceptueel datamodel wordt weergegeven. Ook wordt er een technisch ontwerp geschreven. 
Hierin zul je onder andere de technische keuzes vinden die gemaakt zijn voor het project en een fysiek datamodel. 

Bij RUP is het belangrijk dat de traceerbaarheid gewaarborgd wordt. Het moet te achterhalen
zijn welke functionele eisen hebben geleid tot welke ontwerpkeuzes. Dit kan gedaan worden door eisen te nummeren en deze nummering
aan te houden. Het is vooral belangrijk dat er goed op traceerbaarheid gelet wordt tijdens de elaboratie-fase aangezien
dit de fase is waar de eisen leiden tot een ontwerp.

In de elaboratie-fase worden in dit project vier deliverables opgeleverd. Deze deliverables zijn de eerste versies van het 
functioneel ontwerp, technisch ontwerp en een architectureel prototype. Alle deliverables die normaal in de 
elaboratie-fase van RUP worden opgeleverd zijn onderverdeeld in de vier deliverables die hierboven zijn beschreven. 
Use case specifications worden opgenomen in het functioneel ontwerp, samen met het use case model van de inceptie-fase en het 
testplan. Het software-architectuur document wordt opgenomen in het technisch ontwerp, samen met eventuele UML-diagrammen 
die gemaakt worden bij het ontwerp van de software. Het proof of concept van de staging area wordt samengevoegd met het architectureel prototype. 
We leveren dit in deze fase op omdat we vroegtijdig een vertaling van SQL Server naar Redis willen maken. 

Tijdens de elaboratie-fase gaan we ook alvast verschillende datastructuren proberen te genereren met Faker, zodat vroegtijdig bekend is of Faker nuttig is voor ons project.

#### 7.1.3 Constructie
In dit project bestaat de constructie-fase uit drie iteraties. In elk van deze iteraties worden het functioneel ontwerp en 
het technisch ontwerp aangevuld met nieuwe informatie die gewonnen wordt uit uitdagingen die het ontwikkelteam tegenkomt of 
nieuwe gesprekken met de opdrachtgever. Daarnaast wordt in deze fase het eindproduct gebouwd. In de context van dit project 
wordt dit het informatiesysteem met staging area. De deliverables van de constructie-fase zijn de volledige versies van het 
functioneel ontwerp, het technisch ontwerp en het eindproduct. Dit wijkt niet af van het normale RUP-proces. Tijdens de 
constructie-fase wordt de applicatie uiteraard grondig getest. Hierbij wordt voor elke nieuwe functionaliteit het testplan 
aangevuld, waarbij de resultaten worden opgenomen in het testrapport. 

Tijdens de constructie-fase gaan wij gebruik maken van Daily Stand Ups. 
Dit is niet een standaard onderdeel van RUP, maar is wel een best practice die wij toepassen. Daily Stand Ups zijn korte dagelijkse vergaderingen
waarin we bespreken wat we de afgelopen dag hebben gedaan, wat we die dag gaan doen en of we problemen tegen zijn gekomen of verwachten.
We willen zo de voortgang van het project in de gaten houden en eventuele problemen in de gaten houden.

#### 7.1.4 Transitie
In de transitie-fase wordt het eindproduct overgedragen aan de opdrachtgever. Hierbij zijn de laatste bugs uit het 
eindproduct gefixt en wordt gekeken of het eindproduct voldoet aan de acceptatiecriteria. Alle deliverables worden in hun 
definitieve staat opgeleverd.

Naast het controleren van de acceptatiecriteria wordt ook een installatiehandleiding gemaakt. Hierin wordt toegelicht hoe 
de opdrachtgever het eindproduct kan installeren en beheren. Hierbij wordt de opdrachtgever ook opgeleid om het eindproduct 
met succes te kunnen gebruiken. 

### 7.2 Rollen
Naast de projectfasen met hun deliverables kent RUP ook een aantal rollen. Deze rollen zijn de software-architect, 
use case ontwerper, tester, informatieanalist en programmeur. Elk van deze rollen is verdeeld over de 
groepsleden. Aangezien de projectgroep bestaat uit zes mensen en er vijf rollen zijn, wordt de rol programmeur door twee leden gevuld. 
Hieronder zullen alle rollen met hun verantwoordelijkheden binnen dit project beschreven worden.

#### 7.2.1 Software-architect
De software-architect is verantwoordelijk voor het ontwerpen van de code. Hij beargumenteert en documenteert de technische 
keuzes die binnen het project gemaakt worden. De software-architect bepaalt de technische grenzen van het project en 
houdt toezicht op de implementatie en controleert of deze verloopt volgens het opgestelde ontwerp. In schoolcontext 
betekent dit echter niet dat de software-architect het volledige ontwerp maakt van de applicatie. Het ontwerp wordt 
uiteraard gemaakt in teamverband. Wel is de software-architect eindverantwoordelijke voor het verloop van dit proces. 

#### 7.2.2 Use case ontwerper
De use case ontwerper is, vanzelfsprekend, eindverantwoordelijke voor het ontwerpen van de use cases. Hierbij worden de 
use cases opgesteld en wordt gewaarborgd of deze correct worden geïmplementeerd. De use case ontwerper is dan ook 
verantwoordelijk voor het waarborgen van de traceerbaarheid van de use cases. 
Naast het waarborgen van de use cases zelf, is de use case ontwerper verantwoordelijk voor eventuele schermontwerpen en 
het schermverloop van de applicatie. Bij de bouw van een informatiesysteem zal dit weinig aan de orde zijn, echter is het 
wel mogelijk dat er views worden gemaakt. Hier zal de use case ontwerper dan ook eindverantwoordelijke voor zijn.

#### 7.2.3 Tester
De tester is verantwoordelijk voor de testbaarheid van de applicatie. Hij overziet het schrijven van testcases, de 
vastlegging hiervan in de testdocumentatie en de uitvoering van de tests. Bij elke pull request die gemaakt wordt is het 
zaak dat de code van de pull request grondig getest is. De tester waarborgt dat dit gebeurt. Hij controleert bij nieuwe 
code of hier tests voor geschreven zijn en gedocumenteerd zijn in de gepaste documentatie. Hiermee waarborgt hij de 
kwaliteit van de geschreven tests.

#### 7.2.4 Informatieanalist
De informatieanalist is verantwoordelijk voor het helder krijgen van de requirements en het hieruit modelleren van de 
use cases. Dit zorgt ervoor dat de projectgrenzen bepaald kunnen worden en de functionaliteit van het eindproduct in beeld 
wordt gebracht. De informatieanalist is verantwoordelijk voor het vertalen van de belangen van de opdrachtgever naar heldere use cases.

#### 7.2.5 Programmeur
De programmeur is verantwoordelijk voor het technisch ontwerpen, ontwikkelen, documenteren en testen van de gevraagde 
software. Dit is een heel breed spectrum aan verantwoordelijkheden en is hierom wellicht de meest gevarieerde rol. Hoewel 
elk teamlid binnen dit project de taken van de programmeur zal uitvoeren, zijn twee personen aangesteld als eindverantwoordelijken. 
Zij waarborgen het algemene overzicht over het ontwikkelproces van de software en waarborgen hiermee de kwaliteit hiervan.

## 8. Projectorganisatie en communicatie
Tijdens dit project wordt gewerkt in teamverband en vindt er communicatie plaats tussen meerdere partijen. In dit hoofdstuk wordt beschreven
wie er allemaal betrokken zijn bij het project, hoe ze betrokken zijn en een email adres waarop ze te bereiken zijn. Verder
zijn er afspraken gemaakt binnen het team, deze worden in dit hoofdstuk ook beschreven.

### 8.1 Projectleden
Het ontwikkelteam bestaat uit zes personen. De teamleden hebben een unieke rol binnen het project. 
Deze rollen houden in dat het teamlid de verantwoordelijk neemt over de bijbehorende taken. Hieronder is een overzicht:  

| Naam                   | E-mail                         | Rol                |
|------------------------|--------------------------------|--------------------|
| Cédric van Lenthe      | CM.vanLenthe@student.han.nl    | Software architect |
| Jordan Geurtsen        | J.Geurtsen1@student.han.nl     | Informatieanalist  |
| Maartje Westerman      | MJ.Westerman@student.han.nl    | Tester             |
| Marnix Wildeman        | MA.Wildeman@student.han.nl     | Programmeur        |
| Mitchell van Rijswijk  | M.vanRijswijk2@student.han.nl  | Use case ontwerper |
| Lucas van Steveninck   | L.vanSteveninck@student.han.nl | Programmeur        |

Verdere betrokkenen bij het project zijn:
- Opdrachtgever: Matthijs de Jonge - Matthijs.deJonge@han.nl
- Procesbegeleider: Frank Tempelman - Frank.Tempelman@han.nl
- Professional skills docent: Nils Bijleveld - Nils.Bijleveld@han.nl

### 8.2 Afspraken binnen het team
- De werkdagen zijn van 9:15 tot 17:15 uur van maandag tot en met vrijdag.
- Als een groepslid te laat is, betekent dit dat het dat het groepslid de tijd dat hij/zij te laat is gekomen moet doorwerken. Dit geldt alleen als dit groepslid geen valide reden heeft.
- De communicatie voor afspraken over meetings, welk lokaal er wordt gereserveerd en eventuele vertragingen zal verlopen via WhatsApp. 
- Inhoudelijke projectdetails zullen via Microsoft Teams worden besproken.
- Zijn er belangrijke zaken die niet gemeld worden? Dan zal de consequentie zijn dat dit gedrag zal worden aangegeven bij de procesbegeleider en eventuele andere relevante docenten.

### 8.3 Communicatie met de betrokkenen
De betrokkenen bij het project worden op de hoogte gehouden van de voortgang van het project door middel van wekelijkse meetings.
De opdrachtgever, Matthijs de Jonge, is op maandagochtend en donderdagen beschikbaar. Met hem worden de opdracht en de resultaten van de voorgaande week besproken.
De procesbegeleider, Frank Tempelman, is op donderdagen beschikbaar. Met hem worden het proces en de communicatie van de voorgaande week besproken.
Verder wordt op maandag, zonder vast tijdstip, een meeting gehouden met de professional skills docent, Nils Bijleveld. In deze meeting wordt de communicatie binnen 
en buiten de groep besproken en wordt gewerkt aan de verbetering van de groepsdynamiek.

### 8.4 Overlegafspraken
Tijdens het project zullen er verschillende overlegmomenten zijn. Er worden bijvoorbeeld Daily Standups houden tijdens de constructie-fase. 
Deze Daily Standups vinden in de ochtend plaats wanneer het ontwikkelteam dit nodig acht. Hierin wordt besproken wat de dag ervoor bereikt is, wat op de dag zelf 
bereikt zal worden en of er problemen zijn die de loop van het project kunnen beïnvloeden. 
Om te zorgen dat alles duidelijk is, zal het Jira bord bij de Daily Standups gehouden worden en deze wordt eventueel geüpdatet, zodat alles actueel is. 
Verder zijn meetings ingepland met de opdrachtgever en de procesbegeleider. Voor deze meetings zal vooraf een agenda opgesteld worden en zullen vragen voorbereid  
worden om zeker te zijn dat de tijd zo efficiënt mogelijk benut wordt. 
Tot slot zijn meetings met de professional skills docent ingepland. Deze meetings zullen gebruikt worden om te kijken hoe de interne communicatie verbeterd kan worden.
Ook kunnen dan eventuele vragen gesteld worden over de individuele projectverslagen. Deze meetings zullen standaard op de maandagochtend plaatsvinden.

## 9. Planning
Er wordt gedurende tien schoolweken aan het project gewerkt. Om een goed overzicht te hebben welke onderdelen wanneer te
verwachten zijn, wordt hieronder een algemene planning gegeven.

| Fase          | Van        | Tot        | Oplevering                                                                                                                 |
|---------------|------------|------------|----------------------------------------------------------------------------------------------------------------------------|
| Inceptie      | 11/04/2023 | 14/04/2023 | 14/04/2023 Plan van aanpak                                                                                                 |
| Elaboratie    | 17/04/2023 | 26/04/2023 | 26/04/2023 Prototypes en/of proof of concepts samen met het functioneel ontwerp en eerste versie van het technisch ontwerp |
| Constructie 1 | 08/05/2023 | 17/05/2023 | 17/05/2023 Uitwerking van de doelen die in het begin van de iteratie zijn afgesproken                                      |
| Constructie 2 | 22/05/2023 | 31/05/2023 | 31/05/2023 Uitwerking van de doelen die in het begin van de iteratie zijn afgesproken                                      |
| Constructie 3 | 1/06/2023  | 09/06/2023 | 09/06/2023 Uitwerking van de doelen die in het begin van de iteratie zijn afgesproken                                      |

### Vrije dagen

| Vrije dag(en)        | Datum(s)                |
|----------------------|-------------------------|
| Koningsdag           | 27/04/2023              |
| Verplichte vrije dag | 28/04/2023              |
| Meivakantie          | 01/05/2023 - 07/05/2023 |
| Hemelvaartsdag       | 18/05/2023              |
| Verplichte vrije dag | 19/05/2023              |
| 2e Pinksterdag       | 29/05/2023              |

## 10. Risico's
In dit hoofdstuk worden de risico’s beschreven die tijdens het project kunnen ontstaan. 
Daarnaast wordt er een beschrijving gegeven van de kans dat het risico zich voordoet, 
de impact die het risico heeft en de maatregelen die genomen worden om het risico te beperken. 
Als laatste wordt er een uitwijkstrategie beschreven die genomen kan worden als het risico zich toch voordoet.
De risico's zijn opgesplitst tussen projectrisico's, dus onder andere communicatie problemen, en technische risico's.

### 10.1 Projectrisico’s
| Projectrisico's                                              | Kans   | Impact         | Tegenmaatregel                                                                                                                                            | Uitwijkstrategie                                                                                                                                                                                                              |
|--------------------------------------------------------------|--------|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| De duur van taken wordt verkeerd ingeschat.                  | Groot  | Klein / Medium | Taken worden zo realistisch mogelijk ingeschat met het team. Bij twijfel wordt een taak langer ingeschat.                                                 | Bij grote uitloop contact opnemen met de opdrachtgever dat taken niet afkomen. Als alle taken vroegtijdig af zijn, kan er met de opdrachtgever gekeken worden wat de eventuele volgende taken zijn waar we aan kunnen werken. |
| De opdrachtgever wil grote delen van de opdracht veranderen. | Medium | Groot          | Concrete afspraken maken met de opdrachtgever en de afspraken noteren.                                                                                    | Wijzen op gemaakte afspraken wanneer de veranderingen hier buiten vallen.                                                                                                                                                     |
 
### 10.2 Technische risico’s
| Technische risico's                                                                            | Kans  | Impact | Tegenmaatregel                                                                                                                             | Uitwijkstrategie                                                                                                                                                      |
|------------------------------------------------------------------------------------------------|-------|--------|--------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Het gebruik van Redis voor de Staging Area krijgen we niet op tijd werkend.                    | Klein | Groot  | Een proof of concept aanleveren, zodat de vertaling van SQL Server naar Redis vroegtijdig op orde is.                                      | Met de opdrachtgever overleggen wat een alternatief is. Bijvoorbeeld functionaliteiten opofferen om meer focus te leggen op Redis om het toch nog werkend te krijgen. |
| Het opzetten van een Docker container die MSSQL en Redis opstart niet op tijd werkend krijgen. | Klein | Medium | Vroegtijdig beginnen aan de Docker container en als het niet op tijd af lijkt te komen extra aandacht aan besteden.                        | Omdat dit niet een verplicht onderdeel is, laten vallen en eventueel later in het project weer oppakken.                                                              |
| Het gebruik van Faker biedt niet de testdata die wij zoeken.                                   | Klein | Groot  | Vroegtijdig verschillende datastructuren proberen te genereren met Faker, zodat vroegtijdig bekend is of Faker nuttig is voor ons project. | Zelf een script maken in bijvoorbeeld Python die data kan genereren op basis van handgeschreven input.                                                                |
