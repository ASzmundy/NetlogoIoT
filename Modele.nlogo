;VARIABLES GLOBALES
globals[
  ;;STATIQUES
  ;;;Coordonnées
  Latitude
  Longitude
  ;;;Températures/Saison
  MinTempHiver
  MaxTempHiver
  MinTempPrintemps
  MaxTempPrintemps
  MinTempEte
  MaxTempEte
  MinTempAutomne
  MaxTempAutomne
  ;;;Utilisateur
  TypeHandicap

  ;;DYNAMIQUES
  ;;Date et heure
  Jour
  Mois
  Annee
  Heure
  Minute
  Seconde
  ;;Extérieur
  LuminositeExterieure
  TempératureExterieure
  HeureLeverSoleil
  HeureCoucherSoleil
  ;;Intérieur
  LuminositePiecePrincipales
  LuminositeEntree
  LuminositeSdB
  MouvementPiecePrincipales
  MouvementEntree
  MouvementSdB
  FumeePiecePrincipales
  FumeeEntree
  FumeeSdB
  COPiecePrincipales
  COEntree
  COSdB
]


;TURTLES
;;Meubles non connectes
breed [tables table]

breed [chaises chaise]

breed [commodes commode]
commodes-own [quantitelinge]

breed [placards placard]
placards-own [quantitevaisselle]

;;Meubles connectes
;;;SdB
breed [douches douche]
douches-own [Temperatureeau debit isactif]

breed [toilettes toilette]
toilettes-own [capacitereservoir debitremplissage isactif]

breed [eviers evier]
eviers-own [Temperatureeau debit isactif]

;;;Chambre
breed [lits lit]
lits-own [qualitesommeil isactif]


;;;Cuisine
breed [cafetieres cafetiere]
cafetieres-own [capacitecafe capaciteeau Temperaturecafe isactif]

breed [plaques plaque]
plaques-own [Temperature puissance minuteur isactif]

breed [hottes hotte]
hottes-own [puissance isactif]

breed [lavelinges lavelinge]
lavelinges-own [degresalissure poidslinge isactif]

breed [sechelinges sechelinge]
sechelinges-own [temperature humidite poidslinge isactif]

breed [fours four]
fours-own [modecuisson puissance temperature minuteur isactif]

breed [lavevaisselles lavevaisselle]
lavevaisselles-own [modecycle dureerestante nbpastilles temperatureeau tauxsalete isactif]

breed [frigos frigo]
frigos-own [Temperature isporteouverte nombrefruits nombrelegumes nombreviandes nombrerepas isactif]

breed [panierlinges panierlinge]
panierlinges-own [quantitelinge]

breed [microondes microonde]
microondes-own [puissance minuteur isactif]

breed [bibliotheques bibliotheque]
bibliotheques-own [quantitelivres]


;;;SaM
breed [stationroombas stationroomba]
stationroombas-own [isroombaonstation isactif]

breed [roombas roomba]
roombas-own [capacitesac tauxdesalete batterie isactif]


;;Meubles communs
breed [chauffages chauffage]
chauffages-own [puissance temperatureambiante isactif]

breed [climatisateurs climatisateur]
climatisateurs-own [puissance temperatureambiante isactif]

breed [lampes lampe]
lampes-own [luminosite couleurlampe isactif]


;;Fenetres
breed [fenetres fenetre]
fenetres-own [isouvert]

breed [volets volet]
volets-own [isouvert]


;;Objets
breed [extincteurs extincteur]
extincteurs-own [quantitepoudre]

breed [vaisselles vaisselle]
vaisselles-own [proprete]

breed [pastillelavevaisselles pastillelavevaisselle]

breed [fruits fruit]
fruits-own [nutrition fraicheur]

breed [legumes legume]
legumes-own [nutrition fraicheur]

breed [viandes viande]
viandes-own [nutrition fraicheur]

breed [repass repas]
repass-own [nutrition Mouvement Mouvementcuisson etatcuisson quantite isconsommablefroid fraicheur]

