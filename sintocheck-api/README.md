# SintoCheck API

### Tech Stack

- Express.js
- Prisma

## Endpoints

Most endpoints require a JWT token to be passed in the `Authorization` header of the request. The token can be obtained by logging in.

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

`/signup/patient`
- name
- phone
- password
- birthdate?
- height?
- weight?
- medicine?
- medicalBackground?

`/signup/doctor`
- name
- phone
- password
- specialty?
- address?

`/login/patient`
Verifies the login credentials and returns a JWT 

- phone
- password

`/login/doctor`
Verifies the login credentials and returns a JWT 

- phone
- password

`/PersonalizedHealthData`

- name
- quantitative
- patientId
- rangeMin?
- rangeMax?
- unit?

`/HealthDataRecord`

- patientId
- healthDataId
- value
- note?