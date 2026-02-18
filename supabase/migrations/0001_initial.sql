CREATE TYPE job_location_type AS ENUM ('remote', 'hybrid', 'onsite');

CREATE TYPE job_type AS ENUM ('full_time', 'contract', 'freelance');

CREATE TYPE salary_period AS ENUM ('year', 'month', 'week', 'day', 'hour');

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TABLE IF NOT EXISTS "jobs" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "title" TEXT NOT NULL,
  "company_name" TEXT NOT NULL,
  "location_type" TEXT NOT NULL DEFAULT 'remote',
  "job_type" TEXT NOT NULL DEFAULT 'full_time',
  "location_text" TEXT,
  "tech_stack" TEXT NOT NULL DEFAULT '{}'::text[],
  "salary_min" INTEGER,
  "salary_max" INTEGER,
  "salary_currency" TEXT NOT NULL DEFAULT 'USD',
  "salary_period" TEXT NOT NULL DEFAULT 'year',
  "description" TEXT NOT NULL,
  "apply_url" TEXT,
  "is_active" BOOLEAN NOT NULL DEFAULT true
);

CREATE TRIGGER trg_jobs_updated_at BEFORE UPDATE ON "jobs" FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS "tech_tags" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "name" TEXT NOT NULL,
  "slug" TEXT NOT NULL
);

CREATE TRIGGER trg_tech_tags_updated_at BEFORE UPDATE ON "tech_tags" FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS "job_tech_tags" (
  "id" UUID NOT NULL DEFAULT gen_random_uuid(),
  "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "job_id" UUID NOT NULL,
  "tech_tag_id" UUID NOT NULL
);

CREATE TRIGGER trg_job_tech_tags_updated_at BEFORE UPDATE ON "job_tech_tags" FOR EACH ROW EXECUTE FUNCTION update_updated_at();