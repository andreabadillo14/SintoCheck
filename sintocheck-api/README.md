# SintoCheck API

### Tech Stack

- Express.js
- Prisma

## Endpoints

#### GET

`/HealthData`
Returns the list of common health data

`/PersonalizedHealthData/:id`
Returns the list of personalized health data for a patient

`/TrackedHealthData/:id`
Returns the list of tracked health data for a patient

`/HealthDataRecords/:patientId/:healthDataId`
Returns the list of specific data for the given patient


#### POST

`/signup/patient`: 
- name
- phone
- password
- birthdate?
- height?
- weight?
- medicine?
- medicalBackground?

`/signup/doctor`:
- name
- phone
- password
- specialty?
- address?

`/login/patient`: 
- phone
- password

`/login/doctor`: 
- phone
- password

`/PersonalizedHealthData`:
- name
- quantitative
- patientId
- rangeMin?
- rangeMax?
- unit?

`/HealthDataRecord`:
- patientId
- healthDataId
- value
- note?