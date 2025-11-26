CREATE TABLE dime.vehicle_blackbox (
                                       id BIGSERIAL PRIMARY KEY,
                                       vehicle_id BIGINT NOT NULL,
                                       snapshot JSONB NOT NULL,
                                       created_at TIMESTAMP DEFAULT now()
);


INSERT INTO dime.vehicle_blackbox (vehicle_id, snapshot) VALUES
                                                              (1, '{
  "timestamp": "2025-01-10T12:44:00Z",
  "engine": {
    "system": {
      "combustion": {
        "fuel_mix": {
          "ratio": 14.7,
          "injectors": {
            "cylinder_1": {"ms": 2.9},
            "cylinder_2": {"ms": 3.0},
            "cylinder_3": {"ms": 2.8},
            "cylinder_4": {"ms": 3.1}
          }
        },
        "ignition": {
          "timing_advance_deg": 11,
          "coil_packs": {
            "pack_A": {"voltage": 13.1},
            "pack_B": {"voltage": 13.0}
          }
        }
      },
      "cooling": {
        "radiator": {
          "temperature_c": 90,
          "fan": { "speed_rpm": 1750, "stage": 2 }
        },
        "thermostat": { "open_percent": 63 }
      }
    }
  },
  "transmission": {
    "state": "drive",
    "gear": 4,
    "clutch": { "slip_percent": 1.2 }
  },
  "sensors": {
    "gps": {
      "coords": {
        "lat": 41.9981,
        "lon": 21.4254
      },
      "altitude_m": 245,
      "speed_kmh": 82,
      "route_history": {
        "last_5_points": [
          {"lat": 41.9990, "lon": 21.4200},
          {"lat": 42.0002, "lon": 21.4230},
          {"lat": 42.0015, "lon": 21.4250},
          {"lat": 42.0030, "lon": 21.4263},
          {"lat": 42.0050, "lon": 21.4270}
        ]
      }
    },
    "tires": {
      "front_left": {"pressure": 2.2, "temp_c": 38},
      "front_right": {"pressure": 2.3, "temp_c": 39},
      "rear_left": {"pressure": 2.1, "temp_c": 36},
      "rear_right": {"pressure": 2.1, "temp_c": 35}
    }
  },
  "battery": {
    "health": {
      "charge_cycles": 412,
      "capacity_loss_percent": 9.1,
      "cell_balance": {
        "cell_1": {"v": 3.98},
        "cell_2": {"v": 3.97},
        "cell_3": {"v": 3.96},
        "cell_4": {"v": 3.97}
      }
    }
  },
  "diagnostics": {
    "active_faults": [
      { "code": "P0420", "description": "Catalyst System Efficiency Below Threshold" }
    ],
    "history": {
      "last_3": [
        {"code": "P0455", "resolved": true},
        {"code": "U0100", "resolved": true},
        {"code": "P0138", "resolved": true}
      ]
    }
  }
}'),

                                                              (2, '{
  "timestamp": "2025-01-11T09:20:00Z",
  "engine": {
    "system": {
      "combustion": {
        "fuel_mix": {
          "ratio": 12.5,
          "injectors": {
            "c1": {"ms": 3.1},
            "c2": {"ms": 3.2},
            "c3": {"ms": 3.0},
            "c4": {"ms": 3.3}
          }
        },
        "ignition": {
          "timing_advance_deg": 10,
          "coil_packs": { "pack_A": {"voltage": 12.8} }
        }
      },
      "air_intake": {
        "airflow_gps": 24,
        "filter": { "status": "needs_replacement" }
      }
    }
  },
  "sensors": {
    "accelerometer": {
      "axis": {
        "x": 0.2,
        "y": -0.1,
        "z": 1.0
      },
      "impact_history": {
        "last": {
          "force_g": 2.1,
          "time": "2024-12-12T18:20:00Z"
        }
      }
    }
  },
  "routes": {
    "long_term": {
      "regions": {
        "visited": ["Skopje", "Ohrid", "Tetovo"],
        "heatmap": {
          "zone_A": { "count": 18 },
          "zone_B": { "count": 6 },
          "zone_C": { "count": 4 }
        }
      }
    }
  }
}'),

                                                              (3, '{
  "timestamp": "2025-01-12T15:03:00Z",
  "engine": {
    "system": {
      "combustion": {
        "fuel_mix": { "ratio": 15.1 },
        "ignition": { "timing_advance_deg": 12 }
      }
    }
  },
  "driving_pattern": {
    "acceleration_profile": {
      "segments": [
        { "duration_s": 2, "g_force": 0.4 },
        { "duration_s": 4, "g_force": 0.5 }
      ],
      "hard_brakes": [
        { "time": "2025-01-12T14:30:00Z", "g": -0.9 }
      ]
    },
    "predictive_wear": {
      "model": {
        "v1": {
          "brake_pads_km_left": 8000,
          "oil_life_percent": 41,
          "tire_life_percent": 73,
          "nested_estimates": {
            "confidence": {
              "sample": {
                "stats": {
                  "variance": 0.12,
                  "depth": {
                    "layers": {
                      "L1": { "v": 1 },
                      "L2": { "v": 2 },
                      "L3": { "v": 3 },
                      "L4": { "v": 4 },
                      "L5": { "v": 5 },
                      "L6": { "v": 6 },
                      "L7": { "v": 7 },
                      "L8": { "v": 8 },
                      "L9": { "v": 9 },
                      "L10": { "v": 10 }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}'),

                                                              (4, '{
  "timestamp": "2025-01-13T17:44:00Z",
  "environment": {
    "weather": {
      "temp_c": 3,
      "humidity_percent": 61,
      "precipitation": {
        "type": "rain",
        "intensity_mm": 1.2
      }
    }
  },
  "engine": {
    "temperature": {
      "coolant_c": 88,
      "oil_c": 95,
      "nested": {
        "level1": { "l2": { "l3": { "l4": { "l5": { "l6": { "l7": { "l8": { "l9": { "l10": {"l11": {"l12": "deep"}}}}}}}}}} }
      }
    }
  }
}'),

                                                              (5, '{
  "timestamp": "2025-01-14T11:11:00Z",
  "summary": {
    "trip": {
      "distance_km": 142,
      "fuel_used_l": 11.3,
      "efficiency_kmpl": 12.56,
      "route": {
        "start": "Skopje",
        "end": "Prilep",
        "segments": [
          {
            "highway": {
              "speed_avg_kmh": 112,
              "nested_1": {
                "n2": {
                  "n3": {
                    "n4": {
                      "n5": {
                        "n6": {
                          "n7": {
                            "n8": {
                              "n9": {
                                "n10": {
                                  "n11": {
                                    "n12": "deep"
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      }
    }
  }
}');

CREATE OR REPLACE VIEW dime.v_vehicle_telemetry_overview AS
SELECT
    id,
    vehicle_id,
    snapshot->>'timestamp' AS ts,

    -- Engine temps
    snapshot #>> '{engine,temperature,coolant_c}' AS coolant_temp,
    snapshot #>> '{engine,temperature,oil_c}' AS oil_temp,

    -- GPS speed
    snapshot #>> '{sensors,gps,speed_kmh}' AS speed_kmh,

    -- Battery state
    snapshot #>> '{battery,health,capacity_loss_percent}' AS battery_capacity_loss,

    -- Tire pressures
    jsonb_extract_path_text(snapshot, 'sensors','tires','front_left','pressure')  AS tire_fl,
    jsonb_extract_path_text(snapshot, 'sensors','tires','front_right','pressure') AS tire_fr,
    jsonb_extract_path_text(snapshot, 'sensors','tires','rear_left','pressure')   AS tire_rl,
    jsonb_extract_path_text(snapshot, 'sensors','tires','rear_right','pressure')  AS tire_rr

FROM dime.vehicle_blackbox;

CREATE OR REPLACE VIEW dime.v_vehicle_faults AS
SELECT
    id,
    vehicle_id,
    snapshot->>'timestamp' AS ts,

    -- Active faults (array)
    jsonb_array_elements(snapshot->'diagnostics'->'active_faults') AS active_fault,

    -- Historical faults (array)
    jsonb_array_elements(
            snapshot #> '{diagnostics,history,last_3}'
    ) AS historical_fault

FROM dime.vehicle_blackbox
WHERE snapshot ? 'diagnostics';


CREATE OR REPLACE VIEW dime.v_vehicle_predictive_wear AS
SELECT
    id,
    vehicle_id,
    snapshot->>'timestamp' AS ts,

    snapshot #>> '{driving_pattern,predictive_wear,model,v1,brake_pads_km_left}' AS brake_km_left,
    snapshot #>> '{driving_pattern,predictive_wear,model,v1,oil_life_percent}' AS oil_life_percent,
    snapshot #>> '{driving_pattern,predictive_wear,model,v1,tire_life_percent}' AS tire_life_percent,

    snapshot #>> '{driving_pattern,predictive_wear,model,v1,nested_estimates,confidence,sample,stats,variance}' AS variance_value,

    snapshot #>> '{driving_pattern,predictive_wear,model,v1,nested_estimates,confidence,sample,stats,depth,layers,L10,v}' AS layer10_value

FROM dime.vehicle_blackbox
WHERE snapshot #> '{driving_pattern,predictive_wear}' IS NOT NULL;


CREATE OR REPLACE VIEW dime.v_vehicle_environment AS
SELECT
    id,
    vehicle_id,

    snapshot->>'timestamp' AS ts,

    snapshot #>> '{environment,weather,temp_c}' AS ambient_temp,
    snapshot #>> '{environment,weather,humidity_percent}' AS humidity,
    snapshot #>> '{environment,weather,precipitation,type}' AS precip_type,
    snapshot #>> '{environment,weather,precipitation,intensity_mm}' AS precip_intensity,

    snapshot #>> '{engine,temperature,coolant_c}' AS coolant_temp,
    snapshot #>> '{engine,temperature,oil_c}' AS oil_temp

FROM dime.vehicle_blackbox
WHERE snapshot ? 'environment';
