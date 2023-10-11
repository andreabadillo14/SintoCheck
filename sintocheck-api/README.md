# SintoCheck API

### Tech Stack

- Express.js
- Prisma

## Endpoints

#### GET

`/HealthData`
`/PersonalizedHealthData/:id`

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