breed [linges linge]
linges-own [poids proprete humidite]

breed [cafes cafe]
cafes-own [Mouvement quantite]

breed [livres livre]


;;Alarmes
breed [alarmes alarme]
alarmes-own [isactif]

;;Capteurs
;;;Génériques
breed [CapteurTemperatures CapteurTemperature]
breed [CapteurPortes CapteurPorte]
breed [CapteurMouvements CapteurMouvement]
breed [CapteurAllumages CapteurAllumage]
breed [CapteurFumees CapteurFumee]
breed [CapteurCOs CapteurCO]
;;;Spécifiques
breed [CapteurDouches CapteurDouche]
breed [CapteurToilettes CapteurToilette]
breed [CapteurLits CapteurLit]
breed [CapteurCafetieres CapteurCafetiere]
breed [CapteurStationRoombas CapteurStationRoomba]
breed [CapteurRoombas CapteurRoomba]
breed [CapteurLampes CapteurLampe]
breed [CapteurFourMOs CapteurFourMO]
breed [CapteurFours CapteurFour]
breed [CapteurLaveVaisselles CapteurLaveVaisselle]
breed [CapteurFrigos CapteurFrigo]
breed [CapteurPlaques CapteurPlaque]
breed [CapteurLaveLinges CapteurLaveLinge]
breed [CapteurChauffages CapteurChauffage]
breed [CapteurClims CapteurClim]






;LINKS
;;Links capteurs
directed-link-breed [CapteurLinks CapteurLink]
capteurlinks-own [
  nomdonneeaextraire
]

;;Links objets
;;TODO
;;Links utilisateurs
;;TODO


