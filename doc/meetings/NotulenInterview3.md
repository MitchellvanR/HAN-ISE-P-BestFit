# Notulen vergadering opdrachtgever 26-04-2023

## Documentatie

### PvA

#### Stakeholders:

Het controleren of leden en medewerkers onder stakeholders vallen heeft OG gevraagd of wij dit kunnen verifiëren met Nils (Prof. Skills).
- ja ze zijn stakeholders, maar we mogen zelf een onderbouwing erbij te zetten waarom we dit vinden. (het is een beetje grijs gebied)

#### Projectgrenzen:

*Verwerkt* Bij Inhoudelijke verwachtingen wil OG dat toegevoegd wordt dat een Docker container met Redis cache opgeleverd wordt.

*Verwerkt* Bij Inhoudelijke grenzen moet 'Code testen voorbij het testplan' duidelijker geformuleerd worden. OG vindt het nu nikszeggend. 

#### Randvoorwaarden:
*Verwerkt* Het feit dat OG binnen 1 werkdag reageert is incorrect, hij wil hier graag 2 werkdagen van hebben.

*Verwerkt* Er staat dat OG toegang tot Atlassian accounts regelt. Dit moet gaan om de procesbegeleider (Frank).

#### Accordering

*Verwerkt* Opdrachtgever heeft akkoord gegeven.

### Functioneel Ontwerp

**Verwerkt**Bij OG was het nog niet duidelijk dat alleen squashruimtes gereserveerd konden worden. Hierdoor kwam verwarring of geen 
enkele ruimte gereserveerd kon worden. 

**Verwerkt**Wanneer een nieuw type ruimte komt, moet rekening gehouden worden dat deze reserveerbaar kunnen zijn.

**Verwerkt** US-21 - OG geeft aan dat hij deze user story ook vanuit het perspectief van een lid wil zien. Bijvoorbeeld een extra user 
story 'Als lid wil ik dat elke ruimte een medewerker heeft zodat ik niet sport zonder begeleiding'.

**Verwerkt**OG vraagt om een aparte rol om roosters in te vullen, zodat medewerkers elkaars roosters niet kunnen aanpassen. Pas dit aan in CDM

**Hoeft niks mee gedaan te worden** FR-01 - Meerdere abonnementen is enigszins raar. Voorlopig nog wel goed.

**Verwerkt** Overlap tussen user stories en functional requirements. Veel is dubbelop.

**Verwerkt** Verwoordingen moeten genummerd worden nummeren.

**Verwerkt** Voorbeeldwaarden in verwoordingen mogen realistischer. Verder zijn de verwoordingen UITSTEKEND :D

**Verwerkt** De volgorde van de verwoordingen moet aangepast worden omdat het nu erg onlogisch is met het lezen.

**Verwerkt** Use case model komt niet overeen met de use case descriptions. CRUD moet beter toegelicht worden onder de use cases zodat er evenveel use cases zijn als in het model.

**Verwerkt**CDM - Employee moet nog verdeeld worden over rollen. Verder heel sterk.

**Verwerkt** Business rules: Einddatum voor abonnementen om reminders te sturen en om te voorkomen dat je je inschrijft voor iets als je abonnement al verlopen is.

**Verwerkt** Business rules liever traceerbaar naar use cases / user stories.

*Verwerkt* Business rules formuleren in termen van het CDM (daar hebben we in principe wel constraints voor). Mag een vertaaltabel van business rules naar constraints.

### Technisch Ontwerp

**Verwerkt** Niet functionele eisen zijn (blijkbaar) functioneel, omdat 'ons systeem het doet'.
Er staat maar 1 versie, maar wat gebeurt er als je updatet? (Verwoord het met long term support).
Images hebben ook een versie (SQL server mag wel meest recente versie, tenzij geldige reden).

## Staging area

Alleen nog geen constraints, maar voor het prototype is dit voldoende.

## Constructie fase

Opdrachtgever geen voorkeuren voor wat als eerste geïmplementeerd moet worden. Bespreek met Frank.
Maandag 8 mei mailtje sturen naar OG waar we mee aan de slag gaan.


Opdrachtgever tevreden :D


vr 12/5 ochtend komt nils weer langs











