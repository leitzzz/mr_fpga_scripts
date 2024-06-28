#!/usr/bin/env python
# ready to use on the Mister FPGA
# copy this file into "Scripts" folder
# and later go to the scripts menu and run this script

"""
Before you start to cry reading this long script, the main purpose is keep all the necessary in one file, to avoid having more unnecessary files in the Mister FPGA "Scripts" folder, thats why is this so long. Sorry for that!
"""

import os
import urllib.parse
import requests  # pylint: disable=import-error

# here goes the rbf core file
# CORE_DIRECTORY_DESTINATION = "/media/fat/_Console/"

# in this directory goes .neo (in subfolder NEOGEO yes! again) and .rom .sfix .sp1 .uni .xml files
DIRECTORY_DESTINATION = "/media/fat/games/NEOGEO/"
# DIRECTORY_DESTINATION = "./"

# this is the current mister fpga core url
# check the latest version at: https://github.com/MiSTer-devel/NeoGeo_MiSTer/tree/master/releases
# and modify the url below to get the most recent one
# CURRENT_MISTER_FPGA_RBF_CORE_URL = "https://raw.githubusercontent.com/MiSTer-devel/NeoGeo_MiSTer/920b8d4cb8271f84e7818f7ac747657cf07d6de2/releases/NeoGeo_20240418.rbf"

