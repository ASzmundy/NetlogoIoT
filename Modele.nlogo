; EXTENSIONS
extensions [time csv]

; VARIABLES PATCHS POUR PATHFINDING
patches-own
[
  parent-patch ; patch's predecessor
  f ; the value of knowledge plus heuristic cost function f()
  g ; the value of knowledge cost function g()
  h ; the value of heuristic cost function h()
]


; VARIABLES GLOBALES
globals[
  ;;; Date et heure
  currentDateTime
  weekday ;;;; Jour de la semaine (1 = Lundi, 7 = Dimanche)
  day
  month
  year
  hour
  minute
  second
  season

  ;;; Routine
  routineTimes
  routineActions
  nextRoutineIndex

  ;;; Gestion particules
  smokePrincipalRooms
  smokeEntrance
  smokeBathroom
  COPrincipalRooms
  COEntrance
  COBathroom

  ;;; Gestion température
  temperaturePrincipalRooms
  temperatureEntrance
  temperatureBathroom
  temperatureOutside
  targetTemperatureOutsideMin ;;;; Température minimum de la journée
  targetTemperatureOutsideMax ;;;; Température maximum de la journée
  dateTimeTemperatureMin ;;;; Temps du pic bas de température
  dateTimeTemperatureMax ;;;; Temps du pic haut de température
  secondsBetweenExtremums

  ;;; Gestion luminosité
  luminosityPrincipalRooms
  luminosityEntrance
  luminosityBathroom
  luminosityOutside
  sunriseHour
  sunsetHour
  datetimeSunrise
  datetimeSunset
  isNight ;;;; True si Nuit/Aube False si Jour/Crépuscule

  ;;; Gestion saleté
  dirtEntrance
  dirtBedroom
  dirtDiningRoom
  dirtKitchen
  dirtBathroom
]



; DECLARATION TURTLES

;; Meubles non connectés
breed [doors door]

breed [tables table]

breed [chairs chair]

breed [drawers drawer]
drawers-own [laundryQuantity]

breed [cupboards cupboard]
cupboards-own [dishesQuantity]

;; Meubles connectes
;;; SdB
breed [showers shower]
showers-own [waterTemperature showerThermostat debit isActive]
; TODO Besoin toilette
breed [toilets toilet]
toilets-own [tankCapacity fillingDebit isActive]

breed [sinks sink]
sinks-own [waterTemperature debit isActive]

;;; Chambre
breed [beds bed]
beds-own [sleepQuality isActive]


;;; Cuisine
breed [coffeeMakers coffeeMaker]
coffeeMakers-own [coffeeCapacity waterCapacity coffeeTemperature isActive]

breed [hotplates hotplate]
hotplates-own [temperature power timeLeft isActive]

breed [hoods hood]
hoods-own [power isActive]

breed [washingMachines washingMachine]
washingMachines-own [dirtDegree laundryWeight isActive]

breed [dryers dryer]
dryers-own [temperature humidity laundryWeight isActive]

breed [ovens oven]
ovens-own [cookingMethod power temperature timeLeft isActive]

breed [dishwashers dishwasher]
dishwashers-own [cycleMode timeLeft pastillesQuantity waterTemperature waterLevel dirtLevel isActive]

breed [fridges fridge]
fridges-own [temperature isDoorOpen fruitsQuantity vegetablesQuantity meatQuantity mealQuantity isActive]

breed [laundryBaskets laundryBasket]
laundryBaskets-own [laundryQuantity]

breed [microwaves microwave]
microwaves-own [power timeLeft isActive]

breed [bookshelfs bookshelf]
bookshelfs-own [bookQuantity]


;;; Salle à manger
breed [roombaStations roombaStation]
roombaStations-own [isRoombaOnStation isActive]

breed [roombas roomba]
roombas-own [bagCapacity dirtLevel battery isActive current-path path isEnRoute targetPatch]


;; Meubles communs
breed [heaters heater]
heaters-own [power ambiantTemperature isActive]

breed [ACs AC]
ACs-own [power ambiantTemperature isActive]

breed [lights light]
lights-own [luminosity lampColor isActive]


;; Fenetres
breed [windows window]
windows-own [isOpen]

breed [shutters shutter]
shutters-own [isOpen]


;; Objets
breed [extinguishers extinguisher]
extinguishers-own [powderQuantity]

breed [dishes dish]
dishes-own [cleanliness]

breed [dishwasherPastilles dishwasherPastille]

breed [fruits fruit]
fruits-own [nutrition freshness quantity]

breed [vegetables vegetable]
vegetables-own [nutrition freshness]

breed [meats meat]
meats-own [nutrition freshness]

breed [meals meal]
meals-own [nutrition temperature cookingTemperature cookingState quantity isEatableCold freshness]

breed [laundrys laundry]
laundrys-own [weight cleanliness humidity]

breed [coffees coffee]
coffees-own [temperature quantity]

breed [books book]


;; Alarmes
breed [alarms alarm]
alarms-own [isActive]

;; Capteurs
;;; Génériques
breed [temperatureSensors temperatureSensor]
breed [luminositySensors luminositySensor]
breed [doorSensors doorSensor]
breed [moveSensors moveSensor]
breed [triggerSensors triggerSensor]
breed [smokeSensors smokeSensor]
breed [COSensors COSensor]
;;; Spécifiques
breed [showerSensors showerSensor]
breed [toiletSensors toiletSensor]
breed [bedSensors bedSensor]
breed [coffeeMakerSensors coffeeMakerSensor]
breed [roombaStationSensors roombaStationSensor]
breed [roombaSensors roombaSensor]
breed [lightSensors lightSensor]
breed [microwaveSensors microwaveSensor]
breed [ovenSensors ovenSensor]
breed [dishwasherSensors dishwasherSensor]
breed [fridgeSensors fridgeSensor]
breed [hotplateSensors hotplateSensor]
breed [washingMachineSensors washingMachineSensor]
breed [heaterSensors heaterSensor]
breed [ACSensors ACSensor]

;; Utilisateur
breed [users user]
users-own[
  ;;; Pour pathfinding
  current-path
  path
  isEnRoute
  currentTask
  targetPatch

  ;;; Tâches
  tasks

  ;;; Besoins
  hunger
  sleep
  comfort
  health
  cleanliness
  isSleeping

  ;;; Anniversaire
  age
  birthDay
  birthMonth

  ;;; Température interne
  temperature

  ;;; Alerte
  isAlert

  ;;; Mouvement
  isRunning
  moveSpeed
  runSpeed
  isOutside

  ;;; Poids
  weight
]


; DECLARATION LINKS
;TODO FAIRE CAPTEUR GENERIQUE QUI EXPORTE UN ENSEMBLE DE DONNES DANS UNE LISTE
;; Links capteurs
directed-link-breed [sensorLinks sensorLink]
sensorLinks-own [
  extractedDataName
]

;; Links objets
;;; Link contenance
directed-link-breed [containLinks containLink]

;; Links utilisateurs
;;; Porte
directed-link-breed [carryLinks carryLink]
;;; Utilise
directed-link-breed [useLinks useLink]
;;; Tache
directed-link-breed [taskLinks taskLink]
taskLinks-own[
  action ;;;; String qui contient l'action (ex:"Utiliser")
  priority
  time ;;;; Pour garder en mémoire le temps de la tache
]

; FONCTIONS POUR SETUP
;; Lecture fichier éphéméride
to readEphemeride [monthToRead dayToRead]
  file-open "config/ephemeride.csv"
  let isLineFound false
  while [not isLineFound or not file-at-end?][
    let line (csv:from-row file-read-line ";")
    if first line = dayToRead [
      set isLineFound true
      	
      ;;; Lecture données Janvier
      if monthToRead = 1 [
        set sunriseHour (item 1 line)
        set sunsetHour (item 2 line)
      ]
      	
      ;;; Lecture données Février
      if monthToRead = 2 [
        set sunriseHour (item 3 line)
        set sunsetHour (item 4 line)
      ]
      	
      ;;; Lecture données Mars
      if monthToRead = 3 [
        set sunriseHour (item 5 line)
        set sunsetHour (item 6 line)
      ]
      	
      ;;; Lecture données Avril
      if monthToRead = 4 [
        set sunriseHour (item 7 line)
        set sunsetHour (item 8 line)
      ]
      	
      ;;; Lecture données Mai
      if monthToRead = 5 [
        set sunriseHour (item 9 line)
        set sunsetHour (item 10 line)
      ]
      	
      ;;; Lecture données Juin
      if monthToRead = 6 [
        set sunriseHour (item 11 line)
        set sunsetHour (item 12 line)
      ]
      	
      ;;; Lecture données Juillet
      if monthToRead = 7 [
        set sunriseHour (item 13 line)
        set sunsetHour (item 14 line)
      ]
      	
      ;;; Lecture données Aout
      if monthToRead = 8 [
        set sunriseHour (item 15 line)
        set sunsetHour (item 16 line)
      ]
      	
      ;;; Lecture données Septembre
      if monthToRead = 9 [
        set sunriseHour (item 17 line)
        set sunsetHour (item 18 line)
      ]
      	
      ;;; Lecture données Octobre
      if monthToRead = 10 [
        set sunriseHour (item 19 line)
        set sunsetHour (item 20 line)
      ]
      	
      ;;; Lecture données Novembre
      if monthToRead = 11 [
        set sunriseHour (item 21 line)
        set sunsetHour (item 22 line)
      ]
      	
      ;;; Lecture données Décembre
      if monthToRead = 12 [
        set sunriseHour (item 23 line)
        set sunsetHour (item 24 line)
      ]
    ]
  ]
  file-close

  ;;; Formatage données temporelles de l'éphéméride vers objet time
  ;;;; Formatage heures en HH:mm
  if length (word sunriseHour) < 4 [
    set sunriseHour (word "0" sunriseHour)
  ]
  if length (word sunsetHour) < 4 [
    set sunsetHour (word "0" sunriseHour)
  ]
  set sunriseHour (word (substring (word sunriseHour) 0 2) ":" (substring (word sunriseHour) 2 4))
  set sunsetHour (word (substring (word sunsetHour) 0 2) ":" (substring (word sunsetHour) 2 4))

  set datetimeSunrise time:create (word year "-" month "-" day " " sunriseHour)
  set datetimeSunset time:create (word year "-" month "-" day " " sunsetHour)
end

;; Lecture fichier routine
to readRoutine [inputWeekDay]
  file-open "config/routine.csv"
  set routineTimes []
  set routineActions []
  while [not file-at-end?][
    let line (csv:from-row file-read-line ",")

    ;;; Si pas ligne d'entête, alimenter listes de routine en fonction du jour
    if (item 0 line != "monday") and (item 0 line != "time")[
      ;;;; Lundi
      if inputWeekDay = 1 and length line >= 2[
        set routineTimes insert-item 0 routineTimes (item 0 line)
        set routineActions insert-item 0 routineActions (item 1 line)
      ]
      ;;;; Mardi
      if inputWeekDay = 2 and length line >= 4[
        set routineTimes insert-item 0 routineTimes (item 2 line)
        set routineActions insert-item 0 routineActions (item 3 line)
      ]
      ;;;; Mercredi
      if inputWeekDay = 3 and length line >= 6[
        set routineTimes insert-item 0 routineTimes (item 4 line)
        set routineActions insert-item 0 routineActions (item 5 line)
      ]
      ;;;; Jeudi
      if inputWeekDay = 4 and length line >= 8[
        set routineTimes insert-item 0 routineTimes (item 6 line)
        set routineActions insert-item 0 routineActions (item 7 line)
      ]
      ;;;; Vendredi
      if inputWeekDay = 5 and length line >= 10[
        set routineTimes insert-item 0 routineTimes (item 8 line)
        set routineActions insert-item 0 routineActions (item 9 line)
      ]
      ;;;; Samedi
      if inputWeekDay = 6 and length line >= 12[
        set routineTimes insert-item 0 routineTimes (item 10 line)
        set routineActions insert-item 0 routineActions (item 11 line)
      ]
      ;;;; Dimanche
      if inputWeekDay = 7 and length line >= 14[
        set routineTimes insert-item 0 routineTimes (item 12 line)
        set routineActions insert-item 0 routineActions (item 13 line)
      ]
    ]
  ]
  file-close
  ;;; Nettoyage listes routine (retrait de "")
  set routineTimes filter [ x -> x != "" ] routineTimes
  set routineActions filter [ x -> x != "" ] routineActions
  set nextRoutineIndex length routineTimes - 1
end

;; Fonction de calcul date actuelle et saison
to setupDate

  ;;; Récupération date
  let datetimeString date-and-time
  ;;; Conversion mois
  ;;; TODO Modifier en fonction du mois récupéré de datetimeString ( anglais par exemple )
  if substring datetimeString 19 22 = "jan"[
    set month "01"
  ]
  if substring datetimeString 19 22 = "fev"[
    set month "02"
  ]
  if substring datetimeString 19 22 = "mar"[
    set month "03"
  ]
  if substring datetimeString 19 22 = "avr"[
    set month "04"
  ]
  if substring datetimeString 19 22 = "mai"[
    set month "05"
  ]
  if substring datetimeString 19 22 = "jun"[
    set month "06"
  ]
  if substring datetimeString 19 22 = "jui"[
    set month "07"
  ]
  if substring datetimeString 19 22 = "aou"[
    set month "08"
  ]
  if substring datetimeString 19 22 = "sep"[
    set month "09"
  ]
  if substring datetimeString 19 22 = "oct"[
    set month "10"
  ]
  if substring datetimeString 19 22 = "nov"[
    set month "11"
  ]
  if substring datetimeString 19 22 = "dec"[
    set month "12"
  ]

  ;;; Création datetime de l'extension date à partir de datetimeString
  let datetimeString2 (word (substring datetimeString 23 27) "-" month "-" (substring datetimeString 16 18) " " (substring datetimeString 0 2) ":" (substring datetimeString 3 5) ":" (substring datetimeString 6 8))
  let tmpDatetime time:create datetimeString2

  ;;; Affectation variables globales
  set year time:get "year" tmpDatetime
  set month time:get "month" tmpDatetime
  set day time:get "day" tmpDatetime
  set weekday time:get "dayofweek" tmpDatetime

  ;;;; Conversion 12h vers 24
  if substring datetimeString 13 15 = "PM" and (substring datetimeString 0 2 != "12")[
    set tmpDatetime time:plus tmpDatetime 12 "hours"
  ]
  if substring datetimeString 13 15 = "AM" and (substring datetimeString 0 2 = "12")[
    set tmpDatetime time:plus tmpDatetime -12 "hours"
  ]

  set hour time:get "hour" tmpDatetime
  set minute time:get "minute" tmpDatetime
  set second time:get "second" tmpDatetime
  set currentDateTime tmpDatetime

  ;;; Calcul Saison
  if (month = 12 and day >= 21) or month = 1 or month = 2 or (month = 3 and day < 20)[
    set season "Winter"
  ]
  if (month = 3 and day >= 21) or month = 4 or month = 5 or (month = 6 and day < 20)[
    set season "Spring"
  ]
  if (month = 6 and day >= 21) or month = 7 or month = 8 or (month = 9 and day < 20)[
    set season "Summer"
  ]
  if (month = 9 and day >= 21) or month = 10 or month = 11 or (month = 12 and day < 20)[
    set season "Fall"
  ]
end

;; Fonction de calcul de la routine de l'utilisateur
to setupRoutine [inputWeekDay inputHour inputMinutes]
  ;;; Lecture fichier routine
  readRoutine inputWeekDay

  ;;; Récupération de la prochaine action de routine
  let i 0
  let isFinished false
  while[i < length routineTimes - 1 and not isFinished][
    let nextroutineTimeString item (i + 1) routineTimes
    let nextRoutineTimeHour read-from-string(substring nextroutineTimeString 0 2)
    let nextRoutineTimeMinute read-from-string (substring nextroutineTimeString 3 5)

    ;;; Si le routinetime d'après est déjà passé
    ifelse nextRoutineTimeHour < inputHour or (nextRoutineTimeHour = inputHour and nextRoutineTimeMinute < inputMinutes)[
      set isFinished true
    ][
      set i i + 1
    ]
  ]

  set nextRoutineIndex i