;SETUP
to setup
  clear-all
  import-pcolors "appart_petit.png"

  ;;Création des meubles (manuel)
  ;;;Tables
  ;;;;Tables salon
  ask patches with [ pxcor > 5 and pxcor < 10 and pycor = 1] [
   sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]
   ;;;;Table SàM
   ask patches with [ pxcor = 14 and pycor = 2] [
   sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]

  ;;;;Table Cuisine
  ask patches with [ pxcor = 16 and pycor = 7] [
   sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]

  ;;;Chaises
  ask patches with [ (pxcor = 13 or pxcor = 15) and (pycor = 1 or pycor = 3)] [
   sprout-chaises 1
    [
      set shape "box"
      set color brown
    ]
  ]

  ;;;Lit
  ask patches with [ pxcor = 8 and pycor = 8] [
   sprout-lits 1
    [
      set shape "bed"
      set heading 0
      set color brown
      set qualitesommeil 0
      set isactif 0
    ]
  ]

  ;;;commode
  ask patches with [ pxcor = 6 and pycor = 6] [
   sprout-commodes 1
    [
      set shape "commode"
      set heading 90
      set color brown
      set quantitelinge 10
    ]
  ]

  ;;;placard
  ask patches with [ pxcor = 16 and pycor = 9] [
   sprout-placards 1
    [
      set shape "square 2"
      set color brown
      set quantitevaisselle 10
    ]
  ]

  ;;Meubles CONNECTES
  ;;;SDB
  ;;;;douche
  ask patches with [pxcor = 1 and pycor = 6] [
   sprout-douches 1
    [
      set shape "drop"
      set color cyan
      set temperatureeau 0 ;;TODO mettre à température intérieur
      set debit 0
      set isactif 0
    ]
  ]

  ;;;;toilettes
  ask patches with [pxcor = 1 and pycor = 9] [
   sprout-toilettes 1
    [
      set shape "box"
      set color cyan
      set capacitereservoir 100
      set debitremplissage 0
      set isactif 0
    ]
  ]

  ;;;;évier
  ask patches with [(pxcor = 4 and pycor = 9) or (pxcor = 16 and pycor = 6)] [
   sprout-eviers 1
    [
      set shape "chess rook"
      set color white
      set temperatureeau 0 ;;TODO mettre à température intérieur
      set debit 0
      set isactif 0
    ]
  ]

  ;;;Cuisine
  ;;;;Cafetiere
  ask patches with [pxcor = 12 and pycor = 9] [
   sprout-cafetieres 1
    [
      set shape "tooth"
      set color black
      set capacitecafe 0
      set capaciteeau 100
      set temperaturecafe 0 ;;TODO mettre à température intérieur
      set isactif 0
    ]
  ]
  ;;;;plaque
  ask patches with [pxcor = 12 and pycor = 8] [
   sprout-plaques 1
    [
      set shape "molecule oxygen"
      set heading 0
      set color black
      set temperature 0 ;;TODO mettre à température intérieur
      set puissance 0
      set minuteur 0
      set isactif 0
    ]
  ]
  ;;;;hotte
  ask patches with [pxcor = 12 and pycor = 8] [
   sprout-hottes 1
    [
      set shape "lander"
      set heading 0
      set color grey
      set puissance 0
      set isactif 0
    ]
  ]
  ;;;;lave-linge
  ask patches with [pxcor = 2 and pycor = 6] [
   sprout-lavelinges 1
    [
      set shape "lavelinge"
      set heading 0
      set color black
      set degresalissure 0
      set poidslinge 0
      set isactif 0
    ]
  ]
  ;;;;sèche-linge
  ask patches with [pxcor = 4 and pycor = 6] [
   sprout-sechelinges 1
    [
      set shape "square"
      set heading 0
      set color white
      set temperature 0 ;;TODO mettre à température intérieur
      set humidite 0
      set poidslinge 0
      set isactif 0
    ]
  ]
  ;;;;four
  ask patches with [pxcor = 12 and pycor = 6] [
   sprout-fours 1
    [
      set shape "square"
      set heading 0
      set color grey
      set modecuisson "Voute" ;;Peut être "Voute","Sole","Tournant"
      set puissance 0
      set temperature 0 ;;TODO mettre à température intérieur
      set minuteur 0
      set isactif 0
    ]
  ]


  ;;;;lave-vaisselle
  ask patches with [pxcor = 16 and pycor = 8] [
   sprout-lavevaisselles 1
    [
      set shape "square"
      set heading 0
      set color cyan
      set modecycle "Rincage" ;Peut être "Lavage","Rincage" et "Séchage"
      set dureerestante 0
      set nbpastilles 5
      set temperatureeau 0 ;;TODO mettre à température intérieur
      set tauxsalete 0
      set isactif 0
    ]
  ]

  ;;;;frigo
  ask patches with [pxcor = 12 and pycor = 7] [
   sprout-frigos 1
    [
      set shape "square 2"
      set heading 0
      set color white
      set temperature 2
      set isporteouverte 0
      set nombrefruits 10
      set nombrelegumes 10
      set nombreviandes 10
      set nombrerepas 0
      set isactif 1
    ]
  ]
  ;;;;panier à linge
  ask patches with [pxcor = 16 and pycor = 5] [
   sprout-panierlinges 1
    [
      set shape "garbage can"
      set heading 0
      set color brown
      set quantitelinge 0
    ]
  ]
  ;;;;four à micro ondes
  ask patches with [pxcor = 12 and pycor = 5] [
   sprout-microondes 1
    [
      set shape "square"
      set heading 0
      set color grey + 3
      set puissance 0
      set minuteur 0
      set isactif 0
    ]
  ]
  ;;;;bibliothèque
  ask patches with [pxcor = 14 and pycor = 9] [
   sprout-bibliotheques 1
    [
      set shape "container"
      set color brown
      set quantitelivres 10
    ]
  ]

  ;;;SaM
  ;;;;Station roomba
  ask patches with [pxcor = 11 and pycor = 1] [
   sprout-stationroombas 1
    [
      set shape "circle 2"
      set color grey
      set isroombaonstation 1
      set isactif 0
    ]
  ]
  ;;;;Roomba
  ask patches with [pxcor = 11 and pycor = 1] [
   sprout-roombas 1
    [
      set shape "circle"
      set color grey
      set size 0.7
      set capacitesac 0
      set tauxdesalete 0
      set batterie 100
      set isactif 0
    ]
  ]

  ;;Création des meubles communs
  ;;;Lampes
  ask patches with
  [
    (pxcor = 2 and pycor = 2)
    or (pxcor = 2 and pycor = 7)
    or (pxcor = 8 and pycor = 6)
    or (pxcor = 8 and pycor = 2)
    or (pxcor = 13 and pycor = 2)
    or (pxcor = 14 and pycor = 6)
  ][
   sprout-lampes 1[
      set shape "triangle 2"
      set color yellow
      set size 0.6
      set luminosite 250
      set couleurlampe 2700 ;en K ;TODO Couleurs lampes différentes selon pièces
      set isactif 0
    ]
  ]
  ;;;Chauffages
  ask patches with
  [
    (pxcor = 1 and pycor = 2)
    or (pxcor = 12 and pycor = 1)
    or (pxcor = 4 and pycor = 7)
  ][
   sprout-chauffages 1[
      set shape "container"
      set color white
      set puissance 0
      set temperatureambiante 0 ;;TODO mettre à température intérieur
      set isactif 0
    ]
  ]
  ;;;Climatisateurs
  ask patches with
  [
    pxcor = 16 and pycor = 2
  ][
   sprout-climatisateurs 1[
      set shape "computer server"
      set color white
      set puissance 0
      set temperatureambiante 0 ;;TODO mettre à température intérieur
      set isactif 0
    ]
  ]

  ;;Création des alarmes
  ask patches with
  [
    pxcor = 12 and pycor = 4
  ][
   sprout-alarmes 1[
      set shape "coin tails"
      set color white
      set size 0.7
      set isactif 0
    ]
  ]

  ;;Création des fenêtres et volets
  ask patches with [pcolor = 105] [
   sprout-fenetres 1
    [
      set shape "square 2"
      set color cyan
      set isouvert 0
    ]
    sprout-volets 1
    [
      set shape "square"
      set color cyan
      set isouvert 1
    ]
  ]

  ;;Création des objets (manuel)
  ;;;extincteur
  ask patches with [ pxcor = 1 and pycor = 4] [
   sprout-extincteurs 1
    [
      set shape "bottle"
      set heading 0
      set color red
      set quantitepoudre 100
    ]
  ]

  ;;Création des capteurs génériques
  ;;;CapteurTemperature
  ;;;TODO
  ;;;CapteurPorte
  ;;;TODO
  ;;;CapteurMovement
  ;;;TODO
  ;;;CapteurAllumage
  ask turtles with [ breed = douches
    or breed = toilettes
    or breed = eviers
    or breed = lits
    or breed = cafetieres
    or breed = stationroombas
    or breed = roombas
    or breed = lampes
    or breed = microondes
    or breed = fours
    or breed = lavevaisselles
    or breed = frigos
    or breed = plaques
    or breed = hottes
    or breed = lavelinges
    or breed = sechelinges
    or breed = chauffages
    or breed = alarmes
    or breed = volets
  ]
  [
    ;;Creation capteur
    ask patch-here[
      sprout-capteurallumages 1[
        set shape "cylinder"
        set color blue
        set size 0.1
        ;;Lien Capteur
        create-capteurlink-to one-of other turtles-here with [ (breed = douches
          or breed = toilettes
          or breed = eviers
          or breed = lits
          or breed = cafetieres
          or breed = stationroombas
          or breed = roombas
          or breed = lampes
          or breed = microondes
          or breed = fours
          or breed = lavevaisselles
          or breed = frigos
          or breed = plaques
          or breed = hottes
          or breed = lavelinges
          or breed = sechelinges
          or breed = chauffages
          or breed = alarmes
          or breed = volets)
          and count my-in-links = 0
        ]
        [
          set nomdonneeaextraire "isactif"
        ]
      ]
    ]


  ]