# list of files to download, extracted using an scrap
DOWNLOAD_FILES_URL = ['https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2F000-lo.lo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FBang%20Bang%20Busters.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FCrossed%20Swords.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FCrossed%20Swords%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FCyber-Lip.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FEight%20Man.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FGanryu.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug%203.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug%204.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug%205.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FMetal%20Slug%20X.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FNAM-1975.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FNeo%20Mr.%20Do%21.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FNightmare%20in%20the%20Dark.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FShock%20Troopers%20-%202nd%20Squad.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FShock%20Troopers.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FAction%2FZupapa%21.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FBurning%20Fight.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FLegend%20of%20Success%20Joe.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FMutation%20Nation.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FNinja%20Combat.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FRobo%20Army.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FSengoku.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FSengoku%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FSengoku%203.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FBeatEmUp%2FThe%20Super%20Spy.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FDriving%2FNeo%20Drift%20Out%20-%20New%20Technology.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FDriving%2FOver%20Top.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FDriving%2FRiding%20Hero.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FDriving%2FThrash%20Rally.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2F3%20Count%20Bout.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FAggressors%20of%20Dark%20Kombat.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FArt%20of%20Fighting.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FArt%20of%20Fighting%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FArt%20of%20Fighting%203%20-%20The%20Path%20of%20the%20Warrior.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FBreakers.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FBreakers%20Revenge.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FDouble%20Dragon.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFar%20East%20of%20Eden%20-%20Kabuki%20Klash.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFatal%20Fury%20-%20King%20of%20Fighters.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFatal%20Fury%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFatal%20Fury%203%20-%20Road%20to%20the%20Final%20Victory.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFatal%20Fury%20Special.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FFight%20Fever.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FGalaxy%20Fight%20-%20Universal%20Warriors.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FGarou%20-%20Mark%20of%20the%20Wolves.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FKarnov%27s%20Revenge.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FKing%20of%20the%20Monsters.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FKing%20of%20the%20Monsters%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FKizuna%20Encounter.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FMatrimelee.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FNinja%20Master%27s%20-%20Ha%C5%8D%20Ninp%C5%8D%20Ch%C5%8D.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FRage%20of%20the%20Dragons.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FRagnagard.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FReal%20Bout%20Fatal%20Fury.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FReal%20Bout%20Fatal%20Fury%202%20-%20The%20Newcomers.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FReal%20Bout%20Fatal%20Fury%20Special.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSNK%20vs.%20Capcom%20-%20SVC%20Chaos.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown%20II.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown%20III%20-%20Blades%20of%20Blood.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown%20IV%20-%20Amakusa%27s%20Revenge.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown%20V.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSamurai%20Shodown%20V%20Special.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FSavage%20Reign.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2794.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2795.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2796.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2797.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2798%20-%20The%20Slugfest.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%20%2799%20-%20Millennium%20Battle.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%202000.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%202001.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%202002%20-%20Challenge%20to%20Ultimate%20Battle.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20King%20of%20Fighters%202003.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20Last%20Blade.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FThe%20Last%20Blade%202.neo',
                      'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FVoltage%20Fighter%20Gowcaizer.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FWaku%20Waku%207.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FWorld%20Heroes.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FWorld%20Heroes%202%20Jet.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FWorld%20Heroes%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FFighting%2FWorld%20Heroes%20Perfect.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FMahjong%2FBakatonosama%20Mahjong%20Manyuuki.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FMahjong%2FIdol%20Mahjong%20Final%20Romance%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FMahjong%2FJanshin%20Densetsu%20-%20Quest%20of%20Jongmaster.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FMahjong%2FMahjong%20Ky%C5%8Dretsuden%20-%20Nishi%20Nihon%20Hen.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FOther%2FMinna-san%20no%20Okage-sama%20Desu%21%20Dai%20Sugoroku%20Taikai.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FOther%2FSh%C5%8Dgi%20no%20Tatsujin%20-%20Master%20of%20Syougi.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FOther%2FThe%20Irritating%20Maze.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPlatformer%2FBlue%27s%20Journey.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPlatformer%2FMagician%20Lord.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPlatformer%2FSpinMaster.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPlatformer%2FTop%20Hunter%20-%20Roddy%20%26%20Cathy.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FBomberman%20-%20Panic%20Bomber.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FGururin.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FMagical%20Drop%20II.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FMagical%20Drop%20III.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FMoney%20Puzzle%20Exchanger.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FNeo%20Bomberman.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPochi%20and%20Nyaa.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPop%20%27n%20Bounce.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPuzzle%20Bobble.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPuzzle%20Bobble%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPuzzle%20De%20Pon%21.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPuzzle%20De%20Pon%21%20R.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FPuzzled.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FTwinkle%20Star%20Sprites.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FPuzzle%2FZinTrick.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FQuiz%2FChibi%20Maruko-chan%20-%20Maruko%20Deluxe%20Quiz.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FQuiz%2FQuiz%20Dais%C5%8Dsasen%20-%20The%20Last%20Count%20Down.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FQuiz%2FQuiz%20King%20of%20Fighters.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FQuiz%2FQuiz%20Meitantei%20Neo%20%26%20Geo%20-%20Quiz%20Dais%C5%8Dsasen%20Part%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FAero%20Fighters%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FAero%20Fighters%203.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FAlpha%20Mission%20II.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FAndro%20Dunos.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FBlazing%20Star.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FCaptain%20Tomaday.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FGhost%20Pilots.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FLast%20Resort.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FNinja%20Commando.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FPrehistoric%20Isle%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FPulstar.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FStrikers%201945%20Plus.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FViewpoint.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FShooter%2FZed%20Blade.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FBang%20Bead.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FBaseball%20Stars%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FBaseball%20Stars%20Professional.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FBattle%20Flip%20Shot.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FFootball%20Frenzy.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FGoal%21%20Goal%21%20Goal%21.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FLeague%20Bowling.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FNeo%20Geo%20Cup%20%2798%20-%20The%20Road%20to%20the%20Victory.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FNeo%20Turf%20Masters.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FPleasure%20Goal%20-%205%20on%205%20Mini%20Soccer.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FPower%20Spikes%20II.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSoccer%20Brawl.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FStakes%20Winner.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FStakes%20Winner%202.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FStreet%20Slam.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSuper%20Baseball%202020.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSuper%20Dodge%20Ball.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSuper%20Sidekicks.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSuper%20Sidekicks%202%20-%20The%20World%20Championship.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FSuper%20Sidekicks%203%20-%20The%20Next%20Glory.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FTecmo%20World%20Soccer%20%2796.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FThe%20Ultimate%2011%20-%20SNK%20Football%20Championship.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FTop%20Player%27s%20Golf.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2FSports%2FWindjammers.neo', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fgog-broken-romsets.xml', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fgog-romsets.xml', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fneo-epo.sp1', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fromsets.xml', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fsfix.sfix', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Fsp-s2.sp1', 'https://archive.org/download/neo-geo-1g1r-darksoft-converted-to-neosd-mister-fpga/NEOGEO.zip/NEOGEO%2Funi-bios.rom']