end

;; Temperature
to setupTemperature
  ;;;; Choix de la température de la journée en fonction de la saison
  ;;;; TODO Améliorer le choix de la température de la journée pour la faire varier un peu plus

  if season = "Winter" [
    set targetTemperatureOutsideMin minTemperatureWinter + (random ((maxTemperatureWinter - minTemperatureWinter) / 10))
    set targetTemperatureOutsideMax maxTemperatureWinter - (random ((maxTemperatureWinter - minTemperatureWinter) / 10))
  ]
  if season = "Spring" [
    set targetTemperatureOutsideMin minTemperatureSpring + (random ((maxTemperatureSpring - minTemperatureSpring) / 10))
    set targetTemperatureOutsideMax maxTemperatureSpring - (random ((maxTemperatureSpring - minTemperatureSpring) / 10))
  ]
  if season = "Summer" [
    set targetTemperatureOutsideMin minTemperatureSummer + (random ((maxTemperatureSummer - minTemperatureSummer) / 10))
    set targetTemperatureOutsideMax maxTemperatureSummer - (random ((maxTemperatureSummer - minTemperatureSummer) / 10))
  ]
  if season = "Fall" [
    set targetTemperatureOutsideMin minTemperatureFall + (random ((maxTemperatureFall - minTemperatureFall) / 2))
    set targetTemperatureOutsideMax maxTemperatureFall - (random ((maxTemperatureFall - minTemperatureFall) / 2))
  ]

  ;;;; Calcul du temps restant avant le prochain extremum
  ;;;;; Calcul des datetimes extremums
  ifelse hour < maxTemperatureHour
  [
    set dateTimeTemperatureMin time:create (word year "-" month "-" day " " minTemperatureHour)
  ][
    ;;;;;; Si setup lancé après heure max, mettre le pic au day suivant
    set dateTimeTemperatureMin time:create (word (time:get "year" currentDateTime) "-" (time:get "month" currentDateTime) "-" ((time:get "day" currentDateTime) + 1) " " minTemperatureHour)
  ]
  set dateTimeTemperatureMax time:create (word year "-" month "-" day " " maxTemperatureHour)

  ;;;;; Calcul du temps restant en secondes
  let secondsBeforeExtremum 0
  ;;;;;; Si après heure de la température max, utiliser l'heure de la température min du jour suivant (déjà calculé)
  ifelse time:is-after? currentDateTime dateTimeTemperatureMax [
    set secondsBeforeExtremum time:difference-between currentDateTime dateTimeTemperatureMin "seconds"
  ][
    ;;;;;; Si avant heure de la température min, utiliser l'heure de la température min
    ifelse time:is-before? currentDateTime dateTimeTemperatureMin[
      set secondsBeforeExtremum time:difference-between currentDateTime dateTimeTemperatureMin "seconds"
    ][
      ;;;;;; Si entre 2 extremums, utiliser l'heure de la température max
      set secondsBeforeExtremum time:difference-between currentDateTime dateTimeTemperatureMax "seconds"
    ]
  ]

  ;;;; Affectation des températures en fonction de la température cible
  ifelse time:is-before? dateTimeTemperatureMin dateTimeTemperatureMax[
    ;;;;; Si setup lancé avant pic max
    set secondsBetweenExtremums time:difference-between dateTimeTemperatureMin dateTimeTemperatureMax "seconds"
    set temperatureOutside targetTemperatureOutsideMin + (secondsBetweenExtremums - secondsBeforeExtremum) * ((targetTemperatureOutsideMax - targetTemperatureOutsideMin) / secondsBetweenExtremums)
  ][
    ;;;;; Si setup lancé après pic max
    set secondsBetweenExtremums time:difference-between dateTimeTemperatureMax dateTimeTemperatureMin "seconds"
    set temperatureOutside targetTemperatureOutsideMax - (secondsBetweenExtremums - secondsBeforeExtremum) * ((targetTemperatureOutsideMax - targetTemperatureOutsideMin) / secondsBetweenExtremums)
  ]
  set temperaturePrincipalRooms temperatureOutside
  set temperatureEntrance temperatureOutside
  set temperatureBathroom temperatureOutside
end

;; Luminosité
;;TODO GESTION HEURE ETE/HIVER
to setupLightOutside
  ;;; Lecture fichier Ephéméride
  readEphemeride month day

  ;;; Initialisation variable Luminosité extérieur
  ;;;; Si avant lever soleil ou après coucher soleil alors nuit noire
  if (time:is-before? currentDateTime (time:plus datetimeSunrise -45 "minutes") or time:is-after? currentDateTime (time:plus datetimeSunset 45 "minutes")) [
    set luminosityOutside 0
    set isNight true
  ]
  ;;;; Si après lever soleil ou avant coucher soleil alors jour
  if (time:is-after? currentDateTime (time:plus (time:plus datetimeSunrise 1 "days") 45 "minutes") or time:is-before? currentDateTime (time:plus datetimeSunset 45 "minutes")) [
    set luminosityOutside outsideMaxLuminosity
    set isNight false
  ]
  ;;;; Si aube
  if (time:is-after? currentDateTime datetimeSunrise and time:is-before? currentDateTime (time:plus datetimeSunrise 45 "minutes")) [
    set luminosityOutside (time:difference-between datetimeSunrise currentDateTime "seconds") * (outsideMaxLuminosity / 2700)
    set isNight true
  ]
  ;;;; Si crépuscule
  if (time:is-after? currentDateTime datetimeSunset and time:is-before? currentDateTime (time:plus datetimeSunset 45 "minutes")) [
    set luminosityOutside outsideMaxLuminosity - (time:difference-between currentDateTime datetimeSunset "seconds") * (outsideMaxLuminosity / 2700)
    set isNight false
  ]
end