end
@#$#@#$#@
GRAPHICS-WINDOW
430
15
1450
642
-1
-1
56.22222222222222
1
10
1
1
1
0
1
1
1
0
17
0
10
0
0
1
ticks
30.0

BUTTON
63
34
126
67
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bed
true
0
Rectangle -7500403 true true 45 75 75 210
Rectangle -7500403 true true 75 150 210 150
Rectangle -7500403 true true 75 150 240 180
Rectangle -7500403 true true 240 150 270 210
Rectangle -7500403 true true 60 180 75 195
Rectangle -1 true false 75 105 105 150
Rectangle -2674135 true false 105 105 270 150

bottle
false
0
Circle -7500403 true true 90 240 60
Rectangle -1 true false 135 8 165 31
Line -7500403 true 123 30 175 30
Circle -7500403 true true 150 240 60
Rectangle -7500403 true true 90 105 210 270
Rectangle -7500403 true true 120 270 180 300
Circle -7500403 true true 90 45 120
Rectangle -7500403 true true 135 27 165 51

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cannon
true
0
Polygon -7500403 true true 165 0 165 15 180 150 195 165 195 180 180 195 165 225 135 225 120 195 105 180 105 165 120 150 135 15 135 0
Line -16777216 false 120 150 180 150
Line -16777216 false 120 195 180 195
Line -16777216 false 165 15 135 15
Polygon -16777216 false false 165 0 135 0 135 15 120 150 105 165 105 180 120 195 135 225 165 225 180 195 195 180 195 165 180 150 165 15

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

