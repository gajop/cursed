--------------------------------------------------------------------------------

local unitName = "euf_destroyer"

--------------------------------------------------------------------------------

local unitDef = {
  acceleration       = 0.0133,
  activateWhenBuilt  = true,
  airHoverFactor     = 0,
  airStrafe          = false,
  armortype          = "FLYER",
  brakeRate          = 0.931,
  buildCostEnergy    = 3500,
  buildCostMetal     = 3500,
  buildPic           = "euf_destroyer.png",
  buildTime          = 3500,
  canAttack          = true,
  canFly             = true,
  canGuard           = true,
  canMove            = true,
  canPatrol          = true,
  canstop            = "1",
  category           = "EUF AIR",
  cruiseAlt          = 350,
    customParams          = {	
	factionname	= "imperials",  
    helptext 	= "The only imperial spaceship with strong enough enginges to enter atmospheres. It has incredible firepower and a autorepair system!"	
  },
  description        = "Oblivion awaits",
  dontland           = "1",
  --  energyMake         = "0",
  explodeAs          = "BIG_EXPLOSION_BLUE",
  floater            = true,
  footprintX         = 6,
  footprintZ         = 6,
  hoverAttack        = true,
  iconType           = "bigskull",
  idleTime           = 400,  
  idleAutoHeal       = 10,  
  mass               = 30000,
  maxDamage          = 20000,
  maxSlope           = 25,
  maxVelocity        = 3,
  maxWaterDepth      = 0,
  metalMake          = 10,
  name               = "Imperial Destroyer",
  nanoColor          = "0 0 0",
  noChaseCategory    = "AIR",
  objectName         = "euf_destroyer.s3o",
  onoffable          = false,
  radarDistance      = 1024,
  script             = "euf_destroyer.cob",  
  selfDestructAs     = "BIG_EXPLOSION_BLUE",
  showNanoFrame      = false,
  side               = "cursed",
  sightDistance      = 1024,
  sonarDistance      = 1500,
  turnRate           = 250,
  unitname           = "euf_destroyer",
  useSmoothMesh      = true, 
  sfxtypes = {
    explosiongenerators = {
      "custom:BIG_EXPLOSION_BLUE",
      "custom:RaiderLaserFlare",		  
      "custom:PLasmaTowerGunFlare",
    },
  },
  sounds = {
    build              = "",
    canceldestruct     = "",
    repair             = "",
    underattack        = "voices_emergency",
    working            = "",
    arrived = {
      "",
    },
    cant = {
      "",
    },
    count = {
      "",
      "",
      "",
      "",
      "",
      "",
    },
    ok = {
      "bomber_move",
    },
    select = {
      "bomber_select",
    },
  },
  weapons = {
    [1]  = {
      badTargetCategory  = "LIGHTARMOR",
      def                = "SPACESHIP_PLASMA",
      mainDir            = "0 0 1",
      maxAngleDif        = 260,
      onlyTargetCategory = "LAND",
    },
    [2]  = {
      badTargetCategory  = "HEAVYARMOR",
      def                = "SPACESHIP_LASER",
      mainDir            = "0 0 1",
      maxAngleDif        = 180,
      onlyTargetCategory = "LAND AIR",
    },	
    [3]  = {
      badTargetCategory  = "HEAVYARMOR",
      def                = "SPACESHIP_LASER",
      mainDir            = "0 0 1",
      maxAngleDif        = 180,
      onlyTargetCategory = "LAND AIR",
    },
    [4]  = {
      badTargetCategory  = "HEAVYARMOR",
      def                = "SPACESHIP_LASER",
      mainDir            = "0 0 1",
      maxAngleDif        = 180,
      onlyTargetCategory = "LAND AIR",
    },	
  },
}


--------------------------------------------------------------------------------

local weaponDefs = {
  SPACESHIP_PLASMA = {
	accuracy           = 600,
    areaOfEffect       = 150,
    avoidFeature       = false,
    avoidFriendly      = false,
    avoidneutral       = "0",
    burnblow           = false,
    cegTag             = "PLasmaTowerGunProjectileGroundflash",
    collideFeature     = true,
    collideFriendly    = false,
    collideneutral     = "1",
    collisionSize      = 8,
    craterBoost        = 0,
    craterMult         = 0,
    cylinderTargeting = 128,
    edgeEffectiveness  = 1,
    energypershot      = 0,
    explosionGenerator = "custom:Walker_Hit_Explosion",
    explosionSpeed     = 65536,
    fireStarter        = 50,
    flightTime         = 10,
    impulseBoost       = 0,
    impulseFactor      = 0,
    interceptedByShieldType = 1,
    model              = "plasma.s3o",
    myGravity          = 1,
    name               = "Spaceship Plasma",
    --noSelfDamage       = true,
    range              = 600,
    reloadtime         = 4.5,
    soundHit           = "mediumexplosion",
    soundStart         = "hellstorm_fire",
    soundHitVolume     = 50,
    soundStartVolume   = 50,
    soundTrigger       = false,
    startVelocity      = 450,
    targetBorder       = 0,
    targetMoveError    = 0.8,
    tolerance          = 500,
    tracks             = false,
    trajectoryHeight   = 0.3,
    turret             = true,
    weaponAcceleration = 0,
    weaponType         = "MissileLauncher",
    weaponVelocity     = 450,
    damage = {
      default            = 400,
      flyer              = 400,
      heavy              = 400,
      light              = (400*0.75),
    },
  },
  SPACESHIP_LASER = {
      name                    = [[Spaceship Laser]],
      areaOfEffect            = 8,
      beamWeapon              = true,
      coreThickness           = 0.5,
      craterBoost             = 1,
      craterMult              = 2,
      cylinderTargeting 	  = 128, 
      duration                = 0.02,
      energypershot           = 0,
      explosionGenerator      = [[custom:RaiderLaserImpact]],
      fireStarter             = 50,
	  heightMod               = 1,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      --noSelfDamage            = true,
      range                   = 600,
      reloadtime              = 0.35,
      renderType              = 0,
      rgbColor                = [[1 0.1 0.1]],
 --     soundHit                = [[AgaresLaserHit]],
      soundStart              = [[starship_laser]],
	  soundStartVolume   = 50,
      soundTrigger            = true,
      targetMoveError         = 0.15,
      thickness               = 2.54950975679639,
      tolerance               = 10000,
      turret                  = true,
      weaponType              = [[LaserCannon]],
      weaponVelocity          = 880,
      damage = {
      default            = 150,
      flyer              = 150,
      heavy              = (150*0.75),
      light              = 150,
    },
  },
}
unitDef.weaponDefs = weaponDefs


--------------------------------------------------------------------------------

return lowerkeys({ [unitName] = unitDef })

--------------------------------------------------------------------------------