;; Meubles
to setupFurniture
  ;;; Portes
  ask patches with [pcolor = 6.3][
    let pX pxcor
    let pY pycor
    sprout-doors 1[
      set shape "i beam"
      set color brown
      let targetHeading 0
      ask neighbors4 with [pxcor = pX - 1 or pxcor = pX + 1][
        if pcolor = 0[
          set targetHeading 90
        ]
      ]
      set heading targetHeading
    ]
  ]

  ;;; Tables
  ;;;; Tables salon
  ask patches with [ pxcor > 5 and pxcor < 10 and pycor = 1] [
    sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]
  ;;;; Table SàM
  ask patches with [ pxcor = 14 and pycor = 2] [
    sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]

  ;;;; Table Cuisine
  ask patches with [ pxcor = 16 and pycor = 7] [
    sprout-tables 1
    [
      set shape "square"
      set color brown
    ]
  ]

  ;;; Chaises
  ask patches with [ (pxcor = 13 or pxcor = 15) and (pycor = 1 or pycor = 3)] [
    sprout-chairs 1
    [
      set shape "box"
      set color brown
    ]
  ]

  ;;; Lit
  ask patches with [ pxcor = 8 and pycor = 8] [
    sprout-beds 1
    [
      set shape "bed"
      set heading 0
      set color brown
      set sleepQuality 0
      set isActive false
    ]
  ]

  ;;; Commode
  ask patches with [ pxcor = 6 and pycor = 6] [
    sprout-drawers 1
    [
      set shape "drawer"
      set heading 90
      set color brown
      set laundryQuantity 10
      ask patch-here[
        sprout-laundrys 10[
          set size 0.5
          set shape "tshirt"
          set weight 1
          set cleanliness 100
        ]
      ]
      create-containLinks-to dishes-here
    ]
  ]

  ;;; Placard
  ask patches with [ pxcor = 16 and pycor = 9] [
    sprout-cupboards 1
    [
      set shape "square 2"
      set color brown
      set dishesQuantity 10
      ask patch-here[
        sprout-dishes 10[
          set size 0.5
          set color white
          set shape "dish"
          set cleanliness 100
        ]
      ]
      create-containLinks-to dishes-here
    ]
  ]

  ;;;; Bibliothèque
  ask patches with [pxcor = 14 and pycor = 9] [
    sprout-bookshelfs 1
    [
      set shape "container"
      set color brown
      set bookQuantity 10
      ask patch-here[
        sprout-books 10[
          set shape "book"
          set size 0.5
        ]
      ]
      create-containLinks-to books-here
    ]
  ]

  ;; Meubles CONNECTES
  ;;; SDB
  ;;;; Douche
  ask patches with [pxcor = 1 and pycor = 6] [
    sprout-showers 1
    [
      set shape "drop"
      set color cyan
      set waterTemperature 0
      set debit 0
      set isActive false
    ]
    ;;;; Gestion temperature eau
    if any?(neighbors with [pcolor = 84.9])[
      ask showers-here[
        set waterTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask showers-here[
        set waterTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask showers-here[
        set waterTemperature temperaturePrincipalRooms
      ]
    ]
  ]

  ;;;; Toilettes
  ask patches with [pxcor = 1 and pycor = 9] [
    sprout-toilets 1
    [
      set shape "box"
      set color cyan
      set tankCapacity 100
      set fillingDebit 0
      set isActive false
    ]
  ]

  ;;;; Evier
  ask patches with [(pxcor = 4 and pycor = 9) or (pxcor = 16 and pycor = 6)] [
    sprout-sinks 1
    [
      set shape "chess rook"
      set color white
      set waterTemperature 0
      set debit 0
      set isActive false
    ]
    if any?(neighbors with [pcolor = 84.9])[
      ask sinks-here[
        set waterTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask sinks-here[
        set waterTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask sinks-here[
        set waterTemperature temperaturePrincipalRooms
      ]
    ]
  ]
  ;;;; Lave-linge
  ask patches with [pxcor = 2 and pycor = 6] [
    sprout-washingMachines 1
    [
      set shape "washingmachine"
      set heading 0
      set color black
      set dirtDegree 0
      set laundryWeight 0
      set isActive false
    ]
  ]
  ;;;; Sèche-linge
  ask patches with [pxcor = 4 and pycor = 6] [
    sprout-dryers 1
    [
      set shape "square"
      set heading 0
      set color white
      set temperature 0
      set humidity 0
      set laundryWeight 0
      set isActive false
    ]

  ;;; Cuisine
  ;;;; Cafetiere
  ask patches with [pxcor = 12 and pycor = 9] [
    sprout-coffeeMakers 1
    [
      set shape "tooth"
      set color black
      set coffeeCapacity 0
      set waterCapacity 100 ; TODO Gestion eau
      set coffeeTemperature 0
      set isActive false
    ]
    if any?(neighbors with [pcolor = 84.9])[
      ask coffeeMakers-here[
        set coffeeTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask coffeeMakers-here[
        set coffeeTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask coffeeMakers-here[
        set coffeeTemperature temperaturePrincipalRooms
      ]
    ]
  ]
  ;;;; Plaque
  ask patches with [pxcor = 12 and pycor = 8] [
    sprout-hotplates 1
    [
      set shape "molecule oxygen"
      set heading 0
      set color black
      set temperature 0
      set power 0
      set timeLeft 0
      set isActive false
    ]
    ;;;;; Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask hotplates-here[
        set temperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask hotplates-here[
        set temperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask hotplates-here[
        set temperature temperaturePrincipalRooms
      ]
    ]
  ]
  ;;;; Hotte
  ask patches with [pxcor = 12 and pycor = 8] [
    sprout-hoods 1
    [
      set shape "lander"
      set heading 0
      set color grey
      set power 0
      set isActive false
    ]
  ]
    ;;;;; Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask dryers-here[
        set temperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask dryers-here[
        set temperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask dryers-here[
        set temperature temperaturePrincipalRooms
      ]
    ]
  ]

  ;;;; Four
  ask patches with [pxcor = 12 and pycor = 6] [
    sprout-ovens 1
    [
      set shape "square"
      set heading 0
      set color grey
      set cookingMethod "Voute" ;;Peut être "Voute","Sole","Tournant"
      set power 0
      set temperature 0
      set timeLeft 0
      set isActive false
    ]
    ;;;;; Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask ovens-here[
        set temperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask ovens-here[
        set temperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask ovens-here[
        set temperature temperaturePrincipalRooms
      ]
    ]
  ]

  ;;;; Lave-vaisselle
  ask patches with [pxcor = 16 and pycor = 8] [
    sprout-dishwashers 1
    [
      set shape "square"
      set heading 0
      set color cyan
      set cycleMode "fill" ;;;;; Peut être "fill","rinse" et "dry"
      set timeLeft 0
      set pastillesQuantity 5
      set waterTemperature 0
      set waterLevel 0
      set dirtLevel 0
      set isActive false
    ]
    ;;;;; Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask dishwashers-here[
        set waterTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask dishwashers-here[
        set waterTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask dishwashers-here[
        set waterTemperature temperaturePrincipalRooms
      ]
    ]
  ]

  ;;;; Frigo
  ask patches with [pxcor = 12 and pycor = 7] [
    sprout-fridges 1
    [
      set shape "square 2"
      set heading 0
      set color white
      set temperature 2
      set isDoorOpen 0
      set fruitsQuantity 10
      set vegetablesQuantity 10
      set meatQuantity 10
      set mealQuantity 0
      set isActive true

      ;;;;; Ingrédients
      ask patch-here[
        sprout-fruits 5[
          set shape "apple"
          set size 0.5
          set color lime
          set nutrition random (nutritionFruitMax - nutritionFruitMin) + nutritionFruitMin
          set freshness 100
          set quantity 100
        ]
        sprout-vegetables 5[
          set shape "pumpkin"
          set size 0.5
          set color green
          set nutrition random (nutritionVegetableMax - nutritionVegetableMin) + nutritionVegetableMin
          set freshness 100
        ]
        sprout-meats 5[
          set shape "bread"
          set size 0.5
          set color red
          set nutrition random (nutritionMeatMax - nutritionMeatMin) + nutritionMeatMin
          set freshness 100
        ]
      ]
      create-containLinks-to fruits-here
      create-containLinks-to vegetables-here
      create-containLinks-to meats-here
    ]
  ]
  ;;;; Panier à linge
  ask patches with [pxcor = 16 and pycor = 5] [
    sprout-laundryBaskets 1
    [
      set shape "garbage can"
      set heading 0
      set color brown
      set laundryQuantity 0
    ]
  ]
  ;;;; Four à micro ondes
  ask patches with [pxcor = 12 and pycor = 5] [
    sprout-microwaves 1
    [
      set shape "square"
      set heading 0
      set color grey + 3
      set power 0
      set timeLeft 0
      set isActive false
    ]
  ]

  ;;; Salle à manger
  ;;;; Station roomba
  ask patches with [pxcor = 11 and pycor = 1] [
    sprout-roombaStations 1
    [
      set shape "circle 2"
      set color grey
      set isRoombaOnStation false
      set isActive false
    ]
  ]
  ;;;; Roomba
  ask patches with [pxcor = 11 and pycor = 1] [
    sprout-roombas 1
    [
      set shape "roomba"
      set color grey
      set size 0.7
      set bagCapacity 0
      set dirtLevel 0
      set battery 100
      set isActive true
      set isEnRoute false
      set targetPatch patch 0 0
      set current-path []
    ]
  ]

  ;; Création des meubles communs
  ;;; Lampes
  ask patches with
  [
    (pxcor = 2 and pycor = 2)
    or (pxcor = 2 and pycor = 7)
    or (pxcor = 8 and pycor = 6)
    or (pxcor = 8 and pycor = 2)
    or (pxcor = 13 and pycor = 2)
    or (pxcor = 14 and pycor = 6)
  ][
    sprout-lights 1[
      set shape "triangle 2"
      set color yellow
      set size 0.6
      set luminosity 250
      set lampColor 2700 ;en K ;TODO Couleurs lights différentes selon pièces
      set isActive false
    ]
  ]
  ;;; Chauffages
  ask patches with
  [
    (pxcor = 1 and pycor = 2)
    or (pxcor = 12 and pycor = 1)
    or (pxcor = 4 and pycor = 7)
    or (pxcor = 10 and pycor = 9)
  ][
    sprout-heaters 1[
      set shape "container"
      set color white
      set power heaterPower
      set ambiantTemperature 0
      set isActive false
    ]
    ;;;Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask heaters-here[
        set ambiantTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask heaters-here[
        set ambiantTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask heaters-here[
        set ambiantTemperature temperaturePrincipalRooms
      ]
    ]
  ]
  ;;; Climatiseurs
  ask patches with
  [
    pxcor = 16 and pycor = 2
  ][
    sprout-ACs 1[
      set shape "computer server"
      set color white
      set power ACPower
      set ambiantTemperature 0
      set isActive false
    ]
    ;;;; Gestion temperature
    if any?(neighbors with [pcolor = 84.9])[
      ask ACs-here[
        set ambiantTemperature temperatureBathroom
      ]
    ]
    if any?(neighbors with [pcolor = 64.7])[
      ask ACs-here[
        set ambiantTemperature temperatureEntrance
      ]
    ]
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ask ACs-here[
        set ambiantTemperature temperaturePrincipalRooms
      ]
    ]
  ]

  ;;; Création des alarmes
  ask patches with
  [
    pxcor = 12 and pycor = 4
  ][
    sprout-alarms 1[
      set shape "coin tails"
      set color white
      set size 0.7
      set isActive false
    ]
  ]

  ;;; Création des fenêtres et volets
  ask patches with [pcolor = 105] [
    sprout-windows 1
    [
      set shape "square 2"
      set color cyan
      set isOpen false
    ]
    sprout-shutters 1
    [
      set shape "square"
      set color cyan
      set isOpen true
    ]
  ]
end

;; Objets
to setupObjects
  ;;; Extincteur
  ask patches with [ pxcor = 1 and pycor = 4] [
    sprout-extinguishers 1
    [
      set shape "bottle"
      set heading 0
      set color red
      set powderQuantity 100
    ]
  ]
end

to setupSensors
  ;; Création des capteurs génériques
  ;;; Capteur CO
  ask patches with [
    (pxcor = 16 and pycor = 2)
    or (pxcor = 10 and pycor = 7)
  ][
    sprout-COSensors 1[
      set shape "cylinder"
      set color magenta
      set size 0.1
    ]
  ]
  ;;; Capteur Fumee
  ask patches with [
    (pxcor = 16 and pycor = 5)
  ][
    sprout-COSensors 1[
      set shape "cylinder"
      set color gray
      set size 0.1
    ]
  ]
  ;;; Capteur Temperature
  ask patches with [
    (pxcor = 4 and pycor = 2)
    or (pxcor = 4 and pycor = 6)
    or (pxcor = 6 and pycor = 2)
  ][
    sprout-temperatureSensors 1[
      set shape "cylinder"
      set color green
      set size 0.1
    ]
  ]
  ;;; Capteur luminosité
  ask patches with [
    (pxcor = 3 and pycor = 9)
    or (pxcor = 2 and pycor = 4)
    or (pxcor = 12 and pycor = 3)
  ][
    sprout-luminositySensors 1[
      set shape "cylinder"
      set color yellow
      set size 0.1
    ]
  ]

  ;;; Capteur Porte
  ask patches with [
    any?(doors-here)
  ][
    sprout-doorSensors 1[
      set shape "cylinder"
      set color blue
      set size 0.1
      create-sensorLink-to one-of doors-here
    ]
  ]
  ;;; Capteur Mouvement
  ask patches with [
    (pxcor = 4 and pycor = 8)
    or (pxcor = 10 and pycor = 5)
    or (pxcor = 16 and pycor = 1)
    or (pxcor = 4 and pycor = 4)
  ][
    sprout-moveSensors 1[
      set shape "cylinder"
      set color blue
      set size 0.1
    ]
  ]
  ;;; Capteur Allumage
  ask turtles with [ breed = showers
    or breed = toilets
    or breed = sinks
    or breed = beds
    or breed = coffeeMakers
    or breed = roombaStations
    or breed = roombas
    or breed = lights
    or breed = microwaves
    or breed = ovens
    or breed = dishwashers
    or breed = fridges
    or breed = hotplates
    or breed = hoods
    or breed = washingMachines
    or breed = dryers
    or breed = heaters
    or breed = alarms
    or breed = shutters
  ][
    ask patch-here[
      sprout-triggerSensors 1[
        set shape "cylinder"
        set color blue
        set size 0.1
        ;;Lien Capteur
        create-sensorLink-to one-of other turtles-here with [ (breed = showers
          or breed = toilets
          or breed = sinks
          or breed = beds
          or breed = coffeeMakers
          or breed = roombaStations
          or breed = roombas
          or breed = lights
          or breed = microwaves
          or breed = ovens
          or breed = dishwashers
          or breed = fridges
          or breed = hotplates
          or breed = hoods
          or breed = washingMachines
          or breed = dryers
          or breed = heaters
          or breed = alarms
          or breed = shutters)
          and count my-in-sensorLinks = 0
        ][
          set extractedDataName "isActive"
        ]
      ]
    ]
  ]
end

;; Utilisateur
to setupUser
  ask patches with [pxcor = 0 and pycor = 3][
    sprout-users 1 [
      ;;; Turtle
      set shape "person"
      set color white

      ;;; Pour pathfinding
      set current-path []
      set path []
      set isEnRoute false
      set targetPatch patch 0 0

      ;;; Tâches
      set tasks []
      set currentTask nobody

      ;;; Besoins
      set hunger 100
      set sleep 100
      set comfort 100
      set health 100
      set cleanliness 100
      set isSleeping false

      ;;; Anniversaire TODO VARIABILISER
      set age 21
      set birthDay 16
      set birthMonth 6

      ;;; Alerte
      set isAlert false

      ;;; Mouvement
      set isRunning false
      set moveSpeed 5
      set runSpeed 10
      set isOutside false

      ;;; Poids
      set weight 67
    ]
  ]
end

;; Luminosité intérieure
to setupLightInside
  ;;; Si il y a au moins un volet ouvert, luminosité pièce = luminosité extérieur
  ask shutters with [isOpen = true][
    ;;;; Si c'est un volet entrée
    if any?(neighbors with [pcolor = 64.7])[
      set luminosityEntrance luminosityOutside
    ]
    ;;;; Si c'est un volet pièce principale
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      set luminosityPrincipalRooms luminosityOutside
    ]
    ;;;; Si c'est un volet à côté de patch marron, regarder les patchs à côté
    if any?(neighbors with [pcolor = 23.3])[
      let shutterRoom ""
      ask neighbors with [pcolor = 23.3][
        if any?(neighbors with [pcolor = 64.7])[
          set shutterRoom "E" ;Entrée
        ]
        if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
          set shutterRoom "PP" ;Pièces principales
        ]
      ]
      if shutterRoom = "E" [
        set luminosityEntrance luminosityOutside
      ]
      if shutterRoom = "PP" [
        set luminosityPrincipalRooms luminosityOutside
      ]
    ]
  ]

  ;;; Si il y a des volets fermés mais des lights allumées, luminosite pièce = luminosite lampe
  ask lights with [isActive = true][
    ;;;; Pièces principales
    if (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3) and luminosityPrincipalRooms < luminosity [
      set luminosityPrincipalRooms luminosity
    ]
    ;;;; Entrée
    if pcolor = 64.7 and luminosityEntrance < luminosity [
      set luminosityEntrance luminosity
    ]
    ;;;; Salle de bain
    if pcolor = 84.9 and luminosityBathroom < luminosity [
      set luminosityBathroom luminosity
    ]
  ]
end

; FONCTION SETUP
to setup
  clear-all
  reset-ticks
  stop-inspecting-dead-agents

  ;; Initialisation variables globales
  ;;; Date et saison actuelle
  setupDate

  ;;; Routine
  setupRoutine weekDay hour minute

  ;;; Température
  setupTemperature

  ;;; Gestion de la luminosité extérieure
  setupLightOutside

  ;; Chargement des couleurs de patchs
  import-pcolors "appart_petit.png"

  ;; Création des meubles (manuel)
  setupFurniture

  ;; Création des objets
  setupObjects

  ;; Création des capteurs
  setupSensors

  ;; Création de l'utilisateur à la porte d'entrée
  setupUser

  ;; Initialisation variable Luminosité intérieur
  setupLightInside

end
; FIN SETUP


; FONCTIONS POUR GO
;; Incrémentation currentDateTime de 1 seconde
to incrementOneSecond
  set currentDateTime time:plus currentDateTime 1 "second"
  set year time:get "year" currentDateTime
  set month time:get "month" currentDateTime
  set day time:get "day" currentDateTime
  set weekday time:get "dayofweek" currentDateTime

  set hour time:get "hour" currentDateTime
  set minute time:get "minute" currentDateTime
  set second time:get "second" currentDateTime
end

;; Passage jour suivant
to newDay
  ;;; Définition routine du jour
  readRoutine weekday

  ;;; Définition éphéméride du jour
  readEphemeride month day

  ;;; Définition saison en fonction de la date
  if ((month = 12 and day >= 21) or month = 1 or month = 2 or (month = 3 and day < 20)) and season != "Winter"[
    set season "Winter"
  ]
  if ((month = 3 and day >= 21) or month = 4 or month = 5 or (month = 6 and day < 20)) and season != "Spring"[
    set season "Spring"
  ]
  if ((month = 6 and day >= 21) or month = 7 or month = 8 or (month = 9 and day < 20)) and season != "Summer"[
    set season "Summer"
  ]
  if ((month = 9 and day >= 21) or month = 10 or month = 11 or (month = 12 and day < 20)) and season != "Fall"[
    set season "Fall"
  ]
end

; Gestion de la lumière
to lightManagement
  ;; Lumière extérieure
  ;;; Aube
  if (time:is-after? currentDateTime datetimeSunrise and time:is-before? currentDateTime datetimeSunset and isNight)[
    if luminosityOutside >= 0 and luminosityOutside < outsideMaxLuminosity [
      set luminosityOutside (luminosityOutside + (outsideMaxLuminosity / 2700))
    ]
    if luminosityOutside < 0 [
      set luminosityOutside 0
    ]
    if luminosityOutside > outsideMaxLuminosity[
      set luminosityOutside outsideMaxLuminosity
    ]
    if luminosityOutside = outsideMaxLuminosity[
      set isNight false
    ]
  ]
  ;;; Crépuscule
  if (time:is-after? currentDateTime datetimeSunset and not isNight)[
    if luminosityOutside > 0 [
      set luminosityOutside (luminosityOutside - (outsideMaxLuminosity / 2700))
    ]
    if luminosityOutside < 0 [
      set luminosityOutside 0
    ]
    if luminosityOutside = 0 [
      set isNight true
    ]
  ]

  ;; Lumière intérieure
  ;;; Gestion de la luminosité des pièces sans fenêtre (Salle de bain)
  if not any?(lights with [pcolor = 84.9 and isActive])[
    set luminosityBathroom 0
  ]
  ;;; Gestion de la luminosité des pièces avec fenêtres sans volets ouverts
  ;;;; Pièces principales
  if not any?(shutters with [any?(neighbors with[pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3]) and isOpen])[
    let principalRoomsMaxLuminosity 0
    ask lights with[(pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3) and isActive][
      set principalRoomsMaxLuminosity luminosity
    ]
    set luminosityPrincipalRooms principalRoomsMaxLuminosity
  ]
  ;;;; Entrée
  if not any?(shutters with [any?(neighbors with[pcolor = 64.7]) and isOpen])[
    let entranceMaxLuminosity 0
    ask lights with[pcolor = 64.7 and isActive][
      set entranceMaxLuminosity luminosity
    ]
    set luminosityEntrance entranceMaxLuminosity
  ]

  ;;; Gestion lumière naturelle (Volets)
  ask shutters with [isOpen = true][
    ;;;; Volet entrée
    if any?(neighbors with [pcolor = 64.7])[
      ;;;;; Check luminosité lampe entrée
      let entranceMaxLuminosity luminosityOutside
      ask lights with [isActive and pcolor = 64.7][
        if luminosity > entranceMaxLuminosity[
          set entranceMaxLuminosity luminosity
        ]
      ]
      set luminosityEntrance entranceMaxLuminosity
    ]

    ;;;; Volet pièce principale
    if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
      ;;;;; Check luminosite lights pièces principales
      let principalRoomsMaxLuminosity luminosityOutside
      ask lights with [isActive and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
        if luminosity > principalRoomsMaxLuminosity[
          set principalRoomsMaxLuminosity luminosity
        ]
      ]
      set luminosityPrincipalRooms principalRoomsMaxLuminosity
    ]

    ;;;; Si volet à côté de patch marron, regarder les patchs à côté pour trouver la pièce
    if any?(neighbors with [pcolor = 23.3])[
      let shutterRoom ""
      ask neighbors with [pcolor = 23.3][
        if any?(neighbors with [pcolor = 64.7])[
          set shutterRoom "E" ;Entrée
        ]
        if any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])[
          set shutterRoom "PP" ;Pièces principales
        ]
      ]
      if shutterRoom = "E"[
        ;;;;; Check luminosite lampe entree
        let entranceMaxLuminosity luminosityOutside
        ask lights with [isActive and pcolor = 64.7][
          if luminosity > entranceMaxLuminosity[
            set entranceMaxLuminosity luminosity
          ]
        ]
        set luminosityEntrance entranceMaxLuminosity
      ]
      if shutterRoom = "PP"[
        ;;;;; Check luminosite lights pièces principales
        let principalRoomsMaxLuminosity luminosityOutside
        ask lights with [isActive and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
          if luminosity > principalRoomsMaxLuminosity[
            set principalRoomsMaxLuminosity luminosity
          ]
        ]
        set luminosityPrincipalRooms principalRoomsMaxLuminosity
      ]
    ]
  ]

  ;;; Lumière des lampes
  ask lights with [isActive = true][
    ;;;; Si luminosité inférieur à celui de la lampe (ex: nuit/volets fermés)
    ;;;;; Pièces principales
    if (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3) and luminosityPrincipalRooms < luminosity [
      set luminosityPrincipalRooms luminosity
    ]
    ;;;;; Entrée
    if pcolor = 64.7 and luminosityEntrance < luminosity [
      set luminosityEntrance luminosity
    ]
    ;;;;; Salle de bain
    if pcolor = 84.9 and luminosityBathroom < luminosity [
      set luminosityBathroom luminosity
    ]
  ]
end

; Gestion de la température extérieure
to temperatureOutsideManagement
  ;;; Si heure du pic atteint, alors temperatureOutside = temperature du pic et on met le datetime du prochain pic au lendemain
  if time:is-equal? currentDateTime dateTimeTemperatureMax[
    set temperatureOutside targetTemperatureOutsideMax
    set dateTimeTemperatureMin time:plus dateTimeTemperatureMin 1 "day"
    if season = "Winter" [
      set targetTemperatureOutsideMin minTemperatureWinter + (random ((maxTemperatureWinter - minTemperatureWinter) / 10))
    ]
    if season = "Spring" [
      set targetTemperatureOutsideMin minTemperatureSpring + (random ((maxTemperatureSpring - minTemperatureSpring) / 10))
    ]
    if season = "Summer" [
      set targetTemperatureOutsideMin minTemperatureSummer + (random ((maxTemperatureSummer - minTemperatureSummer) / 10))
    ]
    if season = "Fall" [
      set targetTemperatureOutsideMin minTemperatureFall + (random ((maxTemperatureFall - minTemperatureFall) / 2))
    ]
    set secondsBetweenExtremums time:difference-between dateTimeTemperatureMax dateTimeTemperatureMin "seconds"
  ]

  if time:is-equal? currentDateTime dateTimeTemperatureMin[
    set temperatureOutside targetTemperatureOutsideMin
    set dateTimeTemperatureMax time:plus dateTimeTemperatureMax 1 "day"
    if season = "Winter" [
      set targetTemperatureOutsideMax maxTemperatureWinter - (random ((maxTemperatureWinter - minTemperatureWinter) / 10))
    ]
    if season = "Spring" [
      set targetTemperatureOutsideMax maxTemperatureSpring - (random ((maxTemperatureSpring - minTemperatureSpring) / 10))
    ]
    if season = "Summer" [
      set targetTemperatureOutsideMax maxTemperatureSummer - (random ((maxTemperatureSummer - minTemperatureSummer) / 10))
    ]
    if season = "Fall" [
      set targetTemperatureOutsideMax maxTemperatureFall - (random ((maxTemperatureFall - minTemperatureFall) / 2))
    ]
    set secondsBetweenExtremums time:difference-between dateTimeTemperatureMin dateTimeTemperatureMax "seconds"
  ]

  ;;; Si après heure de la température max ou avant heure de la température min, diminuer la température
  ifelse time:is-after? currentDateTime dateTimeTemperatureMax or time:is-before? currentDateTime dateTimeTemperatureMin [
    set temperatureOutside temperatureOutside - ((targetTemperatureOutsideMax - targetTemperatureOutsideMin) / secondsBetweenExtremums)
  ][ ;;; Sinon (entre 2 extremums), monter la température
    set temperatureOutside temperatureOutside + ((targetTemperatureOutsideMax - targetTemperatureOutsideMin) / secondsBetweenExtremums)
  ]
end

; Gestion du thermostat
to thermostatManagement
  ;; Activation Chauffage
  ;;; Entrée

  ifelse temperatureEntrance < thermostat[
    ask heaters with [isActive = false and pcolor = 64.7][
      set isActive true
      set color red
    ]
  ][
    ask heaters with [isActive = true and pcolor = 64.7][
      set isActive false
      set color white
    ]
  ]

  ;;; Pièces principales

  ifelse temperaturePrincipalRooms < thermostat[
    ask heaters with [isActive = false and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
      set isActive true
      set color red
    ]
  ][
    ask heaters with [isActive = true and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
      set isActive false
      set color white
    ]
  ]


  ;;; Salle de bain
  ifelse temperatureBathroom < thermostat[
    ask heaters with [isActive = false and pcolor = 84.9][
      set isActive true
      set color red
    ]
  ][
    ask heaters with [isActive = true and pcolor = 84.9][
      set isActive false
      set color white
    ]
  ]


  ;; Activation Climatisation
  ;;; Pièces principales
  ifelse temperaturePrincipalRooms > thermostat[
    ask ACs with [isActive = false and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
      set isActive true
      set color cyan
    ]
  ][
    ask ACs with [isActive = true and (pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3)][
      set isActive false
      set color white
    ]
  ]
end

; Gestion de la température intérieure
to insideTemperatureManagement
  ;;; Echange passif avec extérieur
  ;;;; Si au moins 1 fenêtre ouverte dans les pièces principales, isolation avec l'extérieur divisé par 100
  ifelse any?(windows with [isOpen = true and (any?(neighbors with [pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3]) or any?(neighbors with[pcolor = 23.3 and any?(neighbors with[pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3])]))])
  [
    set temperaturePrincipalRooms temperaturePrincipalRooms - ((temperaturePrincipalRooms - temperatureOutside) / (isolation / 100))
  ][
    set temperaturePrincipalRooms temperaturePrincipalRooms - ((temperaturePrincipalRooms - temperatureOutside) / isolation)
  ]
  ;;;; Si au moins 1 fenêtre ouverte dans l'entrée
  ifelse any?(windows with [isOpen = true and (any?(neighbors with [pcolor = 64.7]) or any?(neighbors with[pcolor = 23.3 and any?(neighbors with[pcolor = 64.7])]))])
  [
    set temperatureEntrance temperatureEntrance - ((temperatureEntrance - temperatureOutside) / (isolation / 100))
  ][
    set temperatureEntrance temperatureEntrance - ((temperatureEntrance - temperatureOutside) / isolation)
  ]
  ;;;; Gestion température SdB
  set temperatureBathroom temperatureBathroom - ((temperatureBathroom - temperatureOutside) / isolation)


  ;;; Equilibre température entre les pièces
  let avgTemperature 0
  ;;;; Entrée-Salle de bain
  set avgTemperature (temperatureEntrance + temperatureBathroom) / 2
  set temperatureEntrance temperatureEntrance - ((temperatureEntrance - avgTemperature) / (isolation / 10)) ;;TODO Revoir isolation intérieure (variable isolationInterieur au lieu de diviser par 10 ?)
  set temperatureBathroom temperatureBathroom - ((temperatureBathroom - avgTemperature) / (isolation / 10))

  ;;;; Entrée-PiècesPrincipales
  set avgTemperature (temperatureEntrance + temperaturePrincipalRooms) / 2
  set temperatureEntrance temperatureEntrance - ((temperatureEntrance - avgTemperature) / (isolation / 10))
  set temperaturePrincipalRooms temperaturePrincipalRooms - ((temperaturePrincipalRooms - avgTemperature) / (isolation / 10))

  ;;; Chauffage
  ;;; On assume qu'il faut 70W pour 1m3
  ask heaters with [isActive = true][
    ;;;; Entrée
    if pcolor = 64.7[
      set temperatureEntrance temperatureEntrance + ( (power / (25 * 70)) / 3600 ) ;;;;; On assume que la pièce fait 25m3 (9m², 2.8m de hauteur)
    ]
    ;;;; Pièces principales
    if pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3[
      set temperaturePrincipalRooms temperaturePrincipalRooms + ( (power / (84 * 70)) / 3600 ) ;;;;; On assume que la pièce fait 84m3 (30m², 2.8m de hauteur)
    ]
    ;;;; Salle de bain
    if pcolor = 84.9[
      set temperatureBathroom temperatureBathroom + ( (power / (25 * 70)) / 3600 )
    ]
  ]

  ;;; Refroidissement par clim
  ;;; On assume qu'il faut 100W pour 1m3
  ask ACs with [isActive = true][
    ;;;; Entrée
    if pcolor = 64.7[
      set temperatureEntrance temperatureEntrance - ( (power / (25 * 100)) / 3600 ) ;;;;; On assume que la pièce fait 25m3
    ]
    ;;;; Pièces principales
    if pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3[
      set temperaturePrincipalRooms temperaturePrincipalRooms - ( (power / (84 * 100)) / 3600 ) ;;;;; On assume que la pièce fait 30m3
    ]
    ;;;; Salle de bain
    if pcolor = 84.9[
      set temperatureBathroom temperatureBathroom - ( (power / (25 * 100)) / 3600 )
    ]
  ]
end

; Gestion de la saleté
to dirtManagement
  ;; On assume qu'une pièce met 1 semaine à être sale
  ;;; Entrée
  if dirtEntrance < 100 [
    set dirtEntrance dirtEntrance + (100 / 604800)
  ]
  if dirtEntrance > 100 [
    set dirtEntrance 100
  ]
  ;;; Chambre
  if dirtBedroom < 100 [
    set dirtBedroom dirtBedroom + (100 / 604800)
  ]
  if dirtBedroom > 100 [
    set dirtBedroom 100
  ]
  ;;; Salle à manger
  if dirtDiningroom < 100 [
    set dirtDiningRoom dirtDiningRoom + (100 / 604800)
  ]
  if dirtDiningRoom > 100 [
    set dirtDiningRoom 100
  ]
  ;;; Cuisine
  if dirtKitchen < 100 [
    set dirtKitchen dirtKitchen + (100 / 604800)
  ]
  if dirtKitchen > 100 [
    set dirtKitchen 100
  ]
  ;;; Salle de bain
  if dirtBathroom < 100 [
    set dirtBathroom dirtBathroom + (100 / 604800)
  ]
  if dirtBathroom > 100 [
    set dirtBathroom 100
  ]
end


; Pathfinding
;; Recherche de chemin via A*
to-report findPath [source-patch destination-patch]

  ; initialize all variables to default values
  let search-done false
  let search-path []
  let current-patch 0
  let open []
  let closed []

  ; add source patch in the open list
  set open lput source-patch open

  ; loop until we reach the destination or the open list becomes empty
  while [search-done != true][
    ifelse length open != 0[

      ; take the first patch in the open list
      ; as the current patch (which is currently being explored (n))
      ; and remove it from the open list
      set current-patch item 0 open
      set open remove-item 0 open

      ; add the current patch to the closed list
      set closed lput current-patch closed

      ; explore the Von Neumann (left, right, top and bottom) neighbors of the current patch
      ask current-patch[
        ; if any of the neighbors is the destination stop the search process
        ifelse any? neighbors with [ (pxcor = [ pxcor ] of destination-patch) and (pycor = [pycor] of destination-patch)][
          set search-done true
        ]
        [
          ; the neighbors should not be obstacles or already explored patches (part of the closed list)
          ask neighbors with [pcolor != 0 and pcolor != 105 and pcolor != 23.3 and (not member? self closed) and (self != parent-patch)]
          [
            ; the neighbors to be explored should also not be the source or
            ; destination patches or already a part of the open list (unexplored patches list)
            if not member? self open and self != source-patch and self != destination-patch
            [
              ; add the eligible patch to the open list
              set open lput self open

              ; update the path finding variables of the eligible patch
              set parent-patch current-patch
              set g [g] of parent-patch  + 1
              set h distance destination-patch
              set f (g + h)
            ]
          ]
        ]
      ]
    ]
    [
      ; if a path is not found (search is incomplete) and the open list is exhausted
      ; display a user message and report an empty search path list.
      report []
    ]
  ]

  ; if a path is found (search completed) add the current patch
  ; (node adjacent to the destination) to the search path.
  set search-path lput current-patch search-path

  ; trace the search path from the current patch
  ; all the way to the source patch using the parent patch
  ; variable which was set during the search for every patch that was explored
  let temp first search-path
  while [ temp != source-patch ]
  [
    set search-path lput [parent-patch] of temp search-path
    set temp [parent-patch] of temp
  ]

  ; add the destination patch to the front of the search path
  set search-path fput destination-patch search-path

  ; reverse the search path so that it starts from a patch adjacent to the
  ; source patch and ends at the destination patch
  set search-path reverse search-path

  ; report the search path
  report search-path
end

;; Suivre le chemin avec vitesse en paramètre (en patch/s)
to goToNextPatchInCurrentPath [speed]
  ifelse speed > length current-path[
    move-to last current-path
    set current-path []
  ][
    let nextPatch item ((round speed) - 1) current-path
    face nextPatch
    move-to nextPatch
    let i 0
    while [i < speed][
      set current-path remove-item 0 current-path
      set i i + 1
    ]
  ]
end

to findShortestPathToDestination
  set path findPath patch-here targetPatch
  let optimal-path path
  set current-path path
end

; Comportement roomba
to roombaBehaviour
  ask roombas with[isActive][
    ;;; Si pas sur la station
    ifelse battery > lowBattery [
      let patchAhead patch-ahead 1
      let isPatchAheadWalkable false
      ask patchAhead [
        if pcolor != 0 and pcolor != 105 and pcolor != 23.3[
          set isPatchAheadWalkable true
        ]
      ]
      ;;;; Si le patch peut être atteint (pas un mur/meuble)
      ifelse isPatchAheadWalkable[
        move-to patchAhead
      ][
        ;;;;; Tourne à droite entre 15 et 160° si mur/meuble
        right (random 145) + 15
      ]
      ;;;; Le capteur bouge avec le roomba
      let x xcor
      let y ycor
      ask my-sensorLinks[
        ask other-end[
          move-to patch x y
        ]
      ]
    ][
      ;;;; Si batterie faible, va vers la station cible
      ifelse isEnRoute[
        goToNextPatchInCurrentPath 1 ;;;; 1 patch/s
        let x xcor
        let y ycor
        ;;;; Le capteur bouge avec le roomba
        ask my-sensorLinks[
          ask other-end[
            move-to patch x y
          ]
        ]
        ;;;; Si sur le patch monte sur la station
        if patch-here = targetPatch[
          set isEnRoute false
          set targetPatch patch 0 0
          set isActive false
          ask roombaStations-here[
            set isRoombaOnStation true
            set isActive true
          ]
        ]
      ][
        ;;;; Recherche de la station roomba proche
        let targetPatchTmp patch 0 0
        let isFound false
        ask one-of roombaStations with [isRoombaOnStation = false][
          set targetPatchTmp patch-here
          set isFound true
        ]
        ;;;; Si station libre, cherche un chemin
        if isFound[
          set targetPatch targetPatchTmp
          set isFound false
        ]
        findShortestPathToDestination
        set isEnRoute true
      ]
    ]

    ;;;; Détection saleté et nettoyage de la pièce
    ;;;;; Entrée
    if [pcolor] of patch-here = 64.7[
      set dirtLevel dirtEntrance
      set dirtEntrance dirtEntrance - ( 100 / 60 )
      if dirtEntrance < 0[
        set dirtEntrance 0
      ]
    ]
    ;;;;; Pièces principales
    if [pcolor] of patch-here = 126.3[
      set dirtLevel dirtBedroom
      set dirtBedroom dirtBedroom - ( 100 / 60 )
      if dirtBedroom < 0[
        set dirtBedroom 0
      ]
    ]
    if [pcolor] of patch-here = 44.4[
      set dirtLevel dirtKitchen
      set dirtKitchen dirtKitchen - ( 100 / 60 )
      if dirtKitchen < 0[
        set dirtKitchen 0
      ]
    ]
    if [pcolor] of patch-here = 14.4[
      set dirtLevel dirtDiningRoom
      set dirtDiningRoom dirtDiningRoom - ( 100 / 60 )
      if dirtDiningRoom < 0[
        set dirtDiningRoom 0
      ]
    ]
    ;;;;; Salle de bain
    if [pcolor] of patch-here = 84.9[
      set dirtLevel dirtBathroom
      set dirtBathroom dirtBathroom - ( 100 / 60 )
      if dirtBathroom < 0[
        set dirtBathroom 0
      ]
    ]

    ;;;; Déchargement de la batterie
    ;;;; On assume que le roomba a une autonomie de 75 minutes (iRobot Roomba i7)
    set battery battery - (100 / 4500)
    if battery < 0[
      set battery 0
    ]
  ]
end

; Comportement station Roomba
to roombaStationBehaviour
  ask roombaStations with [isActive][
    ;;; Si sur station
    ask roombas-here[
      ;;;; Déconnexion station si chargé
      ifelse battery = 100[
        ask roombaStations-here[
          set isRoombaOnStation false
          set isActive false
        ]
        set isActive true
      ][
        ;;;; Chargement
        ;;;; On assume que le roomba met 90 minutes à charger (iRobot roomba i7)
        set battery battery + ( 100 / 5400 )
        if battery > 100 [
          set battery 100
        ]
      ]
    ]
  ]
end

; Fonctions intermédiaires pour comportement utilisateur
;; Poser un objet par terre/dans un meuble/sur un meuble
to put [inputUser inputObject inputDestinationPatch]
  if inputObject != nobody[
    ask inputUser[
      ask my-carryLinks with[other-end = inputObject][die]
    ]
    ask inputObject[
      move-to inputDestinationPatch
    ]
    ask inputDestinationPatch[
      ;;; Insertion dans contenant
      ask washingMachines-here[
        create-containLink-to inputObject
      ]
      ask dryers-here[
        create-containLink-to inputObject
      ]
      ask ovens-here[
        create-containLink-to inputObject
      ]
      ask dishwashers-here[
        create-containLink-to inputObject
      ]
      ask fridges-here[
        create-containLink-to inputObject
      ]
      ask laundryBaskets-here[
        create-containLink-to inputObject
      ]
      ask bookshelfs-here[
        create-containLink-to inputObject
      ]
      ask microwaves-here[
        create-containLink-to inputObject
      ]
      ask cupboards-here[
        create-containLink-to inputObject
      ]
      ask coffeemakers-here[
        create-containLink-to inputObject
      ]
    ]
  ]
end
;; Prendre un objet
to take [inputUser inputObject]
  ;;; Pour gérer cas meal/dish
  if inputObject != nobody[
    let parentObject nobody
    ask inputObject[
      ;;; Supression liens contenance (hors dish)
      ask my-in-containLinks with[not is-dish? other-end][die]
      ask my-in-containLinks with[is-dish? other-end][
        set parentObject other-end
      ]
    ]
    ask inputUser[
      create-carryLink-to inputObject
      if parentObject != nobody[
        create-carryLink-to parentObject
      ]
    ]
  ]
end
;; Crée et retourne la tâche sous forme de taskLink
to-report createTask [inputUser inputAction inputTarget inputPriority]
  let createdTask nobody
  if inputTarget != nobody[
    ask inputUser[
      ;;; Mettre fin à l'ancienne tâche si même cible et même tâche
      ask my-taskLinks[
        if other-end = inputTarget and action = inputAction [
          endTask inputUser nobody
        ]
      ]
      if is-turtle? inputTarget[
        ;;; Si cible turtle
        create-taskLink-to inputTarget
        [
          set action inputAction
          set priority inputPriority
          set createdTask self
        ]
      ]
    ]
  ]
  report createdTask
end

;; Réalisation action tâche
;; TODO

;; Fin de tâche
to endTask [inputUser inputNextTask]
  ask inputUser[
    ;;; Met fin à la tâche actuelle et met la prochaine tâche
    if currentTask != nobody[
      ask currentTask[die]
    ]
    set currentTask inputNextTask

    if inputNextTask != nobody[
      ;;; Définition du nouveau patch cible
      let taskTargetPatch nobody
      ask inputNextTask[
        ask other-end[
          set taskTargetPatch patch-here
        ]
      ]
      let realTargetPatch nobody
      ifelse member? taskTargetPatch neighbors or taskTargetPatch = patch-here[
        set realTargetPatch patch-here
      ][
        ask taskTargetPatch[
          if pcolor = 23.3[
            set realTargetPatch one-of neighbors with[pcolor != 0 and pcolor != 105 and pcolor != 23.3]
          ]
          if pcolor != 0 and pcolor != 105 and pcolor != 23.3[
            set realTargetPatch self
          ]
        ]
      ]

      ;;; Met le user en route si il faut se déplacer
      set targetPatch realTargetPatch
      ifelse realTargetPatch != patch-here[
        findShortestPathToDestination
        set isEnRoute true
      ][
        set isEnRoute false
      ]
    ]
  ]
end


; Comportement Utilisateur
to userBehaviour
  ask Users[
    let currentUser self
    ;; Récupération du type de tâche en cours
    let currentTaskAction nobody
    if currentTask != nobody [
      ask currentTask[
        set currentTaskAction action
      ]
    ]
    ifelse isOutside[
      ;; Si est dehors
      if not hidden?[
        set hidden? true
      ]
      ;;; Mange dehors si a faim
      if hunger < 10[
        set hunger hunger + ( 30 + random (60 - 30) )
      ]

      ;; Gestion tâches dehors
      ;;; Tâche faire les courses
      ;;; Cible = porte d'entrée
      if currentTaskAction = "go to store"[
        let isFinished false
        ask currentTask [
          if time >= ( 60 * 60 )[ ;;;;; Durée 1H TODO Rendre variable
            set isFinished true
          ]
        ]

        if isFinished[
          set isOutside false
          ;;;;; Rentrer avec les courses
          ask patch-here[
            sprout-fruits 5[
              set shape "apple"
              set size 0.5
              set color lime
              set nutrition random (nutritionFruitMax - nutritionFruitMin) + nutritionFruitMin
              set freshness 100
              set quantity 100
              take currentUser self
            ]
            sprout-vegetables 5[
              set shape "pumpkin"
              set size 0.5
              set color green
              set nutrition random (nutritionVegetableMax - nutritionVegetableMin) + nutritionVegetableMin
              set freshness 100
              take currentUser self
            ]
            sprout-meats 5[
              set shape "bread"
              set size 0.5
              set color red
              set nutrition random (nutritionMeatMax - nutritionMeatMin) + nutritionMeatMin
              set freshness 100
              take currentUser self
            ]
          ]
          let nextTask createTask currentUser "store groceries" one-of fridges 1
          endTask currentUser nextTask
        ]
      ]
    ][;; Si est à la maison
      if hidden?[
        set hidden? false
      ]
      ;; Si pas de tâche en cours
      ifelse currentTask = nobody[
        if count my-taskLinks != 0[
          ;;; Récupération de la tâche la plus prioritaire
          ;;; TODO Interrompre tâche si tâche plus prioritaire apparait
          let tasksSorted sort-on [priority] my-taskLinks
          set currentTask first tasksSorted

          ;;;; Récupération destination
          let taskTargetPatch nobody
          ask currentTask[
            ask other-end[
              set taskTargetPatch patch-here
            ]
          ]
          let realTargetPatch nobody
          ifelse member? taskTargetPatch neighbors or taskTargetPatch = patch-here[
            set realTargetPatch patch-here
          ][
            ask taskTargetPatch[
              if pcolor = 23.3[
                set realTargetPatch one-of neighbors with[pcolor != 0 and pcolor != 105 and pcolor != 23.3]
              ]
              if pcolor != 0 and pcolor != 105 and pcolor != 23.3[
                set realTargetPatch self
              ]
            ]
          ]
          set targetPatch realTargetPatch

          ;;; Calcul de la route
          findShortestPathToDestination
          set isEnRoute true
        ]
      ][
        ;; Si tache en cours
        ifelse isEnRoute[
          ;;; Va vers la destination si pas encore arrivé
          goToNextPatchInCurrentPath 1 ;moveSpeed

          if patch-here = targetPatch[
            set isEnRoute false
            set current-path []
          ]
        ][
          ;;; Si arrivé à destination
          ;;; Réalisation de l'action

          ;;;; Tâche aller chercher un casse croute (Restes ou fruit)
          ;;;; Cible = frigo
          if currentTaskAction = "get something to eat"[
            let thingToEat nobody
            let thingToEatBreed nobody
            let nextTask nobody
            ask fridges-on neighbors[
              ;;;;; Choisit une chose à manger au frigo (restes en prio)
              if any?(fruits-here) [
                set thingToEat one-of fruits-here
                set thingToEatBreed "fruit"
              ]
              if any?(meals-here) [
                set thingToEat one-of meals-here
                ask thingToEat[
                  ask one-of my-in-containLinks with[is-dish? other-end][
                    set thingToEat other-end
                  ]
                ]
                set thingToEatBreed "meal"
              ]
            ]

            ;;;;; Prend la chose à manger du frigo
            if thingToEat != nobody [
              take currentUser thingToEat
              ;;;;; Si restes, mange à table
              ifelse thingToEatBreed = "meal"[
                let tableTmp one-of tables with[any?(chairs-on neighbors)]
                let chairTmp nobody
                ask tableTmp[
                  set chairTmp one-of chairs-on neighbors
                ]
                set nextTask createTask currentUser "put meal on table" tableTmp 1
              ][
                ;;;;; Si fruit, mange sur place
                set nextTask createTask currentUser "eat fruit" thingToEat 1
              ]
            ]

            ;;;;; Fin de la tache
            endTask currentUser nextTask
          ]

          ;;;; Tâche poser un repas sur la table
          ;;;; Cible = Table
          if currentTaskAction = "put meal on table"[
            let tableToPut nobody
            let patchTableToPut nobody
            ask currentTask[
              set tableToPut other-end
              ask tableToPut[
                set patchTableToPut patch-here
              ]
            ]
            let dishToEat nobody
            let mealToEat nobody
            ask my-carryLinks with[is-dish? other-end][
              set dishToEat other-end
            ]
            ask dishToEat[
              ask my-containLinks with[is-meal? other-end][
                set mealToEat other-end
              ]
            ]
            put currentUser dishToEat patchTableToPut
            let nextTask createTask currentUser "eat on table" mealToEat 1
            endTask currentUser nextTask
          ]


          ;;;; Tâche poser quelque chose
          ;;;; Cible = Turtle
          if currentTaskAction = "put"[
            let patchToPut nobody
            ask currentTask[
              ask other-end[
                set patchToPut patch-here
              ]
            ]
            let thingToPut nobody
            ask my-carryLinks[
              set thingToPut other-end
              ask thingToPut[
                put currentUser thingToPut patchToPut
              ]
            ]
            endTask currentUser nobody
          ]

          ;;;; Tâche prendre un objet
          ;;;; Cible = objet
          if currentTaskAction = "take"[
            let thingToTake nobody
            ask currentTask[
              ask other-end[
                set thingToTake self
              ]
            ]
            take currentUser thingToTake
            endTask currentUser nobody
          ]

          ;;;; Tâche manger fruit sur place
          ;;;; Cible = Fruit
          if currentTaskAction = "eat fruit"[
            let isFinished false
            let isStuffed false
            if hunger >= 100[
              set hunger 100
              set isStuffed true
            ]
            ask currentTask[
              ifelse isStuffed[
                ;;;;; Si a plus faim, met le fruit au frigo
                let nextTask createTask currentUser "put" one-of fridges 1
                endTask currentUser nextTask
              ][
                ;;;;; Si a encore faim, mange le fruit
                ask other-end[
                  ;;;;;; Diminution quantité nourriture
                  ifelse quantity > 0[
                    ;;;;;;; 1 minute pour tout manger
                    set quantity quantity - ( 100 / 60 )
                    let nutritionTmp nutrition
                    ask currentUser[
                      set hunger hunger + ( nutritionTmp / 60 )
                    ]
                  ][
                    ;;;;;;; Si fruit entièrement mangé
                    set isFinished true
                    die
                  ]
                ]
                if isFinished [
                  endTask currentUser nobody
                ]
              ]
            ]
          ]

          ;;;; Tâche manger repas sur table
          ;;;; Cible = Meal
          if currentTaskAction = "eat on table"[
            let currentMeal nobody
            let currentDish nobody
            let isFinished false
            let isStuffed false
            let isSit false
            ask currentTask[
              set currentMeal other-end
            ]
            ask currentMeal[
              ask my-in-containLinks with[is-dish? other-end][
                set currentDish other-end
              ]
            ]
            if hunger >= 100[
              set hunger 100
              set isStuffed true
            ]
            if any?(chairs-here)[
              set isSit true
            ]
            ifelse isSit[
              ;;;;; Si déjà assis
              ifelse isStuffed[
                ;;;;; Si plus faim, met les restes au frigo
                take currentUser currentDish
                let nextTask createTask currentUser "put" one-of fridges 1
                endTask currentUser nextTask
              ][
                ;;;;; Si a encore faim, mange le repas
                ask currentTask[
                  ask other-end[
                    ifelse quantity > 0[
                      ;;;; 20 minutes pour manger
                      set quantity quantity - ( 100 / (60 * 20) )
                      let nutritionTmp nutrition
                      ask currentUser[
                        set hunger hunger + ( nutritionTmp / (60 * 20) )
                      ]
                    ][
                      ;;;;;;; Si repas entièrement mangé
                      set isFinished true
                      die
                    ]
                  ]
                ]
                if isFinished[
                  ask currentDish[
                    set cleanliness 0
                  ]

                  ;;;;; Création tâche mettre au lave-vaisselles
                  take currentUser currentDish
                  let nextTask createTask currentUser "put" one-of dishwashers with [isActive = false] 1
                  ;;;;; Fin de la tâche
                  endTask currentUser nextTask
                ]
              ]
            ][
              ;;;;; Sinon s'assoir
              let nextTask nobody
              ask currentMeal[
                set nextTask createTask currentUser "sit" one-of chairs-on neighbors 1
              ]
              endTask currentUser nextTask
            ]
          ]

          ;;;; Tâche s'assoir
          ;;;; Cible = chaise
          if currentTaskAction = "sit"[
            let whereToSit nobody
            ask currentTask[
              set whereToSit other-end
            ]
            move-to whereToSit
            ;;;;; Fin de la tâche
            let nextTask nobody
            if any?(meals-on neighbors)[
              set nextTask createTask currentUser "eat on table" one-of meals-on neighbors 1
            ]
            endTask currentUser nextTask
          ]

          ;;;; Tâche aller au lit
          ;;;; Cible = lit
          if currentTaskAction = "sleep"[
            let bedTmp nobody
            let isFinished false
            ask currentTask[
              set bedTmp other-end
            ]

            ;;;;; Monte sur le lit
            if not any?(beds-here)[
              move-to bedTmp
            ]

            ;;;;; Dors
            set isSleeping true
            ifelse isSleeping and sleep < 99[
              ;;;;;; 9h de sommeil max
              set sleep sleep + ( 100 / (60 * 60 * 9) )
            ][
              set isFinished true
            ]
            if isFinished [
              ;;;;;; Si bien dormi
              set isSleeping false
              endTask currentUser nobody
            ]
          ]

          ;;;; Tâche sieste
          if currentTaskAction = "rest"[
            let bedTmp nobody
            let isFinished false
            ask currentTask[
              set bedTmp other-end
            ]

            ;;;;; Monte sur le lit
            if not any?(beds-here)[
              move-to bedTmp
            ]

            ;;;;; Dors
            if not isSleeping [set isSleeping true]

            ;;;;; Vérification temps de sieste (3h max)
            let taskTime 0
            ask currentTask [set taskTime time]
            ifelse sleep < 99 and taskTime < ( 60 * 60 * 3) [
              ;;;;;; Si dort encore
              ;;;;;; 9h de sommeil pour remplir besoin 100%
              set sleep sleep + ( 100 / (60 * 60 * 9) )
            ][
              ;;;;;; Si se réveille
              set isFinished true
            ]
            if isFinished [
              set isSleeping false
              endTask currentUser nobody
            ]
          ]

          ;;;; Tâche faire la cuisine ou manger des restes
          ;;;; Cible = frigo
          if currentTaskAction = "get meal"[
            let toEat nobody
            let nextTask nobody
            let fridgeTmp nobody
            ask currentTask[
              set fridgeTmp other-end
            ]
            let isEatingLeftovers false
            ;;;;; Prendre depuis frigo
            ask fridgeTmp[
              ifelse mealQuantity > 0 [
                ;;;;;; Si restes dispo dans le frigo
                set isEatingLeftovers true
                ;;;;;;; Prendre le repas
                ask one-of my-containLinks with[is-dish? other-end][
                  ask other-end[
                    set toEat self
                    take currentUser self
                  ]
                ]
              ][
                ;;;;;; Sinon prendre ingrédients
                ;;;;;;; Prendre légume
                ask one-of my-containLinks with[is-vegetable? other-end][
                  ask other-end[
                    set toEat self
                    take currentUser self
                  ]
                ]
                ;;;;;;; Prendre viande
                ask one-of my-containLinks with[is-meat? other-end][
                  ask other-end[
                    set toEat self
                    take currentUser self
                  ]
                ]
              ]
            ]
            ;;;;; Définition prochaine tâche
            ;;;;;; Si l'utilisateur mange des restes
            ifelse isEatingLeftovers[
              ;;;;;;; Faut-il réchauffer ce repas ?
              let isEatableColdTmp false
              ask toEat [
                ask my-containLinks with[is-meal? other-end][
                  ask other-end[
                    set isEatableColdTmp isEatableCold
                  ]
                ]
              ]
              ifelse isEatableColdTmp[
                ;;;;;;; Si mangable froid, aller à table
                set nextTask createTask currentUser "put meal on table" one-of tables with[any?(chairs-on neighbors)] 1
              ][
                ;;;;;; Sinon réchauffer
                set nextTask createTask currentUser "warm up food" one-of microwaves 1
              ]
            ][
              ;;;;;; Sinon cuisiner
              set nextTask createTask currentUser "cook" one-of cupboards 1
            ]
            ;;;;; Passage à la tache suivante
            endTask currentUser nextTask
          ]

          ;;;; Tâche réchauffer restes
          ;;;; Cible = micro ondes
          if currentTaskAction = "warm up food"[
            let targetMicrowave nobody
            let targetMicrowavePatch nobody
            ask currentTask[
              set targetMicrowave other-end
            ]
            let isCurrentlyWarmingUp false
            ask targetMicrowave [
              set isCurrentlyWarmingUp isActive
              set targetMicrowavePatch patch-here
            ]

            ;;;;; Si micro-ondes pas encore activé
            if not isCurrentlyWarmingUp[
              ifelse any? my-carryLinks with[is-dish? other-end][
                let foodToWarmUp nobody
                ;;;;;; Si pas encore mis dans le micro-ondes
                ;;;;;;; Mettre dans le micro-ondes
                ask my-carryLinks with[is-dish? other-end][
                  set foodToWarmUp other-end
                ]
                put currentUser foodToWarmUp targetMicrowavePatch
                ;;;;;;; Allumer le micro-ondes
                ask targetMicrowave [
                  set isActive true
                  set timeLeft 60 * 3
                ]
              ][
                ;;;;;; Si fini
                ;;;;;; Prendre le repas et le mettre sur la table
                let mealToEat nobody
                ask targetMicrowave[
                  ask one-of my-containLinks with[is-dish? other-end][
                    set mealToEat other-end
                  ]
                ]
                take currentUser mealToEat
                let nextTask createTask currentUser "put meal on table" one-of tables with[any?(chairs-on neighbors)] 1
                endTask currentUser nextTask
              ]
            ]
          ]

          ;;;; Tâche préparer repas
          ;;;; Cible = Placard ou plaque
          if currentTaskAction = "cook"[
            let taskTarget nobody
            ask currentTask[
              set taskTarget other-end
            ]

            ;;;;; Si cible = Placard
            if is-cupboard? taskTarget[
              ;;;;; Prendre vaisselle
              let dishToTake nobody
              ask taskTarget[
                ask one-of my-containLinks with[is-dish? other-end][
                  set dishToTake other-end
                ]
              ]
              take currentUser dishToTake
              ;;;;; Prochaine étape : mettre sur la plaque
              let nextTask createTask currentUser "cook" one-of hotplates 1
              endTask currentUser nextTask
            ]

            ;;;;; Si cible = Plaque
            if is-hotplate? taskTarget[
              let isCooking false
              let createdMeal nobody
              ask taskTarget [set isCooking isActive]

              ;;;;;; Si pas en attente
              if not isCooking [
                ;;;;;; Calcul nutrition total des ingrédients et fusion
                let sumNutrition 0
                ask my-carryLinks with [is-vegetable? other-end or is-meat? other-end][
                  ask other-end[
                    set sumNutrition sumNutrition + nutrition
                    die
                  ]
                ]
                ;;;;;; Création repas
                let dishToPutMealIn one-of dishes-here with[not any?(my-containLinks)]
                ask patch-here[
                  sprout-meals 1[
                    set nutrition sumNutrition
                    if pcolor = 14.4 or pcolor = 44.4 or pcolor = 126.3[
                      set temperature temperaturePrincipalRooms
                    ]
                    if pcolor = 64.7[
                      set temperature temperatureEntrance
                    ]
                    if pcolor = 84.9[
                      set temperature temperatureBathroom
                    ]
                    set cookingTemperature random (82 - 63) + 63
                    set cookingState 0
                    set quantity 100
                    set isEatableCold false
                    set freshness 100
                    set size 0.5
                    set shape "food"
                    set color gray

                    set createdMeal self
                    ask dishToPutMealIn[
                      create-containLink-to createdMeal
                    ]
                  ]
                ]
                ;;;;;; Poser repas et allumer plaque
                ask taskTarget[
                  put currentUser dishToPutMealIn taskTarget
                  set IsActive true
                  set power 6
                  set timeleft 10 * 60 ; 10 minutes de cuisson
                ]
                ;;;;;; Allumer hotte
                if any?(hoods-on neighbors)[
                  ask one-of hoods-on neighbors[
                    set power 3
                    set IsActive true
                  ]
                ]
                if any?(hoods-here)[
                  ask one-of hoods-here[
                    set power 3
                    set IsActive true
                  ]
                ]
              ]
              ;;;;;; Prochaine étape : attendre la cuisson
              let nextTask createTask currentUser "cook" createdMeal 1
              endTask currentUser nextTask
            ]

            ;;;;; Si cible = repas
            if is-meal? taskTarget[
              ;;;;;; Surveiller cuisson
              let isFinished false
              ask taskTarget[
                if cookingState >= 100[
                  set isFinished true
                ]
              ]
              if isFinished[
                ;;;;;; Si cuisson finie, éteindre la plaque et hotte et prendre le repas
                let dishOfMeal nobody
                ask taskTarget[
                  ask hotplates-here[
                    set IsActive false
                  ]
                  ask hoods-here[
                    set IsActive false
                  ]
                  ask one-of my-in-containLinks with[is-dish? other-end][
                    set dishOfMeal other-end
                  ]
                ]
                take currentUser dishOfMeal
                ;;;;;; Prochaine étape : mettre le repas sur la table
                let nextTask createTask currentUser "put meal on table" one-of tables with [any?(chairs-on neighbors)] 1
                endTask currentUser nextTask
              ]
            ]
          ]

          ;;;; Tâche prendre une douche
          if currentTaskAction = "take shower"[
            let taskTarget nobody
            let isFinished false

            ;;;;; Monte dans la douche si n'est pas déjà dedans
            let taskTargetPatch nobody
            ask currentTask[
              set taskTarget other-end
              ask other-end[
                set taskTargetPatch patch-here
              ]
            ]
            if patch-here != taskTargetPatch[
              move-to taskTargetPatch
            ]
            ;;;;; Allume la douche si pas déjà activée
            ask showers-here[
              if not isActive[
                set showerThermostat 38
                set isActive true
              ]
            ]

            ;;;;; Fini au bout de 15 minutes
            ask currentTask[
              if time > (60 * 15)[
                set isFinished true
              ]
            ]
            if isFinished[
              ;;;;; Si fini, éteindre douche
              ask showers-here[
                if isActive[
                  set isActive false
                ]
              ]
              endTask currentUser nobody
            ]
          ]

          ;;;; Tâche sortir dehors
          ;;;; Cible = porte d'entrée
          if currentTaskAction = "go outside"[
            ;;;;; Eteint les lumières de l'entrée
            ask lights with[pcolor = 64.7 and isActive][
              set isActive false
            ]
            set isOutside true
          ]

          ;;;; Tâche sortir faire les courses
          ;;;; Cible = porte d'entrée
          if currentTaskAction = "go to store"[
            ;;;;; Eteint les lumières de l'entrée
            ask lights with[pcolor = 64.7 and isActive][
              set isActive false
            ]
            set isOutside true
          ]

          ;;;; Tâche ranger les courses
          ;;;; Cible = frigo
          if currentTaskAction = "store groceries"[
            let taskTargetPatch nobody
            ask currentTask[
              ask other-end[
                set taskTargetPatch patch-here
              ]
            ]
            ask fruits-here[
              put currentUser self taskTargetPatch
            ]
            ask vegetables-here[
              put currentUser self taskTargetPatch
            ]
            ask meats-here[
              put currentUser self taskTargetPatch
            ]
            endTask currentUser nobody
          ]

          ;;;; Tâche allumer l'appareil
          ;;;; Cible = peu importe tant qu'il peut être activé
          if currentTaskAction = "turn on"[
            let taskTargetPatch nobody
            ask currentTask[
              ask other-end[
                set taskTargetPatch patch-here
                set isActive true
              ]
            ]
            endTask currentUser nobody
          ]

          ;;;; Tâche lire un livre
          ;;;; Cible = bibliothèque OU chaise OU lit
          if currentTaskAction = "read book"[
            let taskTarget nobody
            ask currentTask[
              set taskTarget other-end
            ]

            ;;;;; Si cible = bibliothèque
            if is-bookshelf? taskTarget[
              ;;;;;; Prendre un livre et aller s'assoir sur une chaise ou un lit
              let bookToTake nobody
              ask taskTarget[
                ask one-of my-containLinks with[is-book? other-end][
                  set bookToTake other-end
                ]
              ]
              take currentUser bookToTake

              let thingToSitTo min-one-of chairs [distance myself]
              let distanceToChair distance thingToSitTo

              if distanceToChair > distance min-one-of beds [distance myself][
                set thingToSitTo min-one-of beds [distance myself]
              ]

              let nextTask createTask currentUser "read book" thingToSitTo 1
              endTask currentUser nextTask
            ]

            ;;;;; Si cible = chaise ou lit
            if is-chair? taskTarget or is-bed? taskTarget[
              ;;;;;; S'assoit si pas encore dessus
              let taskTargetPatch nobody
              ask taskTarget[
               set taskTargetPatch patch-here
              ]
              if taskTargetPatch != patch-here[
               move-to taskTargetPatch
              ]

              ;;;;;; Lire le livre (ne fait rien quoi) si pas d'autre tâche
              ;;;;;; Remettre le livre dès qu'il y a une nouvelle tâche
              if any?(my-taskLinks with[action != "read book"])[
                let nextTask createTask currentUser "put" one-of bookshelfs 1
                endTask currentUser nextTask
              ]
            ]
          ]

          ;;;; Tâche prendre un café
          ;;;; Cible = cafetière
          if currentTaskAction = "take coffee"[
            let taskTarget nobody
            let isDishOnCoffeeMaker false
            ask currentTask[
              set taskTarget other-end
              ;;;;; Vérifie si il y a un dish dans la cafetière
              if any?([my-containLinks with[is-dish? other-end]] of other-end)[
                set isDishOnCoffeeMaker true
              ]
            ]

            ifelse isDishOnCoffeeMaker[
              ;;;;; Si dish sur cafetière
              ;;;;;; Vérification si café prêt
              let isCoffeeReady false
              ask taskTarget[
                if coffeeCapacity > 100 / 25 and coffeeTemperature > 70[
                  set isCoffeeReady true
                ]
              ]

              ;;;;;; Si café prêt, se servir le café puis le prendre et aller le boire
              ifelse isCoffeeReady[
                let isCoffeePoured false
                ;;;;;;; Versement du café dans le dish
                ask taskTarget[
                  let coffeeMakerWaterTemperature coffeeTemperature
                  ask my-containLinks with[is-dish? other-end][
                    ask other-end[
                      ifelse any?(my-containLinks with[is-coffee? other-end])[
                        ;;;;;;;; Si café déjà présent, augmenter quantity
                        ask my-containLinks with[is-coffee? other-end][
                          ask other-end[
                            set quantity quantity + 100 / 5
                            ;;;;;;;;; Fin si café 100%
                            if quantity >= 100[
                              set quantity 100
                              set isCoffeePoured true
                            ]
                            if temperature < coffeeMakerWaterTemperature[
                              set temperature coffeeMakerWaterTemperature
                            ]
                          ]
                        ]
                      ][
                        ;;;;;;;; Sinon créer café
                        ask patch-here[
                          sprout-coffees 1[
                            set shape "drop"
                            set color brown
                            set size 0.4
                            set quantity 100 / 5
                            set temperature coffeeMakerWaterTemperature
                          ]
                        ]
                        set cleanliness 0
                        create-containLinks-to coffees-here
                      ]
                    ]
                  ]
                  set coffeeCapacity coffeeCapacity - 100 / (5 * 5) ;;;;;;; Une cafetière = 5 tasses
                ]
                ;;;;;;; Aller boire le café une fois versé
                if isCoffeePoured[
                  let dishToTake nobody
                  let coffeeToDrink nobody
                  ask taskTarget[
                    ask my-containLinks with[is-dish? other-end][
                      ask other-end[
                        set dishToTake self
                        ask my-containLinks with[is-coffee? other-end][
                          ask other-end[
                            set coffeeToDrink self
                          ]
                        ]
                      ]
                    ]
                  ]
                  let nextTask createTask currentUser "take" dishToTake 1
                  endTask currentUser nextTask
                  set nextTask createTask currentUser "drink coffee" coffeeToDrink 1
                ]
              ][
                ;;;;;; Allume la cafetière si café pas prêt et cafetière pas encore allumée
                ask taskTarget[
                  if not isActive[
                    set isActive true
                  ]
                  ;;;;;;; Remplit avec de l'eau si niveau faible
                  if waterCapacity <= 15[
                   set waterCapacity 100
                  ]
                ]
              ]
            ][
              ;;;;; Va chercher un dish propre et vide si il n'en a pas
              ifelse not any?(my-carryLinks with[is-dish? other-end and [cleanliness] of other-end = 100 and not any?([my-containLinks] of other-end)])[
                let nextTask createTask currentUser "take" one-of dishes with[cleanliness = 100] 1
                endTask currentUser nextTask
                set nextTask createTask currentUser "take coffee" taskTarget 1
              ][
                ;;;;; Si tient un dish propre et vide, le mettre dans la cafetière
                let thingToPut nobody
                ask my-carryLinks with[is-dish? other-end and [cleanliness] of other-end = 100 and not any?([my-containLinks] of other-end)][
                  set thingToPut other-end
                ]
                let taskTargetPatch nobody
                ask taskTarget[
                  set taskTargetPatch patch-here
                ]
                put currentUser thingToPut taskTargetPatch
              ]
            ]
          ]

          ;;;; Tâche boire café
          ;;;; Cible = café
          if currentTaskAction = "drink coffee"[
            let taskTarget nobody
            ask currentTask[
              set taskTarget other-end
            ]

            ;;;;; Si pas assis
            ifelse not any?(chairs-here)[
              ;;;;;; Va s'assoir
              let nextTask createTask currentUser "sit" one-of chairs 1
              endTask currentUser nextTask
              set nextTask createTask currentUser "drink coffee" taskTarget 1
            ][
              ;;;;; Si assis
              let dishOfCoffee nobody
              let isFinished false
              ask taskTarget[
                ifelse quantity <= 0[
                  set quantity 0
                  set isFinished true
                  ask my-in-containLinks[
                    set dishOfCoffee other-end
                  ]
                  die
                ][
                  ;;;;;; Bois le café si il en reste
                  set quantity quantity - (100 / (60 * 3))
                  ask currentUser[
                    set sleep sleep + (10 / (60 * 3))
                  ]
                ]
              ]
              if isFinished[
                ;;;;;; Va mettre le dish au lave vaisselle si fini
                let nextTask createTask currentUser "put" one-of dishwashers 1
                endTask currentUser nextTask
              ]
            ]
          ]

          ;;;; TODO Implémenter actions des tâches ici

        ] ;;; FIN Définition tâches
      ]

      ;; Vérification si l'utilisateur dort
      if currentTask != nobody[
        let isOnBed false
        if any?(beds-here)[set isOnBed true]
        let isTaskSleeping false
        ask currentTask[
          if action = "sleep" and isOnBed[
            set isTaskSleeping true
          ]
        ]
        if isOnBed and isTaskSleeping[set isSleeping true]
      ]
      ifelse isSleeping[
        set label "zzz"
      ][
        set label ""
      ]

      ;;; Lumière
      ;;;; Salle de bain
      ifelse pcolor = 84.9 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 84.9]))[
        if luminosityBathroom = 0[
          ask lights with[pcolor = 84.9 or (pcolor = 23.3 and any?(neighbors with[pcolor = 84.9]))]
          [
            set isActive true
          ]
        ]
      ][
        ask lights with[pcolor = 84.9 or (pcolor = 23.3 and any?(neighbors with[pcolor = 84.9]))]
        [
          set isActive false
        ]
      ]
      ;;;; Entrée
      ifelse pcolor = 64.7 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 64.7]))[
        ifelse luminosityEntrance = 0[
          ask lights with[pcolor = 64.7 or (pcolor = 23.3 and any?(neighbors with[pcolor = 64.7]))]
          [
            set isActive true
          ]
        ][
          ;;;;; Si il fait clair, éteindre les lumières
          if luminosityEntrance = luminosityOutside[
            ask lights with[pcolor = 64.7 or (pcolor = 23.3 and any?(neighbors with[pcolor = 64.7])) and isActive][
              set isActive false
            ]
          ]
        ]
      ][
        ask lights with[pcolor = 64.7 or (pcolor = 23.3 and any?(neighbors with[pcolor = 64.7]))]
        [
          set isActive false
        ]
      ]

      ;;;; Chambre
      ifelse pcolor = 126.3 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 126.3])) and not isSleeping[
        ifelse luminosityPrincipalRooms = 0[
          ask lights with[pcolor = 126.3 or (pcolor = 23.3 and any?(neighbors with[pcolor = 126.3])) and not isActive][
            set isActive true
          ]
        ][
          ;;;;; Si il fait clair, éteindre les lumières
          if luminosityPrincipalRooms = luminosityOutside[
            ask lights with[pcolor = 126.3 or (pcolor = 23.3 and any?(neighbors with[pcolor = 126.3])) and isActive][
              set isActive false
            ]
          ]
        ]
      ][
        ask lights with[pcolor = 126.3 or (pcolor = 23.3 and any?(neighbors with[pcolor = 126.3])) and isActive][
          set isActive false
        ]
      ]

      ;;;; SàM
      ifelse pcolor = 14.4 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 14.4]))[
        ifelse luminosityPrincipalRooms = 0[
          ask lights with[pcolor = 14.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 14.4]))]
          [
            set isActive true
          ]
        ][
          ;;;;; Si il fait clair, éteindre les lumières
          if luminosityPrincipalRooms = luminosityOutside[
            ask lights with[pcolor = 14.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 14.4])) and isActive][
              set isActive false
            ]
          ]
        ]
      ][
        ask lights with[pcolor = 14.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 14.4]))]
        [
          set isActive false
        ]
      ]
      ;;;; Cuisine
      ifelse pcolor = 44.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 44.4]))[
        ifelse luminosityPrincipalRooms = 0[
          ask lights with[pcolor = 44.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 44.4]))]
          [
            set isActive true
          ]
        ][
          ;;;;; Si il fait clair, éteindre les lumières
          if luminosityPrincipalRooms = luminosityOutside[
            ask lights with[pcolor = 44.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 44.4])) and isActive][
              set isActive false
            ]
          ]
        ]
      ][
        ask lights with[pcolor = 44.4 or (pcolor = 23.3 and any?(neighbors with[pcolor = 44.4]))]
        [
          set isActive false
        ]
      ]

    ] ;;; FIN Si à la maison

    ;;; Incrémentation temps tâche
    if currentTask != nobody[
      ask currentTask [set time time + 1]
    ]

    ;;; Création de tâches
    ;;;; Routine
    if nextRoutineIndex >= 0[
      if hour = (read-from-string substring (item nextRoutineIndex RoutineTimes) 0 2) and minute = (read-from-string substring (item nextRoutineIndex RoutineTimes) 3 5)[ ;;; Si heure de la routine
        ;;;;; Réveil
        if item nextRoutineIndex RoutineActions = "wake up"[
          ;;;;;; Si dors actuellement, se réveiller
          set isSleeping false
          if currentTask != nobody[
            ask currentTask[
              if action = "sleep"[
                endTask currentUser nobody
              ]
            ]
          ]
          ;;;;;; Annulation sleep
          ask my-taskLinks with [action = "sleep"][
            die
          ]
        ]

        ;;;;; Aller au lit
        if item nextRoutineIndex RoutineActions = "sleep" and not any?(my-taskLinks with [action = "sleep"])[
          let nextTask createTask currentUser "sleep" one-of beds 1
        ]

        ;;;;; Petit déjeuner
        if item nextRoutineIndex RoutineActions = "breakfast" and not any?(my-taskLinks with [action = "get something to eat" or action = "get meal" or action = "eat fruit"])[
          let nextTask createTask currentUser "eat fruit" one-of fruits 4
        ]

        ;;;;; Déjeuner/Diner
        if (item nextRoutineIndex RoutineActions = "lunch" or item nextRoutineIndex RoutineActions = "diner") and not any?(my-taskLinks with [action = "get something to eat" or action = "eat on table"])[
          let nextTask createTask currentUser "get meal" one-of fridges 4
        ]

        ;;;;; Prendre une douche
        if item nextRoutineIndex RoutineActions = "shower" and not any?(my-taskLinks with [action = "take shower"])[
          let nextTask createTask currentUser "take shower" one-of showers 4
        ]

        ;;;;; Aller dehors
        if item nextRoutineIndex RoutineActions = "go outside" and not any?(my-taskLinks with [action = "go outside"]) and not isOutside[
          let entranceDoor one-of doors with[xcor = 0 or ycor = 0]
          let nextTask createTask currentUser "go outside" entranceDoor 4
        ]

        ;;;;; Faire les courses
        if item nextRoutineIndex RoutineActions = "go to store" and not any?(my-taskLinks with [action = "go to store"]) and not isOutside[
          let entranceDoor one-of doors with[xcor = 0 or ycor = 0]
          let nextTask createTask currentUser "go to store" entranceDoor 4
        ]

        ;;;;; Rentrer à la maison
        if item nextRoutineIndex RoutineActions = "go back home" and isOutside and not any?(my-taskLinks with [action = "go to store"])[
          if isOutside[
            set isOutside false
          ]
          if currentTask != nobody[
            ask currentTask[
              if action = "go outside"[
                endTask currentUser nobody
              ]
            ]
          ]
          ;;;;;; Annulation sortie
          ask my-taskLinks with [action = "go outside"][
            die
          ]
        ]

        ;;;;; Lire livre
        if item nextRoutineIndex RoutineActions = "read book" and not any?(my-taskLinks with[action = "read book"]) and not isSleeping[
          let nextTask createTask currentUser "read book" one-of bookshelfs with[bookQuantity > 0] 4
        ]

        ;;;; Prendre un café
        if item nextRoutineIndex RoutineActions = "take coffee" and not any?(my-taskLinks with[action = "take coffee"])[
          let nextTask createTask currentUser "take coffee" one-of coffeeMakers 4
        ]

        ;;;;; TODO Ajouter prochaines actions routines ici (comme dans fichier)

        ;;;;; Récupération prochaine routine
        set nextRoutineIndex nextRoutineIndex - 1
      ]
    ]

    ;;;; Besoins dynamiques
    ;;;;; Si a faim, va chercher un casse croute
    if hunger < 10 and not any?(my-taskLinks)[
      let task createTask currentUser "get something to eat" one-of fridges with[any?(my-containLinks with[is-fruit? other-end])] 3
    ]

    ;;;;; Si fatigué et pas bientôt l'heure de se coucher, va faire une sieste
    if nextRoutineIndex != -1[
      if sleep < 10 and not any?(my-taskLinks with [action = "sleep" or action = "rest"]) and item nextRoutineIndex routineActions != "sleep"[
        let task createTask currentUser "rest" one-of beds 3
      ]
    ]

    ;;;;; Si frigo presque vide, aller faire les courses
    let isGroceriesNeed false
    ask fridges[
     if vegetablesQuantity <= 1 or fruitsQuantity <= 1 or meatQuantity <= 1[
       set isGroceriesNeed true
      ]
    ]
    if isGroceriesNeed and not any?(my-taskLinks)[
      let entranceDoor one-of doors with[xcor = 0 or ycor = 0]
      let task createTask currentUser "go to store" entranceDoor 3
    ]

    ;;;;; Si placard presque vide, allumer le lave-vaisselle si necessaire (contient au moins une vaisselle sale et pas de vaisselle propre)

    let isDishesNeed false
    ask cupboards[
      if dishesQuantity <= 3[
        set isDishesNeed true
      ]
    ]
    if isDishesNeed and not any?(my-taskLinks)[
      let task createTask currentUser "turn on" one-of dishwashers with [isActive = false and not any?(my-containLinks with[is-dish? other-end and [cleanliness] of other-end = 100]) and any?(my-containLinks with[is-dish? other-end and [cleanliness] of other-end = 0])] 4
    ]

    ;;;;; Si lave vaisselle fini de laver, ranger la vaisselle propre et mettre la vaisselle sale
    let isDishwasherFinished false
    ask dishwashers with [isActive = false and any?(my-containLinks with [is-dish? other-end])][
      ask my-containLinks with [is-dish? other-end][
        ask other-end[
         if cleanliness = 100[
           set isDishwasherFinished true
          ]
        ]
      ]
    ]
    if isDishwasherFinished and not any?(my-taskLinks)[
      ask dishes with [cleanliness = 100 and any?(my-in-containLinks with[is-dishwasher? other-end])][
        let task createTask currentUser "take" self 1
        set task createTask currentUser "put" one-of cupboards 2
      ]
      ask dishes with [cleanliness = 0 and not any?(my-in-containLinks with[is-dishwasher? other-end])][
        let task createTask currentUser "take" self 1
        set task createTask currentUser "put" one-of dishwashers with [isActive = false] 2
      ]
    ]

    ;;;;; TODO gestion Linge


    ;;; Dégradation besoins
    ;;;; Faim (100 à 0 en 18h)
    if hunger > 0[
      set hunger hunger - ( 100 / (60 * 60 * 18))
    ]
    if hunger < 0[
      set hunger 0
    ]

    ;;;; Sommeil (100 à 0 en 16h)
    if not isSleeping[
      if sleep > 0[
        set sleep sleep - ( 100 / (60 * 60 * 18))
      ]
      if sleep < 0[
        set sleep 0
      ]
    ]

    ;;;; Propreté
    ;;;; TODO



  ]
