/* Create all Functions*/

CREATE OR REPLACE FUNCTION site01.OPEN_ORDERS(IN_DATA  IN  VARCHAR,
                                              OUT_DATA OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  V_XML XML;
BEGIN
  V_XML := XMLPARSE(DOCUMENT IN_DATA);
  OUT_DATA := 'OK';
  INSERT INTO site01.bills
  (
    BILL_NO,
    SN,
    STATUS,
    CUST_TYPE,
    CUST_NAME,
    CUST_TEL,
    DEALER,
    PART_TYPE,
    MODEL,
    PCOLOR,
    IMEI,
    PCODE,
    APPEARANCE,
    WARRANTY,
    WAREA,
    FIX_TYPE,
    CHANGETYPE,
    PURDATE,
    INVOICE,
    INVOICE_NO,
    SID,
    OPEN_USER,
    OPT_USER,
    RC_ID,
    SYMPTOM_CODE,
    SYMPTOM_DESC,
    FAULT_TOTAL,
    OLD_VERSION,
    E_MAIL
  ) SELECT
      (xpath('/xml/billno/text()', V_XML)) [1],
      (xpath('/xml/sn/text()', V_XML)) [1],
      '4001',
      (xpath('/xml/custtype/text()', V_XML)) [1],
      (xpath('/xml/custname/text()', V_XML)) [1],
      (xpath('/xml/custtel/text()', V_XML)) [1],
      (xpath('/xml/dealer/text()', V_XML)) [1],
      (xpath('/xml/parttype/text()', V_XML)) [1],
      (xpath('/xml/model/text()', V_XML)) [1],
      (xpath('/xml/pcolor/text()', V_XML)) [1],
      (xpath('/xml/imei/text()', V_XML)) [1],
      upper(((xpath('/xml/pcode/text()'), V_XML)) [1]),
      (xpath('/xml/appearance/text()', V_XML)) [1],
      (xpath('/xml/warranty/text()', V_XML)) [1],
      (xpath('/xml/warea/text()', V_XML)) [1],
      (xpath('/xml/fixtype/text()', V_XML)) [1],
      (xpath('/xml/changetype/text()', V_XML)) [1],
      site01.func_parse_date((xpath('/xml/purdate/text()', V_XML)) [1], NULL),
      (xpath('/xml/invoice/text()', V_XML)) [1],
      (xpath('/xml/invoiceno/text()', V_XML)) [1],
      (xpath('/xml/sid/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/rcid/text()', V_XML)) [1],
      (xpath('/xml/symptom/text()', V_XML)) [1],
      (xpath('/xml/zhengzhuangdesc/text()', V_XML)) [1],
      (xpath('/xml/total_class/text()', V_XML)) [1],
      (xpath('/xml/vserion/text()', V_XML)) [1],
      (xpath('/xml/email/text()', V_XML)) [1];
  EXCEPTION WHEN OTHERS
  THEN
    OUT_DATA := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.UPDATE_ORDERS(IN_DATA IN VARCHAR, OUT_DATA OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

  V_XML XML;
BEGIN
  V_XML := XMLPARSE(DOCUMENT IN_DATA);
  OUT_DATA := 'OK';
  UPDATE site01.bills
  SET
    SN           = upper((xpath('/xml/sn/text()', V_XML)) [1]),
    CUST_NAME    = (xpath('/xml/custname/text()', V_XML)) [1],
    CUST_TEL     = (xpath('/xml/custtel/text()', V_XML)) [1],
    DEALER       = (xpath('/xml/dealer/text()', V_XML)) [1],
    PART_TYPE    = (xpath('/xml/parttype/text()', V_XML)) [1],
    MODEL        = (xpath('/xml/model/text()', V_XML)) [1],
    PCOLOR       = (xpath('/xml/pcolor/text()', V_XML)) [1],
    IMEI         = (xpath('/xml/imei/text()', V_XML)) [1],
    PCODE        = upper(((xpath('/xml/pcode/text()'), V_XML)) [1]),
    APPEARANCE   = (xpath('/xml/appearance/text()', V_XML)) [1],
    WARRANTY     = (xpath('/xml/warranty/text()', V_XML)) [1],
    WAREA        = (xpath('/xml/warea/text()', V_XML)) [1],
    FIX_TYPE     = (xpath('/xml/fixtype/text()', V_XML)) [1],
    CHANGETYPE   = (xpath('/xml/changetype/text()', V_XML)) [1],
    PURDATE      = site01.func_parse_date((xpath('/xml/purdate/text()', V_XML)) [1], NULL),
    --INVOICE= EXTRACTVALUE(V_XML, '/xml/invoice'),
    -- INVOICE_NO=EXTRACTVALUE(V_XML, '/xml/invoiceno'),
    SID          = (xpath('/xml/sid/text()', V_XML)) [1],
    --OPEN_USER=EXTRACTVALUE(V_XML, '/xml/optuser'),
    --OPT_USER= EXTRACTVALUE(V_XML, '/xml/optuser'),
    --RC_ID= EXTRACTVALUE(V_XML, '/xml/rcid'),
    SYMPTOM_CODE = (xpath('/xml/symptom/text()', V_XML)) [1],
    SYMPTOM_DESC = (xpath('/xml/zhengzhuangdesc/text()', V_XML)) [1],
    FAULT_TOTAL  = (xpath('/xml/total_class/text()', V_XML)) [1],
    OLD_VERSION  = (xpath('/xml/vserion/text()', V_XML)) [1],
    E_MAIL       = (xpath('/xml/email/text()', V_XML)) [1]
  WHERE bill_no = (xpath('/xml/billno/text()', V_XML)) [1];
  EXCEPTION WHEN OTHERS
  THEN
    OUT_DATA := 'Exception';
END;
$$;

CREATE OR REPLACE FUNCTION site01.AssignEng(in_bill_id  IN  VARCHAR,
                                            in_engid    IN  VARCHAR,
                                            in_opt_user IN  VARCHAR,
                                            out_ret     OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  UPDATE site01.bills
  SET status        = '4002',
    ASSIGN_ENGINEER = in_engid,
    FIX_ENGINEER    = in_engid,
    opt_user        = in_opt_user,
    opt_date        = now()
  WHERE bill_no = in_bill_id
        AND status = '4001';
  IF found
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
    out_ret := 'Stock in use, please apply new one';
  END IF;

  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.insert_part_list(in_bill_id  IN  VARCHAR,
                                                   in_pn       IN  VARCHAR,
                                                   in_PART_SN  IN  VARCHAR,
                                                   in_name     IN  VARCHAR,
                                                   in_desc     IN  VARCHAR,
                                                   in_userid   IN  VARCHAR,
                                                   in_chanid   IN  VARCHAR,
                                                   in_stock_id IN  VARCHAR,
                                                   in_ovo_flag IN  VARCHAR,
                                                   out_ret     OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_cont INTEGER;
BEGIN

  SELECT count(1)
  INTO v_cont
  FROM parts
  WHERE send_stock_id = in_stock_id;
  IF v_cont > 0
  THEN
    --out_ret := '�����ʹ�ã���ֱ���걸��!';
    out_ret := 'Stock in use, please apply new one';
    RETURN;
  END IF;


  INSERT INTO site01.parts
  (PARTS_ID,
   BILL_ID,
   STATUS,
   PN,
   STN_CODE,
   PART_SN,
   PART_NAME,
   PART_DES,
   REQ_DATE,
   send_stock_id,
   OVO_FLAG,
   REQ_USER
  )
  VALUES
    (nextval('site01.seq_part_list_id' :: REGCLASS),
      in_bill_id,
      '8001',
      in_pn,
      in_chanid,
      in_PART_SN,
      in_name,
      in_desc,
      now(),
      in_stock_id,
      in_ovo_flag,
     in_userid
    );

  IF found
  THEN
    UPDATE site01.bills
    SET status = '4003'
    WHERE bill_no = in_bill_id;
    IF in_stock_id IS NOT NULL
    THEN
      UPDATE site01.stock_list
      SET status = 'F', opt_date = now(), opt_user = in_userid
      WHERE stock_id = in_stock_id AND status = 'N' AND pn_no = in_pn;
      IF FOUND
      THEN

        out_ret := 'OK';
      ELSE
        --out_ret := '��汣�治�ɹ�!';
        out_ret := 'Stock Save Failed';
      END IF;
    ELSE
      out_ret := 'OK';
    END IF;
  ELSE
    --out_ret := '���汸�����ɹ�!';
    out_ret := 'Parts save failed';
  END IF;
  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'Exception';
END;
$$;

CREATE OR REPLACE FUNCTION site01.Test_Fix(in_bill_id   IN  VARCHAR,
                                           in_eng2      IN  VARCHAR,
                                           in_test_code IN  VARCHAR,
                                           in_fix_code  IN  VARCHAR,
                                           in_test_desc IN  VARCHAR,
                                           in_eng3      IN  VARCHAR,
                                           in_fix_desc  IN  VARCHAR,
                                           in_is_end    IN  VARCHAR,
                                           in_fix_res   IN  VARCHAR,
                                           in_opt_user  IN  VARCHAR,
                                           in_version   IN  VARCHAR,
                                           in_gimei     IN  VARCHAR,
                                           out_ret      OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

  UPDATE site01.bills
  SET
    engineer2   = in_eng2,
    test_code   = in_test_code,
    fix_code    = in_fix_code,
    test_Desc   = in_test_desc,
    engineer3   = in_eng3,
    fix_desc    = in_fix_desc,
    fix_result  = in_fix_res,
    opt_user    = in_opt_user,
    opt_date    = now(),
    NEW_VERSION = in_version,
    GIMEI       = in_gimei
  WHERE bill_no = in_bill_id;
  -- and status in ('4002');
  IF in_is_end = 'Y'
  THEN

    UPDATE site01.bills
    SET is_end = 'Y',
      status   = '4004',
      fix_date = now()
    WHERE bill_no = in_bill_id;
  --  and status in ('4003');
  END IF;
  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�1!';
    out_ret := 'Order not exists or status changed';
  END IF;

  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;


CREATE OR REPLACE FUNCTION site01.GetOut(in_bill_id   IN  VARCHAR,
                                         in_engid     IN  VARCHAR,
                                         in_is_satify IN  VARCHAR,
                                         in_addvise   IN  VARCHAR,
                                         in_getmemo   IN  VARCHAR,
  -- in_get_date in varchar,
                                         in_opt_user  IN  VARCHAR,
                                         in_fix_money IN  VARCHAR,

                                         out_ret      OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

  UPDATE bills
  SET status    = '4005',
    end_user    = in_engid,
    is_satify   = in_is_satify,
    cust_advice = in_addvise,
    getout_memo = in_getmemo,
    end_date    = now(),
    opt_user    = in_opt_user,
    opt_date    = now(),
    fix_money   = in_fix_money
  WHERE bill_no = in_bill_id
        AND status = '4004';
  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�2!';
    out_ret := 'Order not exists or status changed';
  END IF;

  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;

CREATE OR REPLACE FUNCTION site01.UPLOADINF(IN_PN_NO    IN  VARCHAR,
                                            IN_IMEI     IN  VARCHAR,
                                            IN_memo     IN  VARCHAR,
                                            in_QTY      IN  VARCHAR,
                                            IN_OPT_USER IN  VARCHAR,
                                            IN_TRACE_NO IN  VARCHAR,
                                            OUT_R       OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  IF IN_IMEI IS NOT NULL
  THEN
    IF NOT site01.CHECK_SN_UPLOAD(IN_IMEI)
    THEN
      --OUT_R := 'IMEI�ظ��ϴ�--' || IN_IMEI;
      OUT_R := 'Duplicated IMEI' || IN_IMEI;
      RETURN;
    END IF;
  END IF;
  IF IN_PN_NO IS NULL
  THEN
    --OUT_R := 'PN����Ϊ��--' || IN_PN_NO;
    OUT_R := 'PN IS EMPTY';
    RETURN;
  END IF;
  IF in_QTY IS NULL
  THEN
    --OUT_R := '��������Ϊ��--' || in_QTY;
    OUT_R := 'QTY IS EMPTY';
    RETURN;
  END IF;
  IF IN_TRACE_NO IS NULL
  THEN
    --OUT_R := '�˵��Ų���Ϊ��--' || IN_TRACE_NO;
    OUT_R := 'TRACE NO IS EMPTY';
    RETURN;
  END IF;
  INSERT INTO UPLOAD_INF
  (ID, PN_NO, IMEI, QTY, OPT_USER, OPT_DATE, TRACE_NO, CHAN_ID, MEMO)
  VALUES
    (nextval('site01.seq_stock_id' :: REGCLASS), IN_PN_NO, IN_IMEI, in_QTY, IN_OPT_USER, SYSDATE, IN_TRACE_NO, '100',
     IN_memo);
  IF FOUND
  THEN
    OUT_R := 'error';
    RETURN;
  END IF;
  OUT_R := 'OK';
  EXCEPTION
  WHEN OTHERS
    THEN
      OUT_R := 'SQLERRM';
END;
$$;


CREATE OR REPLACE FUNCTION site01.uploadinf_new(IN_PN_NO    IN  VARCHAR,
                                                IN_IMEI     IN  VARCHAR,
                                                IN_memo     IN  VARCHAR,
                                                in_QTY      IN  VARCHAR,
                                                IN_OPT_USER IN  VARCHAR,
                                                IN_TRACE_NO IN  VARCHAR,
                                                OUT_R       OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  IF IN_IMEI IS NOT NULL
  THEN
    IF NOT CHECK_SN_UPLOAD(IN_IMEI)
    THEN
      --OUT_R := 'IMEI�ظ��ϴ�--' || IN_IMEI;
      OUT_R := 'Duplicated IMEI' || IN_IMEI;
      RETURN;
    END IF;
  END IF;
  IF IN_PN_NO IS NULL
  THEN
    --OUT_R := 'PN����Ϊ��--' || IN_PN_NO;
    OUT_R := 'PN IS EMPTY';
    RETURN;
  END IF;
  IF in_QTY IS NULL
  THEN
    --OUT_R := '��������Ϊ��--' || in_QTY;
    OUT_R := 'QTY IS EMPTY';
    RETURN;
  END IF;
  IF IN_TRACE_NO IS NULL
  THEN
    --OUT_R := '�˵��Ų���Ϊ��--' || IN_TRACE_NO;
    OUT_R := 'TRACE NO IS EMPTY';
    RETURN;
  END IF;
  INSERT INTO UPLOAD_INF
  (ID, PN_NO, IMEI, QTY, OPT_USER, OPT_DATE, TRACE_NO, CHAN_ID, MEMO)
  VALUES
    (nextval('site01.seq_stock_id' :: REGCLASS), IN_PN_NO, IN_IMEI, in_QTY, IN_OPT_USER, SYSDATE, IN_TRACE_NO, '157',
     IN_memo);
  IF FOUND
  THEN
    OUT_R := 'error';
    RETURN;
  END IF;
  OUT_R := 'OK';
  EXCEPTION
  WHEN OTHERS
    THEN
      OUT_R := 'SQLERRM';
END;
$$;

CREATE OR REPLACE FUNCTION site01.Back_Part(in_bill_id    IN  VARCHAR,
                                            in_back_class IN  VARCHAR,
                                            in_opt_user   IN  VARCHAR,
                                            in_part_id    IN  VARCHAR,
                                            out_ret       OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_send_stock_id VARCHAR(32);
BEGIN
  IF in_back_class = '1302' OR in_back_class = '1303'
  THEN

    UPDATE site01.parts
    SET status      = '8001',
      send_flag     = NULL,
      send_date     = NULL,
      send_stock_id = '',
      back_date     = NULL,
      back_type     = in_back_class,
      back_flag     = 'Y',
      opt_user      = in_opt_user,
      opt_date      = now()
    WHERE bill_id = in_bill_id
          AND parts_id = in_part_id;
    UPDATE stock_list
    SET status = 'N', opt_date = now(), opt_user = in_opt_user
    WHERE stock_id = v_send_stock_id;
  ELSE

    SELECT send_stock_id
    INTO v_send_stock_id
    FROM site01.parts
    WHERE parts_id = in_part_id;
    UPDATE parts p
    SET status    = '8003',
      p.back_flag = 'Y',
      p.back_date = now(),
      p.back_type = '1301',
      opt_user    = in_opt_user,
      opt_date    = now()
    WHERE bill_id = in_bill_id
          AND parts_id = in_part_id
          AND status = '8002'
          AND send_flag = 'Y';

    UPDATE stock_list
    SET status = 'Y', opt_date = now(), opt_user = in_opt_user
    WHERE stock_id = v_send_stock_id;

  END IF;

  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
    out_ret := 'Order not exists or status changed';
  END IF;

  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;

CREATE OR REPLACE FUNCTION site01.OPEN_ORDERS_NEW(IN_DATA  IN  VARCHAR,
                                                  OUT_DATA OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  V_XML XML;
BEGIN
  V_XML := XMLPARSE(DOCUMENT IN_DATA);
  OUT_DATA := 'OK';
  INSERT INTO site01.bills
  (
    BILL_NO,
    SN,
    STATUS,
    CUST_TYPE,
    CUST_NAME,
    CUST_TEL,
    DEALER,
    PART_TYPE,
    MODEL,
    --PCOLOR,
    --IMEI,
    --PCODE,
    APPEARANCE,
    WARRANTY,
    WAREA,
    FIX_TYPE,
    --CHANGETYPE,
    PURDATE,
    INVOICE,
    INVOICE_NO,
    --SID,
    OPEN_USER,
    OPT_USER,
    RC_ID,
    SYMPTOM_CODE,
    SYMPTOM_DESC,
    --FAULT_TOTAL,
    OLD_VERSION,
    E_MAIL,
    M_USE_HOUSE,
    D_USE_HOUSE,
    M_LIGHT,
    m_type
  ) SELECT
      (xpath('/xml/billno/text()', V_XML)) [1],
      (xpath('/xml/sn/text()', V_XML)) [1],
      '4001',
      (xpath('/xml/custtype/text()', V_XML)) [1],
      (xpath('/xml/custname/text()', V_XML)) [1],
      (xpath('/xml/custtel/text()', V_XML)) [1],
      (xpath('/xml/dealer/text()', V_XML)) [1],
      (xpath('/xml/parttype/text()', V_XML)) [1],
      (xpath('/xml/model/text()', V_XML)) [1],
      --(xpath('/xml/pcolor/text()', V_XML)) [1],
      --(xpath('/xml/imei/text()', V_XML)) [1],
      --upper(((xpath('/xml/pcode/text()'), V_XML))[1]),
      (xpath('/xml/appearance/text()', V_XML)) [1],
      (xpath('/xml/warranty/text()', V_XML)) [1],
      (xpath('/xml/warea/text()', V_XML)) [1],
      (xpath('/xml/fixtype/text()', V_XML)) [1],
      --(xpath('/xml/changetype/text()', V_XML)) [1],
      site01.func_parse_date((xpath('/xml/purdate/text()', V_XML)) [1], NULL),
      (xpath('/xml/invoice/text()', V_XML)) [1],
      (xpath('/xml/invoiceno/text()', V_XML)) [1],
      --(xpath('/xml/sid/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/rcid/text()', V_XML)) [1],
      --(xpath('/xml/symptom/text()', V_XML)) [1],
      (xpath('/xml/total_class/text()', V_XML)) [1],
      (xpath('/xml/zhengzhuangdesc/text()', V_XML)) [1],
      (xpath('/xml/vserion/text()', V_XML)) [1],
      (xpath('/xml/email/text()', V_XML)) [1],
      (xpath('/xml/m_use_house/text()', V_XML)) [1],
      (xpath('/xml/d_use_house/text()', V_XML)) [1],
      (xpath('/xml/m_light/text()', V_XML)) [1],
      (xpath('/xml/m_type/text()', V_XML)) [1];
  EXCEPTION WHEN OTHERS
  THEN
    OUT_DATA := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.OPEN_dealer_open(IN_DATA  IN  VARCHAR,
                                                   OUT_DATA OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

  V_XML XML;
BEGIN
  V_XML := XMLPARSE(DOCUMENT IN_DATA);
  OUT_DATA := 'OK';
  INSERT INTO BILLS_DEALER
  (
    BILL_NO,
    SN,
    STATUS,
    PART_TYPE,
    MODEL,
    APPEARANCE,
    WARRANTY,
    PURDATE,
    CHAN_ID,
    GU_CLASS,
    GU_DESC,
    M_HOUR,
    D_HOUR,
    m_type,
    SEND_DATE,
    SEND_TRACE_NO,
    SEND_TRACE_NAME,
    SEND_USER_ID
  )
    SELECT
      (xpath('/xml/billno/text()', V_XML)) [1],
      (xpath('/xml/sn/text()', V_XML)) [1],
      '6001',
      (xpath('/xml/parttype/text()', V_XML)) [1],
      (xpath('/xml/model/text()', V_XML)) [1],
      (xpath('/xml/appearance/text()', V_XML)) [1],
      (xpath('/xml/warranty/text()', V_XML)) [1],
      site01.func_parse_date((xpath('/xml/purdate/text()', V_XML)) [1], NULL),
      (xpath('/xml/rcid/text()', V_XML)) [1],
      --(xpath('/xml/symptom/text()', V_XML)) [1],
      (xpath('/xml/total_class/text()', V_XML)) [1],
      (xpath('/xml/zhengzhuangdesc/text()', V_XML)) [1],
      (xpath('/xml/m_use_house/text()', V_XML)) [1],
      (xpath('/xml/d_use_house/text()', V_XML)) [1],
      (xpath('/xml/m_type/text()', V_XML)) [1],
      now(),
      (xpath('/xml/traceno/text()', V_XML)) [1],
      (xpath('/xml/tracename/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1];
  EXCEPTION WHEN OTHERS
  THEN
    OUT_DATA := 'Exception';
END;
$$;

CREATE OR REPLACE FUNCTION site01.First_Test_Fix(in_bill_id     IN  VARCHAR,
                                                 in_eng2        IN  VARCHAR,
                                                 in_test_code   IN  VARCHAR,
                                                 in_test_desc   IN  VARCHAR,
                                                 in_m_nbr       IN  VARCHAR,
                                                 in_d_nbr       IN  VARCHAR,
                                                 in_m_hour      IN  VARCHAR,
                                                 in_d_hour      IN  VARCHAR,
                                                 in_power_on    IN  VARCHAR,
                                                 in_power_off   IN  VARCHAR,
                                                 in_test_result IN  VARCHAR,
                                                 in_is_end      IN  VARCHAR,
                                                 in_opt_user    IN  VARCHAR,
                                                 out_ret        OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

  UPDATE site01.bills
  SET
    engineer2   = in_eng2,
    test_code   = in_test_code,
    test_Desc   = in_test_desc,
    M_NBR       = in_m_nbr,
    D_NBR       = in_d_nbr,
    M_USE_HOUSE = in_m_hour,
    D_USE_HOUSE = in_d_hour,
    POWER_ON    = in_power_on,
    POWER_OFF   = in_power_off,
    TEST_RESULT = in_test_result,
    IS_END      = in_is_end,
    opt_user    = in_opt_user,
    opt_date    = now()
  WHERE bill_no = in_bill_id;
  -- and status in ('4002');
  IF in_is_end = 'Y'
  THEN

    UPDATE bills
    SET is_end = 'Y',
      status   = '4004',
      fix_date = now()
    WHERE bill_no = in_bill_id;
  --  and status in ('4003');
  END IF;
  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�1!';
    out_ret := 'Order not exists or status changed';
  END IF;
  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;


CREATE OR REPLACE FUNCTION site01.Sencond_Test_Fix(in_bill_id   IN  VARCHAR,
                                                   in_eng3      IN  VARCHAR,
                                                   in_fix_code  IN  VARCHAR,
                                                   in_fix_desc  IN  VARCHAR,
                                                   in_is_end    IN  VARCHAR,
                                                   in_fix_nbr   IN  VARCHAR,
                                                   in_fix_light IN  VARCHAR,
                                                   in_opt_user  IN  VARCHAR,
                                                   out_ret      OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

  UPDATE site01.bills
  SET
    engineer3 = in_eng3,
    FIX_CODE  = in_fix_code,
    FIX_DESC  = in_fix_desc,
    FIX_NBR   = in_fix_nbr,
    FIX_LIGHT = in_fix_light,
    IS_END    = in_is_end,
    opt_user  = in_opt_user,
    opt_date  = now()
  WHERE bill_no = in_bill_id;
  -- and status in ('4002');
  IF in_is_end = 'Y'
  THEN

    UPDATE bills
    SET is_end = 'Y',
      status   = '4004',
      fix_date = now()
    WHERE bill_no = in_bill_id;
  --  and status in ('4003');
  END IF;
  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    out_ret := 'Order not exists or status changed';
  END IF;
  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;

CREATE OR REPLACE FUNCTION site01.insert_part_list_app(in_bill_id  IN  VARCHAR,
                                                       in_pn       IN  VARCHAR,
                                                       in_PART_SN  IN  VARCHAR,
                                                       in_name     IN  VARCHAR,
                                                       in_desc     IN  VARCHAR,
                                                       in_userid   IN  VARCHAR,
                                                       in_chanid   IN  VARCHAR,
                                                       in_stock_id IN  VARCHAR,
                                                       in_ovo_flag IN  VARCHAR,
                                                       out_ret     OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_cont INTEGER;
BEGIN

  SELECT count(1)
  INTO v_cont
  FROM site01.parts
  WHERE send_stock_id = in_stock_id;
  IF v_cont > 0
  THEN
    --out_ret := '�����ʹ�ã���ֱ���걸��!';
    out_ret := 'Stock in use, please apply new one';
    RETURN;
  END IF;


  INSERT INTO parts
  (PARTS_ID,
   BILL_ID,
   STATUS,
   PN,
   STN_CODE,
   PART_SN,
   PART_NAME,
   PART_DES,
   REQ_DATE,
   send_stock_id,
   OVO_FLAG,
   REQ_USER
  )
  VALUES
    (nextval('site01.seq_part_list_id' :: REGCLASS),
      in_bill_id,
      '8000',
      in_pn,
      in_chanid,
      in_PART_SN,
      in_name,
      in_desc,
      now(),
      in_stock_id,
      in_ovo_flag,
     in_userid
    );

  IF FOUND
  THEN
    UPDATE bills
    SET status = '4003'
    WHERE bill_no = in_bill_id;
    IF in_stock_id IS NOT NULL
    THEN
      UPDATE stock_list
      SET status = 'F', opt_date = now(), opt_user = in_userid
      WHERE stock_id = in_stock_id AND status = 'N' AND pn_no = in_pn;
      IF FOUND
      THEN

        out_ret := 'OK';
      ELSE
        --out_ret := '��汣�治�ɹ�!';
        out_ret := 'Stock save failed';
      END IF;
    ELSE
      out_ret := 'OK';
    END IF;
  ELSE
    --out_ret := '���汸�����ɹ�!';
    out_ret := 'Parts save failed';
  END IF;
  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;

CREATE OR REPLACE FUNCTION site01.fix_station_rvc(
  in_bill_id     IN  VARCHAR,
  in_memo        IN  VARCHAR,
  in_app_flag    IN  VARCHAR,
  in_opt_user    IN  VARCHAR,
  in_bill_status IN  VARCHAR,
  out_ret        OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  UPDATE site01.bills_dealer p
  SET status    = in_bill_status,
    RVC_USER_ID = in_opt_user,
    RVC_DATE    = now(),
    RVC_MEMO    = in_memo,
    RVC_FLAG    = in_app_flag
  WHERE bill_no = in_bill_id
        AND status = '6001';

  --dbms_output.put_line('2��'||sql%rowcount );
  IF FOUND
  THEN
    out_ret := 'OK';
  ELSE
    --out_ret := '�ջ�ʧ��';
    out_ret := 'Receiving failed';
  END IF;
  EXCEPTION
  WHEN OTHERS
    THEN
      out_ret := 'sqlerrm';
END;
$$;

CREATE OR REPLACE FUNCTION site01.update_dealer_RVC(
  in_bill_id     IN  VARCHAR,
  in_opt_user    IN  VARCHAR,
  in_bill_status IN  VARCHAR,
  out_ret        OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  BEGIN
    UPDATE site01.bills_dealer p
    SET status           = in_bill_status,
      DEALER_RVC_USER_ID = in_opt_user,
      DEALER_RVC_DATE    = now()
    WHERE bill_no = in_bill_id;
    -- and status = '6001';

    --dbms_output.put_line('2��'||sql%rowcount );
    IF FOUND
    THEN
      out_ret := 'OK';
    ELSE
      out_ret := 'Receiving failed';
    END IF;
    EXCEPTION
    WHEN OTHERS
      THEN
        out_ret := 'sqlerrm';
  END;
$$;

CREATE OR REPLACE FUNCTION site01.GetOutStation(in_bill_id   IN  VARCHAR,
                                                in_engid     IN  VARCHAR,
                                                in_is_satify IN  VARCHAR,
                                                in_addvise   IN  VARCHAR,
                                                in_getmemo   IN  VARCHAR,
                                                in_opt_user  IN  VARCHAR,
                                                in_fix_money IN  VARCHAR,
                                                in_billtype  IN  VARCHAR,
                                                in_traceno   IN  VARCHAR,
                                                in_tracename IN  VARCHAR,
                                                out_ret      OUT VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  UPDATE bills
  SET status    = '4005',
    end_user    = in_engid,
    is_satify   = in_is_satify,
    cust_advice = in_addvise,
    getout_memo = in_getmemo,
    end_date    = now(),
    opt_user    = in_opt_user,
    opt_date    = now(),
    fix_money   = in_fix_money
  WHERE bill_no = in_bill_id
        AND status = '4004';

  IF FOUND
  THEN
    IF in_billtype = 'D'
    THEN
      UPDATE bills_dealer
      SET RETURN_DATE     = now(),
        RETURN_USER_ID    = in_opt_user,
        RETURN_TRACE_NO   = in_traceno,
        RETURN_TRACE_NAME = in_tracename
      WHERE bill_no = in_bill_id;
    END IF;
    out_ret := 'OK';
  ELSE
    --out_ret := 'ά�޵������ڻ���״̬�Ѹı�2!';
    out_ret := 'Order not exists or status changed';
  END IF;
  EXCEPTION  WHEN OTHERS
    THEN
      out_ret := 'Exception';

END;
$$;