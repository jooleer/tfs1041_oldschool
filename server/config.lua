-- Combat settings
-- NOTE: valid values for worldType are: "pvp", "no-pvp" and "pvp-enforced"
worldType = "pvp"
hotkeyAimbotEnabled = "no"
killsToRedSkull = 3
killsToBlackSkull = 6
pzLocked = 60000
removeChargesFromRunes = "yes"
timeToDecreaseFrags = 24 * 60 * 60 * 1000
whiteSkullTime = 15 * 60 * 1000
stairJumpExhaustion = 1000
experienceByKillingPlayers = "no"
expFromPlayersLevelRange = 75
allowFightBack = "no"

-- Connection Config
-- NOTE: maxPlayers set to 0 means no limit
ip = "127.0.0.1"
bindOnlyGlobalAddress = "no"
loginProtocolPort = 7171
gameProtocolPort = 7172
statusProtocolPort = 7171
maxPlayers = 0
motd = "Welcome to OTServ."
onePlayerOnlinePerAccount = "yes"
allowClones = false
serverName = "OTServ"
statusTimeout = 5000
replaceKickOnLogin = "yes"
maxPacketsPerSecond = 25

-- Deaths
-- NOTE: Leave deathLosePercent as -1 if you want to use the default
-- death penalty formula. For the old formula, set it to 10. For
-- no skill/experience loss, set it to 0.
deathLosePercent = 10

-- Houses
-- NOTE: set housePriceEachSQM to -1 to disable the ingame buy house functionality
housePriceEachSQM = 175
houseRentPeriod = "monthly"

-- Item Usage
timeBetweenActions = 200
timeBetweenExActions = 1000

-- Map
-- NOTE: set mapName WITHOUT .otbm at the end
mapName = "map"
mapAuthor = "OTServ"

-- Market
marketOfferDuration = 30 * 24 * 60 * 60
premiumToCreateMarketOffer = "no"
checkExpiredMarketOffersEachMinutes = 60
maxMarketOffersAtATimePerPlayer = 100

-- MySQL
mysqlHost = "127.0.0.1"
mysqlUser = "root"
mysqlPass = ""
mysqlDatabase = "OTServ"
mysqlPort = 3306
mysqlSock = ""

-- Misc.
allowChangeOutfit = "yes"
freePremium = "no"
kickIdlePlayerAfterMinutes = 15
maxMessageBuffer = 4
emoteSpells = "no"
classicEquipmentSlots = "yes"

-- Rates
-- NOTE: rateExp is not used if you have enabled stages in data/XML/stages.xml
rateExp = 1
rateSkill = 1
rateLoot = 1.65
rateMagic = 1
rateSpawn = 1

-- Monsters
deSpawnRange = 2
deSpawnRadius = 50

-- Stamina
staminaSystem = "no"

-- Scripts
warnUnsafeScripts = "yes"
convertUnsafeScripts = "yes"

-- Startup
-- NOTE: defaultPriority only works on Windows and sets process
-- priority, valid values are: "normal", "above-normal", "high"
defaultPriority = "high"
startupDatabaseOptimization = "no"

-- Status server information
ownerName = "OTServ"
ownerEmail = "OTServ@gmail.com"
url = "OTServ.com"
location = "OTServ"