end

; Comportement objets et meubles TODO
to objectsBehaviour
  ;; Comportement CarryLink
  ask turtles with[any?(my-in-carryLinks)][
    let carryBy nobody
    ask my-in-carryLinks[
      set carryBy other-end
    ]
    move-to carryBy
  ]

  ;; Comportement ContainLink (similaire à carry)
  ask turtles with[any?(my-in-containLinks)][
    let containedBy nobody
    ask my-in-containLinks[
      set containedBy other-end
    ]
    move-to containedBy
  ]

  ;; Comportement plaque chauffante
  ask hotplates[
    ifelse isActive[
      if color != red[set color red]
      ;;; chauffe des repas
      ask meals-here[
        set temperature temperature + ( 100 / ( 5 * 60 ))
        if temperature > cookingTemperature[
          set cookingState cookingState + ( 100 / ( 5 * 60 ))
        ]
      ]
    ][
      if color != black[set color black]
    ]
  ]

  ;; Comportement micro-ondes
  ask microwaves with[isActive][
    ;;; Chauffe repas
    ask my-containLinks with[is-dish? other-end][
      ask other-end[
        ask my-containLinks with[is-meal? other-end][
          ask other-end[
            set temperature temperature + (200 / (60 * 3))
          ]
        ]
      ]
    ]
    set timeleft timeleft - 1
    if timeleft <= 0 [
      set timeleft 0
      set isActive false
    ]
  ]

  ;; Comportement lave-vaisselle
  ;; TODO Revoir système de cycles
  ask dishwashers[
    ifelse any?(my-containLinks with[is-dish? other-end])[
      let dirtlevels []
      ask my-containLinks with[is-dish? other-end][
        ask other-end[
          set dirtlevels insert-item 0 dirtlevels (100 - cleanliness)
        ]
      ]
      set dirtlevel mean dirtlevels
    ][
      set dirtLevel 0
    ]



    ;;; Fonctionnement
    ifelse isActive[

      ;;;; Si allumé
      if timeleft = 0[
        set cyclemode "fill"
        set timeleft ( 3 * 60 * 60 )
      ]


      ;;;; Cycles
      ifelse cyclemode = "fill"[
        if waterLevel < 100[
          set waterLevel waterLevel + ( 100 / (60 * 15 ) ) ;;;;; 15 minutes pour remplir
        ]
        ifelse waterTemperature < 65 [
          set waterTemperature waterTemperature + ( 100 / ( 60 * 5 ) ) ;;;;; L'eau est chauffée en 5 minutes
        ][
          ;;;;; Nettoyage
          if waterLevel > 90 and waterTemperature >= 60[
            ask my-containLinks with [is-dish? other-end][
              ask other-end[
                set cleanliness cleanliness + (100 / 60 * 30)
                if cleanliness > 100 [set cleanliness 100]
              ]
            ]
          ]
          if timeleft < ( 2 * 60 * 60 )[
            set cyclemode "rinse"
          ]
        ]
      ][
        if cyclemode = "rinse"[
          if timeleft < (60 * 60 )[
            set cyclemode "dry"
          ]
        ]
      ]
      set timeleft timeleft - 1

      ;;;; Fin du programme
      if timeleft <= 0[
        set timeleft 0
        set isActive false
      ]
    ][
      ;;;; Gestion température eau
      ifelse waterTemperature >= temperaturePrincipalRooms[
        set waterTemperature waterTemperature - ((waterTemperature - temperaturePrincipalRooms) * 100 / (60 * 60 * 2 ) ) ;;;;; 2h pour refroidir
      ][
        set waterTemperature waterTemperature + ((temperaturePrincipalRooms - waterTemperature) * 100 / (60 * 60 * 2 ) )
      ]
    ]
  ]

  ;; Comportement machine à café
  ask coffeeMakers[
    ;;; Gestion température café/eau
    ifelse coffeeTemperature >= temperaturePrincipalRooms[
      set coffeeTemperature coffeeTemperature - ((coffeeTemperature - temperaturePrincipalRooms) / (60 * 60))
    ][
      set coffeeTemperature coffeeTemperature + ((temperaturePrincipalRooms - coffeeTemperature) / (60 * 60))
    ]

    if isActive[
      let isFinished false

      ifelse coffeeTemperature < 90[
        ;;; Chauffer café
        set coffeeTemperature coffeeTemperature + 100 / 15
      ][
        ;;; Remplissage cafetière
        ifelse coffeeCapacity < 20[
          ifelse waterCapacity > 0[
            set waterCapacity waterCapacity - 100 / 60
            if waterCapacity < 0 [set waterCapacity 0]
            set coffeeCapacity coffeeCapacity + 100 / 60
            if coffeeCapacity > 100 [set coffeeCapacity 100]
          ][
            set isFinished true
          ]
        ][
          set isFinished true
        ]
      ]
      ;;; Extinction une fois fini
      if isFinished[
        set isActive false
      ]
    ]
  ]

  ;; Comportement douche
  ask showers[
    ;;; Gestion temperature eau
    ifelse waterTemperature >= temperatureBathroom[
      set waterTemperature waterTemperature - ( (waterTemperature - temperatureBathroom) / ( 60 * 60 ))
    ][
      set waterTemperature waterTemperature + ( (temperatureBathroom - waterTemperature) / ( 60 * 60 ))
    ]

    ;;; Si actif
    ifelse isActive[
      set debit 100

      ;;;; Thermostat
      if waterTemperature <= showerThermostat[
        set waterTemperature waterTemperature + ( thermostat / 20 )
      ]


      ;;;; Nettoyage de l'utilisateur sous la douche
      if waterTemperature > showerThermostat[
        ask users-here[
          if cleanliness < 100[
            set cleanliness cleanliness + (100 / (60 * 15))
          ]
          if cleanliness > 100[
            set cleanliness 100
          ]
        ]
      ]
    ][
      set debit 0
    ]
  ]

  ;; Comportement lampes
  ask lights[
    ifelse isActive[
      set shape "triangle"
    ][
      set shape "triangle 2"
    ]
  ]

  ;; Comportement repas
  ask meals[
    ;;; Vérification si dans frigo
    let isInFridge false
    let temperatureFridge 0
    if any? my-in-containLinks with[is-dish? other-end][
      ask one-of my-in-containLinks with[is-dish? other-end][
        ask other-end[ ;;;; Dish
          if any? my-in-containLinks with[is-fridge? other-end][
            ask one-of my-in-containLinks with[is-fridge? other-end][ ;;;; Fridge
              ask other-end[
                if isActive[
                  set isInFridge true
                  set temperatureFridge temperature
                ]
              ]
            ]
          ]
        ]
      ]
    ]
    ifelse isInFridge[
      ;;; Si dans frigo
      ask my-in-containLinks with[is-fridge? other-end][
       ask other-end[
          set temperatureFridge temperature
        ]
      ]
      ;;; une demi-heure pour refroidir à température frigo
      if temperature > temperatureFridge[
        set temperature temperature - ( (temperature - temperatureFridge) / (60 * 30))
      ]
      if temperature < temperatureFridge[
        set temperature temperature + ((temperatureFridge - temperature) / (60 * 30))
      ]
    ][
      ;;; Si pas dans frigo
      ;;; 3h pour refroidir à température pièce
      ;;;; Salle de bain
      ifelse pcolor = 84.9 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 84.9]))[
        if temperature > temperatureBathroom[
          set temperature temperature - ( temperatureBathroom * temperature / (60 * 60 * 3))
        ]
        if temperature < temperatureBathroom[
          set temperature temperature + ( temperatureBathroom * temperature / (60 * 60 * 3))
        ]
      ][
        ;;;; Entrée
        ifelse pcolor = 64.7 or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 64.7]))[
          if temperature > temperatureEntrance[
            set temperature temperature - ( temperatureEntrance * temperature / (60 * 60 * 3))
          ]
          if temperature < temperatureEntrance[
            set temperature temperature + ( temperatureEntrance * temperature / (60 * 60 * 3))
          ]
        ][
          ;;;; Pièce principale
          if (pcolor = 126.3 or pcolor = 14.4 or pcolor = 44.4 ) or ((pcolor = 23.3 or pcolor = 6.3) and any?(neighbors with[pcolor = 84.9]))[
            if temperature > temperaturePrincipalRooms[
              set temperature temperature - ( temperaturePrincipalRooms * temperature / (60 * 60 * 3))
            ]
            if temperature < temperaturePrincipalRooms[
              set temperature temperature + ( temperaturePrincipalRooms * temperature / (60 * 60 * 3))
            ]
          ]
        ]
      ]
    ]
  ]

  ;; Comportement café
  ask coffees[
    ;;; TODO Gestion température café
  ]

  ;; Mise à jour quantités frigo
  ask fridges[
    set fruitsQuantity count my-containLinks with[is-fruit? other-end]
    set vegetablesQuantity count my-containLinks with[is-vegetable? other-end]
    set meatQuantity count my-containLinks with[is-meat? other-end]
    let countMeals 0
    ask my-containLinks with[is-dish? other-end][
      ask other-end[
        ask my-containLinks with[is-meal? other-end][
          set countMeals countMeals + 1
        ]
      ]
    ]
    set mealQuantity countMeals
  ]

  ;; Mise à jour quantités placard
  ask cupboards[
    set dishesQuantity count my-containLinks with[is-dish? other-end]
  ]


