create or replace trigger "TRIGGERS_BILL_DEALER"
   before INSERT OR UPDATE on bills_dealer
  for each row
declare
  -- local variables here
  v_custname varchar2(32);
  v_cust_tel varchar2(32);
begin
   IF :NEW.STATUS = '6002' AND :OLD.STATUS = '6001' then
   select chan_name,TEL into v_custname,v_cust_tel ¡¡from chan_inf where chan_id=:new.chan_id ;
    insert into bills
      ( BILL_NO,
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
    values
      (:new.bill_no,
       :new.sn,
      '4001',
      'GS',
      v_custname,
      v_cust_tel,
      v_custname,
      :new.PART_TYPE,
      :new.MODEL,
      :new.APPEARANCE,
      :new.WARRANTY,
      :new.PURDATE,
      :new.RVC_USER_ID,
      :new.RVC_USER_ID,
      :new.RVC_CHAN_ID,
      :new.GU_CLASS,
      :new.GU_DESC,
      '',
      :new.M_HOUR,
      :new.D_HOUR,
       :new.M_TYPE,
       'D');
   end if;
end TRIGGERS_BILL_DEALER;
/
