/* alter scripts*/
CREATE OR REPLACE FUNCTION site01.OPEN_ORDERS_NEW(IN_DATA  IN  VARCHAR(1000),
                                                  OUT_DATA OUT VARCHAR(1000))
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  V_XML XML;
  v_date DATE;
  v_purdate VARCHAR;
BEGIN
  V_XML := XMLPARSE(DOCUMENT IN_DATA);
  OUT_DATA := 'OK';
  v_purdate:=(xpath('/xml/purdate/text()', V_XML)) [1];
  v_date = site01.func_parse_date(v_purdate,null);
  INSERT INTO site01.bills
  ( BILL_NO,
    SN,
    STATUS,
    CUST_TYPE,
    CUST_NAME,
    CUST_TEL,
    DEALER,
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
      (xpath('/xml/model/text()', V_XML)) [1],
      (xpath('/xml/appearance/text()', V_XML)) [1],
      (xpath('/xml/warranty/text()', V_XML)) [1],
      v_date,
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/optuser/text()', V_XML)) [1],
      (xpath('/xml/rcid/text()', V_XML)) [1],
      (xpath('/xml/symptom/text()', V_XML)) [1],
      (xpath('/xml/zhengzhuangdesc/text()', V_XML)) [1],
      (xpath('/xml/email/text()', V_XML)) [1],
      (xpath('/xml/m_use_house/text()', V_XML)) [1],
      (xpath('/xml/d_use_house/text()', V_XML)) [1],
      (xpath('/xml/m_light/text()', V_XML)) [1],
      (xpath('/xml/m_type/text()', V_XML)) [1];

  /*EXCEPTION WHEN OTHERS
  THEN
    OUT_DATA := 'Exception:';*/
END;
$$
;