end

; TODO Comportement Capteurs
to sensorBehaviour

end

; TODO Ecriture des données
to writeData

end

; Fonction GO
to go
  ;; Gestion nouvelle journée
  if hour = 0 and minute = 0 and second = 0 [
    newDay
  ]

  ;; Appel gestion de la lumière
  lightManagement

  ;; Appel Gestion de la température extérieure
  temperatureOutsideManagement

  ;; Appel gestion du thermostat
  thermostatManagement

  ;; Appel gestion de la température intérieure
  insideTemperatureManagement

  ;; Gestion de la saleté
  dirtManagement

  ;; Appel comportement Roomba
  roombaBehaviour

  ;; Appel comportement station Roomba
  roombaStationBehaviour

  ;; TODO Comportement Utilisateur
  userBehaviour

  ;; TODO Comportement Objets
  objectsBehaviour

  ;; TODO Comportement Capteurs
  sensorBehaviour

  ;; TODO Ecriture des données
  writeData

  ;;1 tick = 1 seconde
  incrementOneSecond
  tick
end
; FIN GO
@#$#@#$#@
GRAPHICS-WINDOW
1065
19
1847
501
-1
-1
43.0
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
22
13
85
46
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

MONITOR
1372
522
1429
567
Jour
day
0
1
11

