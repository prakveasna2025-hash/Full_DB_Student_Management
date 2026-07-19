CREATE TABLE "users" (
  "user_id" uuid PRIMARY KEY NOT NULL,
  "role_id" uuid NOT NULL,
  "username" varchar UNIQUE NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_hash" varchar NOT NULL,
  "phone_number" varchar,
  "profile_picture_url" varchar,
  "status" varchar DEFAULT 'active',
  "is_verified" boolean DEFAULT false,
  "last_login_at" timestamp,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "roles" (
  "role_id" uuid PRIMARY KEY NOT NULL,
  "role_name" varchar UNIQUE NOT NULL,
  "description" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "departments" (
  "department_id" uuid PRIMARY KEY NOT NULL,
  "department_name" varchar UNIQUE NOT NULL,
  "description" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "teachers" (
  "teacher_id" uuid PRIMARY KEY NOT NULL,
  "user_id" uuid UNIQUE NOT NULL,
  "department_id" uuid,
  "hire_date" date NOT NULL,
  "specialization" varchar,
  "office_location" varchar,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "students" (
  "student_id" uuid PRIMARY KEY NOT NULL,
  "user_id" uuid UNIQUE NOT NULL,
  "department_id" uuid,
  "enrollment_date" date DEFAULT (now()),
  "graduation_date" date,
  "major" varchar,
  "year_level" int DEFAULT 1,
  "gpa" decimal(3,2) DEFAULT 0,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "parents" (
  "parent_id" uuid PRIMARY KEY NOT NULL,
  "user_id" uuid UNIQUE,
  "parent_name" varchar(150) NOT NULL,
  "email" varchar,
  "phone_number" varchar NOT NULL,
  "address" text,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "student_parents" (
  "student_id" uuid NOT NULL,
  "parent_id" uuid NOT NULL,
  "relationship_type" varchar NOT NULL,
  "is_emergency_contact" boolean DEFAULT false,
  PRIMARY KEY ("student_id", "parent_id")
);

CREATE TABLE "courses" (
  "course_id" uuid PRIMARY KEY NOT NULL,
  "course_code" varchar UNIQUE NOT NULL,
  "course_name" varchar NOT NULL,
  "description" text,
  "credits" int NOT NULL,
  "department_id" uuid NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "classes" (
  "class_id" uuid PRIMARY KEY NOT NULL,
  "course_id" uuid NOT NULL,
  "teacher_id" uuid,
  "semester" varchar NOT NULL,
  "capacity" int NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "schedules" (
  "schedule_id" uuid PRIMARY KEY NOT NULL,
  "class_id" uuid NOT NULL,
  "day_of_week" varchar NOT NULL,
  "start_time" time NOT NULL,
  "end_time" time NOT NULL,
  "room" varchar NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "enrollments" (
  "enrollment_id" uuid PRIMARY KEY NOT NULL,
  "student_id" uuid NOT NULL,
  "class_id" uuid NOT NULL,
  "enrolled_at" timestamp DEFAULT (now()),
  "grade" varchar,
  "status" varchar DEFAULT 'active',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "attendance" (
  "attendance_id" uuid PRIMARY KEY NOT NULL,
  "enrollment_id" uuid NOT NULL,
  "schedule_id" uuid NOT NULL,
  "status" varchar NOT NULL,
  "recorded_at" timestamp DEFAULT (now())
);

CREATE TABLE "assessments" (
  "assessment_id" uuid PRIMARY KEY NOT NULL,
  "class_id" uuid NOT NULL,
  "title" varchar NOT NULL,
  "description" text,
  "type" varchar NOT NULL,
  "max_score" int NOT NULL,
  "weight" decimal(5,2) NOT NULL,
  "due_date" date NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "assessment_submissions" (
  "submission_id" uuid PRIMARY KEY NOT NULL,
  "assessment_id" uuid NOT NULL,
  "student_id" uuid NOT NULL,
  "score_achieved" decimal(5,2),
  "feedback" text,
  "submitted_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "fees" (
  "fee_id" uuid PRIMARY KEY NOT NULL,
  "student_id" uuid NOT NULL,
  "class_id" uuid,
  "fee_type" varchar NOT NULL,
  "amount" decimal(10,2) NOT NULL,
  "due_date" date NOT NULL,
  "status" varchar DEFAULT 'Pending',
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE TABLE "payments" (
  "payment_id" uuid PRIMARY KEY NOT NULL,
  "fee_id" uuid NOT NULL,
  "student_id" uuid NOT NULL,
  "amount" decimal(10,2) NOT NULL,
  "currency" varchar DEFAULT 'USD',
  "payment_method" varchar NOT NULL,
  "transaction_id" varchar UNIQUE NOT NULL,
  "status" varchar DEFAULT 'Pending',
  "paid_at" timestamp DEFAULT (now()),
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp DEFAULT (now())
);

CREATE UNIQUE INDEX ON "enrollments" ("student_id", "class_id");

CREATE UNIQUE INDEX ON "assessment_submissions" ("assessment_id", "student_id");

COMMENT ON COLUMN "users"."status" IS 'active, suspended, inactive';

COMMENT ON COLUMN "attendance"."status" IS 'Present, Absent, Late, Excused';

COMMENT ON COLUMN "assessments"."type" IS 'Exam, Quiz, Assignment, Project';

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("role_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("user_id") REFERENCES "teachers" ("user_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "teachers" ADD FOREIGN KEY ("department_id") REFERENCES "departments" ("department_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("user_id") REFERENCES "students" ("user_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("department_id") REFERENCES "departments" ("department_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "users" ADD FOREIGN KEY ("user_id") REFERENCES "parents" ("user_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "student_parents" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "student_parents" ADD FOREIGN KEY ("parent_id") REFERENCES "parents" ("parent_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "courses" ADD FOREIGN KEY ("department_id") REFERENCES "departments" ("department_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "classes" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("course_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "classes" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("teacher_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "schedules" ADD FOREIGN KEY ("class_id") REFERENCES "classes" ("class_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "enrollments" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "enrollments" ADD FOREIGN KEY ("class_id") REFERENCES "classes" ("class_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "attendance" ADD FOREIGN KEY ("enrollment_id") REFERENCES "enrollments" ("enrollment_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "attendance" ADD FOREIGN KEY ("schedule_id") REFERENCES "schedules" ("schedule_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "assessments" ADD FOREIGN KEY ("class_id") REFERENCES "classes" ("class_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "assessment_submissions" ADD FOREIGN KEY ("assessment_id") REFERENCES "assessments" ("assessment_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "assessment_submissions" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fees" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fees" ADD FOREIGN KEY ("class_id") REFERENCES "classes" ("class_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "payments" ADD FOREIGN KEY ("fee_id") REFERENCES "fees" ("fee_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "payments" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("student_id") DEFERRABLE INITIALLY IMMEDIATE;
