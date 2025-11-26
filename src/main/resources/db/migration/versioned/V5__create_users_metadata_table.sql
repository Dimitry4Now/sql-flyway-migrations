CREATE TABLE dime.user_metadata (
                                    user_id BIGSERIAL PRIMARY KEY REFERENCES dime.users(id),
                                    data JSONB NOT NULL
);

INSERT INTO dime.user_metadata (user_id, data) VALUES
                                                   (1, '{
                                                     "personal_info": {
                                                       "age": 28,
                                                       "weight_kg": 82,
                                                       "height_cm": 178
                                                     },
                                                     "lifestyle": {
                                                       "sleep": {
                                                         "avg_hours": 7,
                                                         "quality": "good"
                                                       },
                                                       "activity": {
                                                         "daily_steps": 6200,
                                                         "workouts_per_week": 2
                                                       }
                                                     },
                                                     "medical": {
                                                       "allergies": ["pollen"],
                                                       "conditions": ["mild_asthma"],
                                                       "medications": [
                                                         {
                                                           "name": "Ventolin",
                                                           "dose_mg": 2,
                                                           "frequency": "as_needed"
                                                         }
                                                       ]
                                                     }
                                                   }'),

                                                   (2, '{
                                                     "personal_info": {
                                                       "age": 33,
                                                       "weight_kg": 95,
                                                       "height_cm": 182
                                                     },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 6, "quality": "poor" },
                                                       "activity": { "daily_steps": 4200, "workouts_per_week": 0 }
                                                     },
                                                     "medical": {
                                                       "allergies": [],
                                                       "conditions": ["hypertension"],
                                                       "medications": [
                                                         { "name": "Lisinopril", "dose_mg": 5, "frequency": "daily" }
                                                       ]
                                                     }
                                                   }'),

                                                   (3, '{
                                                     "personal_info": { "age": 21, "weight_kg": 70, "height_cm": 175 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 7.5, "quality": "excellent" },
                                                       "activity": { "daily_steps": 9000, "workouts_per_week": 4 }
                                                     },
                                                     "medical": {
                                                       "allergies": ["penicillin"],
                                                       "conditions": [],
                                                       "medications": []
                                                     }
                                                   }'),

                                                   (4, '{
                                                     "personal_info": { "age": 45, "weight_kg": 110, "height_cm": 170 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 5, "quality": "poor" },
                                                       "activity": { "daily_steps": 3500, "workouts_per_week": 0 }
                                                     },
                                                     "medical": {
                                                       "allergies": [],
                                                       "conditions": ["type2_diabetes", "cholesterol"],
                                                       "medications": [
                                                         { "name": "Metformin", "dose_mg": 500, "frequency": "daily" },
                                                         { "name": "Atorvastatin", "dose_mg": 10, "frequency": "daily" }
                                                       ]
                                                     }
                                                   }'),

                                                   (5, '{
                                                     "personal_info": { "age": 52, "weight_kg": 88, "height_cm": 178 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 6.8, "quality": "fair" },
                                                       "activity": { "daily_steps": 4800, "workouts_per_week": 1 }
                                                     },
                                                     "medical": {
                                                       "allergies": ["dust"],
                                                       "conditions": ["arthritis"],
                                                       "medications": [
                                                         { "name": "Ibuprofen", "dose_mg": 400, "frequency": "as_needed" }
                                                       ]
                                                     }
                                                   }'),

                                                   (6, '{
                                                     "personal_info": { "age": 39, "weight_kg": 73, "height_cm": 167 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 7.2, "quality": "good" },
                                                       "activity": { "daily_steps": 8000, "workouts_per_week": 3 }
                                                     },
                                                     "medical": {
                                                       "allergies": [],
                                                       "conditions": ["thyroid"],
                                                       "medications": [
                                                         { "name": "Levothyroxine", "dose_mg": 25, "frequency": "daily" }
                                                       ]
                                                     }
                                                   }'),

                                                   (7, '{
                                                     "personal_info": { "age": 29, "weight_kg": 64, "height_cm": 162 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 8.1, "quality": "good" },
                                                       "activity": { "daily_steps": 7000, "workouts_per_week": 2 }
                                                     },
                                                     "medical": {
                                                       "allergies": ["gluten"],
                                                       "conditions": ["celiac"],
                                                       "medications": []
                                                     }
                                                   }'),

                                                   (8, '{
                                                     "personal_info": { "age": 60, "weight_kg": 102, "height_cm": 175 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 6.5, "quality": "fair" },
                                                       "activity": { "daily_steps": 3000, "workouts_per_week": 0 }
                                                     },
                                                     "medical": {
                                                       "allergies": ["latex"],
                                                       "conditions": ["heart_disease"],
                                                       "medications": [
                                                         { "name": "Aspirin", "dose_mg": 50, "frequency": "daily" },
                                                         { "name": "Bisoprolol", "dose_mg": 5, "frequency": "daily" }
                                                       ]
                                                     }
                                                   }'),

                                                   (9, '{
                                                     "personal_info": { "age": 26, "weight_kg": 72, "height_cm": 180 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 7.3, "quality": "good" },
                                                       "activity": { "daily_steps": 11000, "workouts_per_week": 5 }
                                                     },
                                                     "medical": {
                                                       "allergies": [],
                                                       "conditions": [],
                                                       "medications": []
                                                     }
                                                   }'),

                                                   (10, '{
                                                     "personal_info": { "age": 36, "weight_kg": 94, "height_cm": 190 },
                                                     "lifestyle": {
                                                       "sleep": { "avg_hours": 6.2, "quality": "fair" },
                                                       "activity": { "daily_steps": 5400, "workouts_per_week": 1 }
                                                     },
                                                     "medical": {
                                                       "allergies": ["cats"],
                                                       "conditions": ["anxiety"],
                                                       "medications": [
                                                         { "name": "Sertraline", "dose_mg": 50, "frequency": "daily" }
                                                       ]
                                                     }
                                                   }');

CREATE OR REPLACE VIEW dime.v_user_health_profile AS
SELECT
    user_id,

    data #>> '{personal_info,age}' AS age,
    data #>> '{personal_info,weight_kg}' AS weight_kg,
    data #>> '{personal_info,height_cm}' AS height_cm,
    ROUND(
            ( (data #>> '{personal_info,weight_kg}')::numeric * 10000 ) /
            ( (data #>> '{personal_info,height_cm}')::numeric ^ 2 )
        , 2) AS bmi,

    data #> '{medical,allergies}' AS allergies,
    data #> '{medical,conditions}' AS conditions

FROM dime.user_metadata;

CREATE OR REPLACE VIEW dime.v_user_lifestyle AS
SELECT
    user_id,

    data #>> '{lifestyle,sleep,avg_hours}' AS sleep_hours,
    data #>> '{lifestyle,sleep,quality}' AS sleep_quality,

    data #>> '{lifestyle,activity,daily_steps}' AS daily_steps,
    data #>> '{lifestyle,activity,workouts_per_week}' AS workouts_per_week

FROM dime.user_metadata;