MONITOR
1372
571
1429
616
Heure
hour
0
1
11

MONITOR
1439
521
1496
566
Mois
month
0
1
11

MONITOR
1504
521
1561
566
Année
year
17
1
11

MONITOR
1439
572
1496
617
Minutes
minute
17
1
11

MONITOR
1503
572
1569
617
Secondes
second
17
1
11

MONITOR
1157
22
1242
67
Température
temperatureBathroom
17
1
11

MONITOR
1067
454
1152
499
Température
temperatureEntrance
17
1
11

MONITOR
1526
25
1616
70
Température
temperaturePrincipalRooms
17
1
11

MONITOR
916
62
1058
107
Température Extérieur
temperatureOutside
17
1
11

TEXTBOX
350
256
500
274
Températures
11
0.0
1

SLIDER
13
290
136
323
minTemperatureWinter
minTemperatureWinter
-50
maxTemperatureWinter
-14.0
1
1
°C
HORIZONTAL

TEXTBOX
332
296
482
314
Hiver
11
85.0
1

SLIDER
142
290
268
323
maxTemperatureWinter
maxTemperatureWinter
minTemperatureWinter
50
18.0
1
1
°C
HORIZONTAL

TEXTBOX
331
335
481
353
Printemps
11
65.0
1

SLIDER
156
327
304
360
maxTemperatureSpring
maxTemperatureSpring
minTemperatureSpring
50
23.0
1
1
°C
HORIZONTAL

