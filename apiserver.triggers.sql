
DO $$DECLARE r record;
BEGIN
    FOR r IN SELECT routine_schema, routine_name FROM information_schema.routines
             WHERE routine_name LIKE 'notify_skor%'
    LOOP
        EXECUTE 'DROP FUNCTION ' || quote_ident(r.routine_schema) || '.' || quote_ident(r.routine_name) || '() CASCADE';
    END LOOP;
END$$;


CREATE OR REPLACE FUNCTION apiserver.notify_skor_resource_entry_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cur_rec record;
    BEGIN
      PERFORM pg_notify('skor', json_build_object(
                    'table', TG_TABLE_NAME,
                    'schema', TG_TABLE_SCHEMA,
                    'op',    TG_OP,
                    'data',  row_to_json(NEW)
              )::text);
      RETURN cur_rec;
    END;
$$;
DROP TRIGGER IF EXISTS notify_skor_resource_entry_insert ON apiserver.resource_entry;
CREATE TRIGGER notify_skor_resource_entry_insert AFTER insert ON apiserver.resource_entry FOR EACH ROW EXECUTE PROCEDURE apiserver.notify_skor_resource_entry_insert();


CREATE OR REPLACE FUNCTION apiserver.notify_skor_resource_entry_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cur_rec record;
    BEGIN
      PERFORM pg_notify('skor', json_build_object(
                    'table', TG_TABLE_NAME,
                    'schema', TG_TABLE_SCHEMA,
                    'op',    TG_OP,
                    'data',  row_to_json(NEW)
              )::text);
      RETURN cur_rec;
    END;
$$;
DROP TRIGGER IF EXISTS notify_skor_resource_entry_update ON apiserver.resource_entry;
CREATE TRIGGER notify_skor_resource_entry_update AFTER update ON apiserver.resource_entry FOR EACH ROW EXECUTE PROCEDURE apiserver.notify_skor_resource_entry_update();


CREATE OR REPLACE FUNCTION apiserver.notify_skor_resource_entry_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    cur_rec record;
    BEGIN
      PERFORM pg_notify('skor', json_build_object(
                    'table', TG_TABLE_NAME,
                    'schema', TG_TABLE_SCHEMA,
                    'op',    TG_OP,
                    'data',  row_to_json(OLD)
              )::text);
      RETURN cur_rec;
    END;
$$;
DROP TRIGGER IF EXISTS notify_skor_resource_entry_delete ON apiserver.resource_entry;
CREATE TRIGGER notify_skor_resource_entry_delete AFTER delete ON apiserver.resource_entry FOR EACH ROW EXECUTE PROCEDURE apiserver.notify_skor_resource_entry_delete();