chess rook
false
0
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 90 255 105 105 195 105 210 255
Polygon -16777216 false false 90 255 105 105 195 105 210 255
Rectangle -7500403 true true 75 90 120 60
Rectangle -7500403 true true 75 84 225 105
Rectangle -7500403 true true 135 90 165 60
Rectangle -7500403 true true 180 90 225 60
Polygon -16777216 false false 90 105 75 105 75 60 120 60 120 84 135 84 135 60 165 60 165 84 179 84 180 60 225 60 225 105

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

coin tails
false
0
Circle -7500403 true true 15 15 270
Circle -16777216 false false 20 17 260
Line -16777216 false 130 92 171 92
Line -16777216 false 123 79 177 79
Rectangle -7500403 true true 57 101 242 133
Rectangle -16777216 false false 45 180 255 195
Rectangle -16777216 false false 75 120 225 135
Polygon -16777216 false false 81 226 70 241 86 248 93 235 89 232 108 243 97 256 118 247 118 265 123 248 142 247 129 253 130 271 145 269 131 259 162 245 153 262 168 268 197 259 177 255 187 245 174 243 193 235 209 251 193 234 225 244 208 227 240 240 222 218
Rectangle -7500403 true true 91 210 222 226
Polygon -16777216 false false 65 70 91 50 136 35 181 35 226 65 246 86 241 65 196 50 166 35 121 50 91 50 61 95 54 80 61 65
Polygon -16777216 false false 90 135 60 135 60 180 90 180 90 135 120 135 120 180 150 180 150 135 180 135 180 180 210 180 210 135 240 135 240 180 210 180 210 135

commode
true
0
Rectangle -6459832 true false 15 90 285 225
Line -16777216 false 15 135 285 135
Line -16777216 false 15 165 285 165
Circle -16777216 true false 135 135 30
Line -16777216 false 15 195 285 195
Circle -16777216 true false 135 165 30
Line -16777216 false 15 105 285 105
Circle -16777216 true false 135 105 30

computer server
false
0
Rectangle -7500403 true true 75 30 225 270
Line -16777216 false 210 30 210 195
Line -16777216 false 90 30 90 195
Line -16777216 false 90 195 210 195
Rectangle -10899396 true false 184 34 200 40
Rectangle -10899396 true false 184 47 200 53
Rectangle -10899396 true false 184 63 200 69
Line -16777216 false 90 210 90 255
Line -16777216 false 105 210 105 255
Line -16777216 false 120 210 120 255
Line -16777216 false 135 210 135 255
Line -16777216 false 165 210 165 255
Line -16777216 false 180 210 180 255
Line -16777216 false 195 210 195 255
Line -16777216 false 210 210 210 255
Rectangle -7500403 true true 84 232 219 236
Rectangle -16777216 false false 101 172 112 184