SLIDER
12
327
145
360
minTemperatureSpring
minTemperatureSpring
-50
maxTemperatureSpring
11.0
1
1
°C
HORIZONTAL

TEXTBOX
336
375
486
393
Eté
11
45.0
1

SLIDER
26
369
149
402
minTemperatureSummer
minTemperatureSummer
-50
maxTemperatureSummer
14.0
1
1
°C
HORIZONTAL

SLIDER
172
371
294
404
maxTemperatureSummer
maxTemperatureSummer
minTemperatureSummer
50
29.0
1
1
°C
HORIZONTAL

SLIDER
20
410
162
443
minTemperatureFall
minTemperatureFall
-50
maxTemperatureFall
6.0
1
1
°C
HORIZONTAL

SLIDER
176
409
323
442
maxTemperatureFall
maxTemperatureFall
minTemperatureFall
50
16.0
1
1
°C
HORIZONTAL

TEXTBOX
335
417
485
435
Automne
11
24.0
1

MONITOR
1608
544
1720
589
Saison
season
17
1
11

MONITOR
929
118
1054
163
Luminosité extérieur
luminosityOutside
17
1
11

MONITOR
1244
21
1311
66
Luminosité
luminosityBathroom
17
1
11

MONITOR
1244
453
1305
498
Luminosité
luminosityEntrance
17
1
11

