/* create triggers*/

CREATE OR REPLACE FUNCTION site01.triggers_stock_list_log()
  RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  -- local variables here

BEGIN
 if tg_op='INSERT' then
  INSERT INTO site01.stock_list_log
  (STOCK_ID,old_status, new_status, memo, opt_user, NEW_CHAN_ID, OLD_CHAN_ID, opt_date)
  VALUES
    (new.stock_id,
     new.status,
     new.status,
     new.memo,
     new.opt_user,
     new.chan_id,
     new.chan_id,
     now());
  RETURN new;
   ELSEIF tg_op='UPDATE' then
   INSERT INTO site01.stock_list_log
  (STOCK_ID,old_status, new_status, memo, opt_user, NEW_CHAN_ID, OLD_CHAN_ID, opt_date)
  VALUES
    (new.stock_id,
     old.status,
     new.status,
     new.memo,
     new.opt_user,
     old.chan_id,
     new.chan_id,
     now());
  RETURN new;
   end if;
END;
$$;

CREATE TRIGGER INS_UPD
  BEFORE INSERT OR UPDATE
  ON site01.stock_list
  FOR EACH ROW
EXECUTE PROCEDURE site01.triggers_stock_list_log();


CREATE OR REPLACE FUNCTION site01.triggers_stock()
  RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_qty       INTEGER;
  err_context TEXT;
  i INTEGER;
BEGIN
  IF NEW.STATUS = 'C' AND OLD.STATUS = 'N'
  THEN
    i:=1;
    v_qty := OLD.qty;
    IF v_qty IS NULL OR v_qty < 0
    THEN
      RAISE EXCEPTION 'v_qty is null or v_qty<0 ';
    END IF;
    FOR i IN 1..v_qty LOOP
      INSERT INTO site01.stock_list
      (stock_id,
       pn_no,
       imei,
       PN_DESC,
       chan_id,
       in_date,
       in_user,
       status,
       opt_date,
       opt_user)
      VALUES
        (nextval('site01.seq_stock_id' :: REGCLASS),
         NEW.pn_no,
         NEW.imei,
         NEW.PN_DESC,
         NEW.chan_id,
         NEW.opt_date,
         NEW.opt_user,
         'N',
         now(),
         NEW.opt_user);
    END LOOP;
  END IF;
  RETURN new;
 EXCEPTION
   WHEN OTHERS
     THEN
--       --RAISE_APPLICATION_ERROR(-20010, NEW.id||'�����������ֻ�Ϊ�� !');
       GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
       RAISE EXCEPTION 'EXCEPTION:%', new.id
       USING ERRCODE = '-20010';
  --RAISE INFO 'Error Name:%',SQLERRM;
  --RAISE INFO 'Error State:%', SQLSTATE;
  --RAISE INFO 'Error Context:%', err_context;
END;
$$;

CREATE TRIGGER INS_UPD
  BEFORE INSERT OR UPDATE
  ON site01.upload_inf
  FOR EACH ROW
EXECUTE PROCEDURE site01.triggers_stock();


CREATE OR REPLACE FUNCTION site01.triggers_parts()
  RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  -- local variables here
BEGIN
  IF new.back_type = '1302' OR new.back_type = '1303'
  THEN
    UPDATE site01.stock_list
    SET status = 'N'
    WHERE stock_id = old.send_stock_id AND status = 'F';

    IF NOT FOUND
    THEN
      --RAISE_APPLICATION_ERROR('-20001',new.PARTS_ID || '����ʧ��B!');
      RAISE EXCEPTION 'NOT EXIST PARTS:%', new.PARTS_ID
      USING ERRCODE = '-20001';
    /* else
    update parts set status='8001', send_flag=null,send_date= null,back_flag='N',back_date=null,back_type=''
    where parts_id= new.PARTS_ID and bill_id=new.bill_id;
       IF SQL%ROWCOUNT != 1 THEN
       RAISE_APPLICATION_ERROR('-20002',
                               new.PARTS_ID || '����ʧ��B!');
                               end if;*/
    END IF;
  END IF;
  return new;
END;
$$;

CREATE TRIGGER INS_UPD
  BEFORE INSERT OR UPDATE
  ON site01.parts
  FOR EACH ROW
EXECUTE PROCEDURE site01.triggers_parts();


CREATE OR REPLACE FUNCTION site01.triggers_bill_dealer()
  RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  -- local variables here
  v_custname VARCHAR(32);
  v_cust_tel VARCHAR(32);
BEGIN
  IF new.STATUS = '6002' AND old.STATUS = '6001'
  THEN
    SELECT
      chan_name,
      TEL
    INTO v_custname, v_cust_tel
    FROM site01.chan_inf
    WHERE chan_id = new.chan_id;

    INSERT INTO site01.bills
    (BILL_NO,
     SN,
     STATUS,
     CUST_TYPE,
     CUST_NAME,
     CUST_TEL,
     DEALER,
     PART_TYPE,
     MODEL,
     APPEARANCE,
     WARRANTY,
     PURDATE,
     OPEN_USER,
     OPT_USER,
     RC_ID,
     SYMPTOM_CODE,
     SYMPTOM_DESC,
     E_MAIL,
     M_USE_HOUSE,
     D_USE_HOUSE,
     m_type,
     bill_type
    )
    VALUES
      (new.bill_no,
        new.sn,
        '4001',
        'GS',
        v_custname,
        v_cust_tel,
        v_custname,
        new.PART_TYPE,
        new.MODEL,
        new.APPEARANCE,
        new.WARRANTY,
        new.PURDATE,
        new.RVC_USER_ID,
        new.RVC_USER_ID,
        new.RVC_CHAN_ID,
        new.GU_CLASS,
        new.GU_DESC,
        '',
        new.M_HOUR,
        new.D_HOUR,
        new.M_TYPE,
       'D');
  END IF;
  return new;
END;
$$;

CREATE TRIGGER INS_UPD
  BEFORE INSERT OR UPDATE
  ON site01.bills_dealer
  FOR EACH ROW
EXECUTE PROCEDURE site01.triggers_bill_dealer();



CREATE OR REPLACE FUNCTION site01.triggers_account_inf()
  RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  -- local variables here

BEGIN
  IF new.inout_type = 'IN' AND new.part_status = 'GOOD'
  THEN
    PERFORM site01.usp_change_stock(new.stn_code, new.pn_no, 1, 0);
  END IF;

  IF new.inout_type = 'OUT' AND new.part_status = 'GOOD'
  THEN
    PERFORM site01.usp_change_stock(new.stn_code, new.pn_no, -1, 0);
  END IF;

  IF new.inout_type = 'IN' AND new.part_status = 'BAD'
  THEN
    PERFORM site01.usp_change_stock(new.stn_code, new.pn_no, 0, 1);
  END IF;

  IF new.inout_type = 'OUT' AND new.part_status = 'BAD'
  THEN
    PERFORM site01.usp_change_stock(new.stn_code, new.pn_no, 0, -1);
  END IF;
  return new;
  EXCEPTION
  WHEN OTHERS
    THEN
      --raise_application_error(-20001, :new.pn_no || '��治��!');
      RAISE EXCEPTION 'Exception:%', new.pn_no
      USING ERRCODE = '-20001';
END;
$$;

CREATE TRIGGER INS_UPD
  BEFORE INSERT
  ON site01.account_inf
  FOR EACH ROW
EXECUTE PROCEDURE site01.triggers_account_inf();