container
false
0
Rectangle -7500403 false false 0 75 300 225
Rectangle -7500403 true true 0 75 300 225
Line -16777216 false 0 210 300 210
Line -16777216 false 0 90 300 90
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

drop
false
0
Circle -7500403 true true 73 133 152
Polygon -7500403 true true 219 181 205 152 185 120 174 95 163 64 156 37 149 7 147 166
Polygon -7500403 true true 79 182 95 152 115 120 126 95 137 64 144 37 150 6 154 165

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

garbage can
false
0
Polygon -16777216 false false 60 240 66 257 90 285 134 299 164 299 209 284 234 259 240 240
Rectangle -7500403 true true 60 75 240 240
Polygon -7500403 true true 60 238 66 256 90 283 135 298 165 298 210 283 235 256 240 238
Polygon -7500403 true true 60 75 66 57 90 30 135 15 165 15 210 30 235 57 240 75
Polygon -7500403 true true 60 75 66 93 90 120 135 135 165 135 210 120 235 93 240 75
Polygon -16777216 false false 59 75 66 57 89 30 134 15 164 15 209 30 234 56 239 75 235 91 209 120 164 135 134 135 89 120 64 90
Line -16777216 false 210 120 210 285
Line -16777216 false 90 120 90 285
Line -16777216 false 125 131 125 296
Line -16777216 false 65 93 65 258
Line -16777216 false 175 131 175 296
Line -16777216 false 235 93 235 258
Polygon -16777216 false false 112 52 112 66 127 51 162 64 170 87 185 85 192 71 180 54 155 39 127 36

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

i beam
false
0
Polygon -7500403 true true 165 15 240 15 240 45 195 75 195 240 240 255 240 285 165 285
Polygon -7500403 true true 135 15 60 15 60 45 105 75 105 240 60 255 60 285 135 285

lander
true
0
Polygon -7500403 true true 45 75 150 30 255 75 285 225 240 225 240 195 210 195 210 225 165 225 165 195 135 195 135 225 90 225 90 195 60 195 60 225 15 225 45 75

lavelinge
false
0
Rectangle -1 true false 45 45 255 255
Circle -7500403 true true 88 103 124

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

molecule oxygen
true
0
Circle -7500403 true true 120 75 150
Circle -16777216 false false 120 75 150
Circle -7500403 true true 30 75 150
Circle -16777216 false false 30 75 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tooth
false
0
Polygon -7500403 true true 75 30 60 45 45 75 45 90 60 135 73 156 75 170 60 240 60 270 75 285 90 285 105 255 135 180 150 165 165 165 180 185 195 270 210 285 240 270 245 209 244 179 237 154 237 143 255 90 255 60 225 30 210 30 180 45 135 45 90 30
Polygon -7500403 false true 75 30 60 45 45 75 45 90 60 135 73 158 74 170 60 240 60 270 75 285 90 285 105 255 135 180 150 165 165 165 177 183 195 270 210 285 240 270 245 210 244 179 236 153 236 144 255 90 255 60 225 30 210 30 180 45 135 45 90 30 75 30

train freight boxcar
false
0
Rectangle -7500403 true true 10 100 290 195
Rectangle -16777216 false false 9 99 289 195
Circle -16777216 true false 253 195 30
Circle -16777216 true false 220 195 30
Circle -16777216 true false 50 195 30
Circle -16777216 true false 17 195 30
Rectangle -16777216 true false 290 180 299 195
Rectangle -16777216 true false 105 90 135 90
Rectangle -16777216 true false 1 180 10 195
Rectangle -16777216 false false 105 105 195 180
Line -16777216 false 150 105 150 180

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
