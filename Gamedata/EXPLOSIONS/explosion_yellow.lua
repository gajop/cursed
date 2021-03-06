return {

	["dirtdome"] = {
		explosionsphere = {
			air				= true,
			class			= [[CSpherePartSpawner]],
			count			= 1,
			ground			= true,
			air				= true,
			properties = {
				alpha				= 0.4,
				alwaysvisible		= true,
				color				= [[0.2, 0.1, 0.1]],
				expansionspeed		= [[5 r1]],
				ttl					= 20,
			},
		},
	},
	["TINY_EXPLOSION_YELLOW"] = {
		glowysphere = {
		  air                = true,
		  class              = [[CExpGenSpawner]],
		  count              = 1,
		  ground             = true,
		  water              = true,
		  properties = {
			delay              = 0,
			explosiongenerator = [[custom:dirtdome]],
			pos                = [[0, 0, 0]],
		  },
		},
		GroundFlasha = {
			class			 = [[CSimpleGroundFlash]],
			count			 = 1,
			water			 = true,
			air				 = true,
			ground			 = true,
			properties = {
				size			 = [[60 r25]],
				sizegrowth		 = 0.75,
				ttl				 = 20,
				colormap		 = [[0.8 0.5 0.0 1	0 0 0 0.01]],
				texture			 =	[[groundflash]],
			},
		},
		GroundFlashb = {
			class			 = [[CSimpleGroundFlash]],
			count			 = 1,
			water			 = true,
			air				 = true,
			ground			 = true,
			properties = {
				size			 = [[50 r25]],
				sizegrowth		 = 1,
				ttl				 = 10,
				colormap		 = [[0.8 0.5 0.3 1	0 0 0 0.01]],
				texture			 =	[[swish1]],
			},
		},
		GroundFlashc = {
			class			 = [[CSimpleGroundFlash]],
			count			 = 1,
			water			 = true,
			air				 = true,
			ground			 = true,
			properties = {
				size			 = [[30 r45]],
				sizegrowth		 = 2,
				ttl				 = 12,
				colormap		 = [[0.8 0.5 0.3 1	0 0 0 0.01]],
				texture			 =	[[swish2]],
			},
		},
		poof01 = {
			air				= true,
			class			= [[CSimpleParticleSystem]],
			count			= 1,
			ground			= true,
			properties = {
				airdrag					= 0.8,
				alwaysvisible			= true,
				colormap				= [[1.0 1.0 1.0 0.04	1 0.7 0.2 0.01	0.1 0.1 0.1 0.01]],
				directional				= true,
				emitrot					= 45,
				emitrotspread			= 32,
				emitvector				= [[0, 1, 0]],
				gravity					= [[0, -0.05, 0]],
				numparticles			= 8,
				particlelife			= 5,
				particlelifespread		= 5,
				particlesize			= 15,
				particlesizespread		= 0,
				particlespeed			= 2,
				particlespeedspread		= 5,
				pos						= [[0, 2, 0]],
				sizegrowth				= 1,
				sizemod					= 1.0,
				texture					= [[flashside1]],
				useairlos				= false,
			},
		},
		poof02 = {
			air			= true,
			class		= [[CSimpleParticleSystem]],
			count		= 1,
			ground		= true,
			water		= true,
			properties = {
				airdrag					= 0.8,
				alwaysvisible			= true,
				colormap				= [[0.8 0.8 0.2 0.01	0.8 0.5 0.2 0.01	0.0 0.0 0.0 0.01]],
				directional				= false,
				emitrot					= 45,
				emitrotspread			= 32,
				emitvector				= [[0, 1, 0]],
				gravity					= [[0, -0.005, 0]],
				numparticles			= 8,
				particlelife			= 5,
				particlelifespread 		= 8,
				particlesize			= 10,
				particlesizespread		= 0,
				particlespeed			= 8,
				particlespeedspread		= 3,
				pos						= [[0, 2, 0]],
				sizegrowth				= 0.8,
				sizemod					= 1.0,
				texture					= [[randdots2]],
				useairlos				= false,
			},
		},
		pop2 = {
			air				= true,
			class			= [[heatcloud]],
			count			= 2,
			ground			= true,
			water			= true,
			properties = {
				alwaysvisible			= true,
				heat					= 10,
				heatfalloff				= 2,
				maxheat					= 15,
				pos						= [[r-3 r3, 5, r-3 r3]],
				size					= 0.2,
				sizegrowth				= 3,
				speed					= [[0, 1, 0]],
				texture					= [[redexplo]],
			},
		},
	},
  ["SMALL_EXPLOSION_YELLOW"] = {
    dirt = {
      count              = 4,
      ground             = true,
      properties = {
        alphafalloff       = 2,
        color              = [[0.2, 0.1, 0.05]],
        pos                = [[r-10 r10, 0, r-10 r10]],
        size               = 22,
        speed              = [[r1.5 r-1.5, 4, r1.5 r-1.5]],
      },
    },
	GroundFlashb = {
		class			 = [[CSimpleGroundFlash]],
		count			 = 1,
		water			 = true,
		air				 = true,
		ground			 = true,
		properties = {
			size			 = 100,
			sizegrowth		 = 5,
			ttl				 = 12,
			colormap		 = [[1 0.5 0 0.1  0 0 0 0.01]],
			texture			 =  [[seismic]],
		},
	},
    dirtw1 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.9 0.9 0.9 1.0	0.5 0.5 0.9 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.2, 0]],
        numparticles       = 28,
        particlelife       = 25,
        particlelifespread = 10,
        particlesize       = 10,
        particlesizespread = 5,
        particlespeed      = 1,
        particlespeedspread = 20,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[randdots2]],
        useairlos          = false,
      },
    },
    dirtw2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.7,
        alwaysvisible      = true,
        colormap           = [[1.0 1.0 1.0 1.0	0.5 0.5 0.8 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 15,
        particlelifespread = 10,
        particlesize       = 35,
        particlesizespread = 5,
        particlespeed      = 10,
        particlespeedspread = 10,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[dirt]],
        useairlos          = false,
      },
    },
    flare = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[1 1 1 0.01	0.9 0.8 0.7 0.04	0.9 0.5 0.2 0.01	0.5 0.1 0.1 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 14,
        particlelifespread = 0,
        particlesize       = 70,
        particlesizespread = 0,
        particlespeed      = 10,
        particlespeedspread = 5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1.0,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },
    groundflash = {
      air                = true,
      alwaysvisible      = true,
      circlealpha        = 0.5,
      circlegrowth       = 8,
      flashalpha         = 0.9,
      flashsize          = 150,
      ground             = true,
      ttl                = 17,
      water              = true,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0.20000000298023,
      },
    },
    pop1 = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.4,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 5,
        sizegrowth         = 24,
        speed              = [[0, 1 0, 0]],
        texture            = [[redexplo]],
      },
    },
    whiteglow = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.1,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 10,
        sizegrowth         = 25,
        speed              = [[0, 1 0, 0]],
        texture            = [[laserend]],
      },
    },
  },
  
  ["MEDIUM_EXPLOSION_YELLOW"] = {
    dirt = {
      count              = 4,
      ground             = true,
      properties = {
        alphafalloff       = 2,
        color              = [[0.2, 0.1, 0.05]],
        pos                = [[r-10 r10, 0, r-10 r10]],
        size               = 22,
        speed              = [[r1.5 r-1.5, 4, r1.5 r-1.5]],
      },
    },
	GroundFlashb = {
		class			 = [[CSimpleGroundFlash]],
		count			 = 1,
		water			 = true,
		air				 = true,
		ground			 = true,
		properties = {
			size			 = 150,
			sizegrowth		 = 5,
			ttl				 = 12,
			colormap		 = [[1 0.5 0 0.1  0 0 0 0.01]],
			texture			 =  [[seismic]],
		},
	},
    dirtw1 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.9 0.9 0.9 1.0	0.5 0.5 0.9 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.2, 0]],
        numparticles       = 28,
        particlelife       = 25,
        particlelifespread = 10,
        particlesize       = 15,
        particlesizespread = 5,
        particlespeed      = 1,
        particlespeedspread = 20,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[randdots2]],
        useairlos          = false,
      },
    },
    dirtw2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.7,
        alwaysvisible      = true,
        colormap           = [[1.0 1.0 1.0 1.0	0.5 0.5 0.8 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 15,
        particlelifespread = 10,
        particlesize       = 50,
        particlesizespread = 5,
        particlespeed      = 10,
        particlespeedspread = 10,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[dirt]],
        useairlos          = false,
      },
    },
    flare = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[1 1 1 0.01	0.9 0.8 0.7 0.04	0.9 0.5 0.2 0.01	0.5 0.1 0.1 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 14,
        particlelifespread = 0,
        particlesize       = 105,
        particlesizespread = 0,
        particlespeed      = 10,
        particlespeedspread = 5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1.0,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },
    groundflash = {
      air                = true,
      alwaysvisible      = true,
      circlealpha        = 0.5,
      circlegrowth       = 12,
      flashalpha         = 0.9,
      flashsize          = 150,
      ground             = true,
      ttl                = 17,
      water              = true,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0.20000000298023,
      },
    },
    pop1 = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.4,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 8,
        sizegrowth         = 24,
        speed              = [[0, 1 0, 0]],
        texture            = [[redexplo]],
      },
    },
    whiteglow = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.1,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 15,
        sizegrowth         = 25,
        speed              = [[0, 1 0, 0]],
        texture            = [[laserend]],
      },
    },
  },

  ["BIG_EXPLOSION_YELLOW"] = {
    dirt = {
      count              = 4,
      ground             = true,
      properties = {
        alphafalloff       = 2,
        color              = [[0.2, 0.1, 0.05]],
        pos                = [[r-10 r10, 0, r-10 r10]],
        size               = 44,
        speed              = [[r1.5 r-1.5, 4, r1.5 r-1.5]],
      },
    },
	GroundFlashb = {
		class			 = [[CSimpleGroundFlash]],
		count			 = 1,
		water			 = true,
		air				 = true,
		ground			 = true,
		properties = {
			size			 = 200,
			sizegrowth		 = 5,
			ttl				 = 12,
			colormap		 = [[1 0.5 0 0.1  0 0 0 0.01]],
			texture			 =  [[seismic]],
		},
	},
    dirtw1 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.9 0.9 0.9 1.0	0.5 0.5 0.9 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.2, 0]],
        numparticles       = 28,
        particlelife       = 25,
        particlelifespread = 10,
        particlesize       = 20,
        particlesizespread = 5,
        particlespeed      = 1,
        particlespeedspread = 20,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[randdots2]],
        useairlos          = false,
      },
    },
    dirtw2 = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      properties = {
        airdrag            = 0.7,
        alwaysvisible      = true,
        colormap           = [[1.0 1.0 1.0 1.0	0.5 0.5 0.8 0.0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 15,
        particlelifespread = 10,
        particlesize       = 70,
        particlesizespread = 5,
        particlespeed      = 10,
        particlespeedspread = 10,
        pos                = [[r-1 r1, 1, r-1 r1]],
        sizegrowth         = 1.2,
        sizemod            = 1.0,
        texture            = [[dirt]],
        useairlos          = false,
      },
    },
    flare = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[1 1 1 0.01	0.9 0.8 0.7 0.04	0.9 0.5 0.2 0.01	0.5 0.1 0.1 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 8,
        particlelife       = 14,
        particlelifespread = 0,
        particlesize       = 140,
        particlesizespread = 0,
        particlespeed      = 10,
        particlespeedspread = 5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1.0,
        texture            = [[flashside1]],
        useairlos          = false,
      },
    },
    groundflash = {
      air                = true,
      alwaysvisible      = true,
      circlealpha        = 0.5,
      circlegrowth       = 16,
      flashalpha         = 0.9,
      flashsize          = 150,
      ground             = true,
      ttl                = 17,
      water              = true,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0.20000000298023,
      },
    },
    pop1 = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.4,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 10,
        sizegrowth         = 24,
        speed              = [[0, 1 0, 0]],
        texture            = [[redexplo]],
      },
    },
    whiteglow = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.1,
        maxheat            = 15,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 20,
        sizegrowth         = 25,
        speed              = [[0, 1 0, 0]],
        texture            = [[laserend]],
      },
    },
  },

  
}