MONITOR
1616
25
1687
70
Luminosité
luminosityPrincipalRooms
17
1
11

SLIDER
37
148
209
181
outsideMaxLuminosity
outsideMaxLuminosity
0
20000
20000.0
1
1
NIL
HORIZONTAL

MONITOR
16
190
141
235
Heure lever du soleil
sunriseHour
17
1
11

MONITOR
193
189
334
234
Heure coucher du soleil
sunsetHour
17
1
11

TEXTBOX
94
120
244
138
Luminosité
11
0.0
1

TEXTBOX
83
496
233
514
Utilisateur
11
0.0
1

CHOOSER
11
519
149
564
TypeHandicap
TypeHandicap
"Aucun"
0

BUTTON
106
14
169
47
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
455
290
627
323
minTemperatureHour
minTemperatureHour
0
maxTemperatureHour
3.0
1
1
h
HORIZONTAL

SLIDER
458
337
630
370
maxTemperatureHour
maxTemperatureHour
minTemperatureHour
23
16.0
1
1
h
HORIZONTAL

SLIDER
457
410
629
443
isolation
isolation
1
100000
49045.0
1
1
NIL
HORIZONTAL

TEXTBOX
493
388
643
406
Qualité de l'isolation
11
0.0
1

TEXTBOX
738
258
888
276
Puissances Chauffage/Clim
11
0.0
1

SLIDER
711
287
883
320
heaterPower
heaterPower
0
4000
1507.0
1
1
W
HORIZONTAL

SLIDER
712
330
884
363
ACPower
ACPower
0
4000
3338.0
1
1
W
HORIZONTAL

SLIDER
709
407
881
440
thermostat
thermostat
10
30
20.0
1
1
°C
HORIZONTAL

MONITOR
1113
408
1196
453
Saleté
dirtEntrance
17
1
11

MONITOR
1071
127
1128
172
Saleté
dirtBathroom
17
1
11

MONITOR
1377
26
1460
71
Saleté
dirtBedroom
17
1
11

MONITOR
1561
454
1618
499
Saleté
dirtDiningRoom
17
1
11

MONITOR
1745
23
1819
68
Saleté
dirtKitchen
17
1
11

TEXTBOX
642
81
792
99
Roomba
11
0.0
1

SLIDER
611
118
783
151
lowBattery
lowBattery
1
99
11.0
1
1
%
HORIZONTAL

SLIDER
46
643
218
676
nutritionFruitMin
nutritionFruitMin
1
nutritionFruitMax
15.0
1
1
NIL
HORIZONTAL

SLIDER
255
643
427
676
nutritionFruitMax
nutritionFruitMax
nutritionFruitMin
100
25.0
1
1
NIL
HORIZONTAL

SLIDER
43
696
215
729
nutritionVegetableMin
nutritionVegetableMin
0
nutritionVegetableMax
18.0
1
1
NIL
HORIZONTAL

SLIDER
254
696
428
729
nutritionVegetableMax
nutritionVegetableMax
nutritionVegetableMin
100
36.0
1
1
NIL
HORIZONTAL

SLIDER
50
745
222
778
nutritionMeatMin
nutritionMeatMin
0
100
38.0
1
1
NIL
HORIZONTAL

SLIDER
273
742
445
775
nutritionMeatMax
nutritionMeatMax
nutritionMeatMin
100
50.0
1
1
NIL
HORIZONTAL

MONITOR
1298
522
1362
567
NIL
weekDay
17
1
11

TEXTBOX
568
86
718
104
NIL
11
0.0
1

BUTTON
105
58
168
91
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
172
509
462
554
NIL
routineTimes
17
1
11

MONITOR
171
557
582
602
NIL
routineActions
17
1
11

MONITOR
465
509
578
554
NIL
nextRoutineIndex
17
1
11

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

apple
false
0
Polygon -7500403 true true 33 58 0 150 30 240 105 285 135 285 150 270 165 285 195 285 255 255 300 150 268 62 226 43 194 36 148 32 105 35
Line -16777216 false 106 55 151 62
Line -16777216 false 157 62 209 57
Polygon -6459832 true false 152 62 158 62 160 46 156 30 147 18 132 26 142 35 148 46
Polygon -16777216 false false 132 25 144 38 147 48 151 62 158 63 159 47 155 30 147 18

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

book
false
0
Polygon -7500403 true true 30 195 150 255 270 135 150 75
Polygon -7500403 true true 30 135 150 195 270 75 150 15
Polygon -7500403 true true 30 135 30 195 90 150
Polygon -1 true false 39 139 39 184 151 239 156 199
Polygon -1 true false 151 239 254 135 254 90 151 197
Line -7500403 true 150 196 150 247
Line -7500403 true 43 159 138 207
Line -7500403 true 43 174 138 222
Line -7500403 true 153 206 248 113
Line -7500403 true 153 221 248 128
Polygon -1 true false 159 52 144 67 204 97 219 82

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

bread
false
0
Polygon -16777216 true false 140 145 170 250 245 190 234 122 247 107 260 79 260 55 245 40 215 32 185 40 155 31 122 41 108 53 28 118 110 115 140 130
Polygon -7500403 true true 135 151 165 256 240 196 225 121 241 105 255 76 255 61 240 46 210 38 180 46 150 37 120 46 105 61 47 108 105 121 135 136
Polygon -1 true false 60 181 45 256 165 256 150 181 165 166 180 136 180 121 165 106 135 98 105 106 75 97 46 107 29 118 30 136 45 166 60 181
Polygon -16777216 false false 45 255 165 255 150 180 165 165 180 135 180 120 165 105 135 97 105 105 76 96 46 106 29 118 30 135 45 165 60 180
Line -16777216 false 165 255 239 195

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

dish
false
0
Circle -7500403 true true 60 60 180
Rectangle -7500403 true true 255 90 270 225
Rectangle -7500403 true true 30 90 45 225
Polygon -7500403 true true 45 90 75 90 75 45 75 30 60 30 60 75 45 75 45 30 30 30 30 75 15 75 15 30 0 30 0 90 30 90 45 90 30 90 75 90 75 90 45 90 30 90 75 90 0 90 0 30 15 30 15 75 30 75 30 30 45 30 45 75 60 75 60 30 75 30 75 90 60 90 45 90 30 90
Rectangle -7500403 true true 269 49 275 92
Rectangle -7500403 true true 260 50 266 93
Rectangle -7500403 true true 251 49 257 92
Circle -7500403 true true 17 51 42

dot
false
0
Circle -7500403 true true 90 90 120

drawer
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

food
false
0
Polygon -7500403 true true 30 105 45 255 105 255 120 105
Rectangle -7500403 true true 15 90 135 105
Polygon -7500403 true true 75 90 105 15 120 15 90 90
Polygon -7500403 true true 135 225 150 240 195 255 225 255 270 240 285 225 150 225
Polygon -7500403 true true 135 180 150 165 195 150 225 150 270 165 285 180 150 180
Rectangle -7500403 true true 135 195 285 210

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
true
0
Polygon -7500403 true true 165 15 240 15 240 45 195 75 195 240 240 255 240 285 165 285
Polygon -7500403 true true 135 15 60 15 60 45 105 75 105 240 60 255 60 285 135 285

lander
true
0
Polygon -7500403 true true 45 75 150 30 255 75 285 225 240 225 240 195 210 195 210 225 165 225 165 195 135 195 135 225 90 225 90 195 60 195 60 225 15 225 45 75

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

pumpkin
false
0
Polygon -7500403 false true 148 30 107 33 74 44 33 58 15 105 0 150 30 240 105 285 135 285 150 270 165 285 195 285 255 255 300 150 268 62 225 43 196 36
Polygon -7500403 true true 33 58 0 150 30 240 105 285 135 285 150 270 165 285 195 285 255 255 300 150 268 62 226 43 194 36 148 32 105 35
Polygon -16777216 false false 108 40 75 57 42 101 32 177 79 253 124 285 133 285 147 268 122 222 103 176 107 131 122 86 140 52 154 42 193 66 204 101 216 158 212 209 188 256 164 278 163 283 196 285 234 255 257 199 268 137 251 84 229 52 191 41 163 38 151 41
Polygon -6459832 true false 133 50 171 50 167 32 155 15 146 2 117 10 126 23 130 33
Polygon -16777216 false false 117 10 127 26 129 35 132 49 170 49 168 32 154 14 145 1

roomba
true
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 120 15 60

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

tshirt
true
0
Polygon -7500403 true true 180 60 120 60 45 90 60 135 90 135 90 240 210 240 210 135 240 135 255 90
Polygon -16777216 true false 180 60 150 75 120 60 180 60 180 60

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

washingmachine
false
0
Rectangle -1 true false 45 45 255 255
Circle -7500403 true true 88 103 124

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