def show_header_message():
    """
    Just show a fancy message to appear to be a cool programmer!
    """

    print("""
       _   _            _____             ______                      _ 
      | \ | |          |  __ \            | ___ \                    | |
      |  \| | ___  ___ | |  \/ ___  ___   | |_/ /____      _____ _ __| |
      | . ` |/ _ \/ _ \| | __ / _ \/ _ \  |  __/ _ \ \ /\ / / _ \ '__| |
      | |\  |  __/ (_) | |_\ \  __/ (_) | | | | (_) \ V  V /  __/ |  |_|
      \_| \_/\___|\___/ \____/\___|\___/  \_|  \___/ \_/\_/ \___|_|  (_)
                                                       
    """)

    print("The main purpose of this script is to download the neccessary files to start to enjoy NeoGeo on the Mister FPGA")


def download_file(file_url: str, file_name: str, verbose: bool = False):
    """
    Download a file from a URL and save it to a specified path.

    Parameters:
    - file_url: str, the URL to download the file from.
    - file_name: str, the name of the file to save.
    """
    if verbose:
        print(f"Downloading {file_url} to {file_name}...")

    response = requests.get(file_url)

    with open(file_name, 'wb') as downloaded_file:
        downloaded_file.write(response.content)


def process_downloads():
    """
    Process the downloads of the files
    """

    # download the most recent core for the NeoGeo on Mister FPGA

    # uncomment the following lines to download the core
    # print(
    #     f"Im gonna download a very important Mister Core file for the NeoGeo: {CURRENT_MISTER_FPGA_RBF_CORE_URL.split('/')[-1]}")
    # download_file(CURRENT_MISTER_FPGA_RBF_CORE_URL,
    #               f'{CORE_DIRECTORY_DESTINATION}{CURRENT_MISTER_FPGA_RBF_CORE_URL.split("/")[-1]}', True)

    for download_file_url in DOWNLOAD_FILES_URL:

        # validate if the directy where the r-o-m-s will be saved exists, if not create it
        if not os.path.exists(f'{DIRECTORY_DESTINATION}/NEOGEO'):
            os.makedirs(f'{DIRECTORY_DESTINATION}/NEOGEO')

        final_file_name = ''

        # sanitize file name to save it in the directory destiny and build the correct folder structure
        parsed_filename_from_original_url = urllib.parse.unquote(
            download_file_url.split("%2F")[-1])
        if download_file_url.split(".")[-1] == 'neo':
            # proceed to download the file from the list and save it in the directory destiny
            # bios files goes to the main directory and the other ones (r.o.m.s) to the NEOGEO folder
            print(
                f"Hey! i will start with: {parsed_filename_from_original_url.split('.')[0]}")
            final_file_name = f'{DIRECTORY_DESTINATION}NEOGEO/{parsed_filename_from_original_url}'
        else:
            final_file_name = f'{DIRECTORY_DESTINATION}{parsed_filename_from_original_url}'

        # proceed to download the file from the list and save it in the directory destiny if not exists.
        if not os.path.exists(final_file_name):
            download_file(
                download_file_url, final_file_name, True)
        else:
            print(
                f"File {final_file_name} already exists, skipping download...")


def main():
    show_header_message()

    process_downloads()


if __name__ == "__main__":
    main()
