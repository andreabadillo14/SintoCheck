import { PrismaClient } from "@prisma/client";
import express from "express";

// import https from "https";
// import fs from "fs";

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

app.post(`/signup/patient`, async (req, res) => {
  const {
    name,
    phone,
    password,
    birthdate,
    height,
    weight,
    medicine,
    medicalBackground,
  } = req.body;

  const result = await prisma.patient.create({
    data: {
      name,
      phone,
      password,
      birthdate,
      height,
      weight,
      medicine,
      medicalBackground,
    },
  });

  res.json(result);
});

app.post(`/signup/doctor`, async (req, res) => {
  const { name, phone, password, speciality, address } = req.body;

  const result = await prisma.doctor.create({
    data: {
      name,
      phone,
      password,
      speciality,
      address,
    },
  });

  res.json(result);
});

app.post(`/login/patient`, async (req, res) => {
  const { phone, password } = req.body;

  const result = await prisma.patient.findFirst({
    where: {
      phone,
      password,
    },
  });

  res.json(result);
});

app.post(`/login/doctor`, async (req, res) => {
  const { phone, password } = req.body;

  const result = await prisma.doctor.findFirst({
    where: {
      phone,
      password,
    },
  });

  res.json(result);
});

app.get(`/HealthData`, async (req, res) => {
  const result = await prisma.healthData.findMany({
    where: {
      patientId: null,
    },
  });
  res.json(result);
});

app.get(`/PersonalizedHealthData/:id`, async (req, res) => {
  const { id } = req.params;

  const result = await prisma.healthData.findMany({
    where: {
      patientId: id,
    },
  });

  res.json(result);
});

app.post(`/PersonalizedHealthData`, async (req, res) => {
  const { name, quantitative, patientId, rangeMin, rangeMax, unit } = req.body;

  const result = await prisma.healthData.create({
    data: {
      name,
      quantitative,
      patientId,
      rangeMin,
      rangeMax,
      unit,
    },
  });

  res.json(result);
});

app.post(`/HealthDataRecord`, async (req, res) => {
  const { patientId, healthDataId, value, note } = req.body;

  const result = await prisma.healthDataRecord.create({
    data: {
      patientId,
      healthDataId,
      value,
      note,
    },
  });

  res.json(result);
});

app.get(`/TrackedHealthData/:id`, async (req, res) => {
  const { id } = req.params;

  const result = await prisma.healthDataRecord.findMany({
    where: {
      patientId: id,
      // Return only the records of the last 7 days
      createdAt: {
        gte: new Date(new Date().setDate(new Date().getDate() - 7)),
      },
    },
    select: {
      healthData: true,
    },
    distinct: ["healthDataId"],
  });

  res.json(result);
});

app.get(`/HealthDataRecords/:patientId/:healthDataId`, async (req, res) => {
  const { patientId, healthDataId } = req.params;

  const result = await prisma.healthDataRecord.findMany({
    where: {
      patientId: patientId,
      healthDataId: healthDataId,
    },
    orderBy: {
      createdAt: "asc",
    },
  });

  res.json(result);
});

const server = app.listen(3000, () =>
  console.log(`Server ready at: http://localhost:3000`)
);

// const server = https.createServer(
//   {
//     key: fs.readFileSync("src/localhost-key.pem", "utf-8"),
//     cert: fs.readFileSync("src/localhost.pem", "utf-8"),
//   },
//   app
// );

// server.listen(3000);
