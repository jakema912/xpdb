/* Create all Functions*/

CREATE OR REPLACE FUNCTION site01.func_get_simple(in_id IN VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret VARCHAR(128);
BEGIN
  SELECT name
  INTO v_ret
  FROM site01.dic_simple
  WHERE id = in_id;
  RETURN v_ret;
  EXCEPTION
  WHEN OTHERS
    THEN
      RETURN 'N/A';
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_is_open(in_imei IN VARCHAR, in_sn IN VARCHAR)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  --local variable
  v_ret VARCHAR(128);
  vcnt  INTEGER;
  vct   INTEGER;
BEGIN
  IF in_imei IS NOT NULL
  THEN
    SELECT count(1)
    INTO vcnt
    FROM site01.bills
    WHERE imei = in_imei AND status IN ('5001', '5002', '5003');
    IF vcnt > 0
    THEN
      v_ret := 'Y';
    ELSE
      v_ret := 'N';
    END IF;
  END IF;
  IF in_sn IS NOT NULL
  THEN
    SELECT count(1)
    INTO vct
    FROM site01.bills
    WHERE sn = in_sn
          AND status IN ('5001', '5002', '5003');
    IF vct > 0
    THEN
      v_ret := 'Y';
    ELSE
      v_ret := 'N';
    END IF;
  END IF;
  RETURN v_ret;
  EXCEPTION
  WHEN OTHERS
    THEN
      RETURN 'N/A';
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_chan_name(in_chanid in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  --local variable
   v_ret varchar(128);
BEGIN
 select chan_name into v_ret from site01.chan_inf where chan_id = in_chanid;
    return v_ret;
  exception
    when others then
      return in_chanid;
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_username(in_userid in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  --local variable
   v_ret varchar(128);
BEGIN
    select user_name into v_ret from site01.users_inf where user_id = in_userid;
    return v_ret;
  exception
    when others then
      return in_userid;
END;
$$;

/*
CREATE OR REPLACE FUNCTION site01.func_get_fault(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select fault_code||'-'||fault_description into v_ret from site01.FAULT_CLASS where fault_code = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
END;
$$;
*/

/*
CREATE OR REPLACE FUNCTION site01.func_get_fault_name(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select fault_description into v_ret from site01.FAULT_CLASS where fault_code = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
END;
$$;
*/

CREATE OR REPLACE FUNCTION site01.func_get_GU_name(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
    select GU_DESC into v_ret from site01.GU_ZHANG_INF where GU_ID = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_part_sendflag(in_bill_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
  vcont integer;
BEGIN
    select count(1) into vcont from site01.parts
    where bill_id = in_bill_id and send_pn is null ;
    if vcont=0 then
      v_ret:='N';
      else
       v_ret:='Y';
       end if;
    return v_ret;
  exception
    when others then
      return in_bill_id;
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_part_back_type(in_bill_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
  vcont integer;
BEGIN
select count(1) into vcont from site01.parts  where bill_id = in_bill_id and back_type is null ;
    if vcont=0 then
      v_ret:='N';
      else
       v_ret:='Y';
       end if;
    return v_ret;
  exception
    when others then
      return in_bill_id;
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_pats_name(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
   v_ret varchar(1024);
BEGIN
select concat(pn||'-'||part_name)  into v_ret
from site01.parts where bill_id= in_code;
    return v_ret;
  exception
    when others then
      return '-';
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_pats_send_qty(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
    v_cnt integer;
    v_cns integer;
BEGIN
 select count(1) into v_cns from site01.parts where bill_id=in_code;
    select count(1) into v_cnt from site01.parts where bill_id=in_code and send_flag='N' ;
    if v_cnt=v_cns then
      v_ret:='NOT SENT';
     else
     if v_cnt<v_cns then
       if v_cnt=0 then
         v_ret:='SENT';
         else
         v_ret:='PARTIAL SENT';
       end if;
     else
         v_ret:='PARTIAL SENT';
     end if;
   end if;
    return v_ret;
  exception
    when others then
      return in_code;
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_pats_send_flag(in_code in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
   v_ret varchar(128);
    v_cnt integer;
BEGIN
select count(1) into v_cnt from site01.parts where bill_id=in_code  ;
    if v_cnt>0 then
      v_ret:='Y';
      else
       v_ret:='N';
        end if;
    return v_ret;
  exception
    when others then
      return in_code;
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_zong_send_date(in_send_stock_id INTEGER,IN_BILL_ID IN varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.stock_list_log
     where stock_id = in_send_stock_id
       and new_STATUS = 'T'
       AND OLD_CHAN_ID = '100';
    return v_ret;
  exception
    when others then
      return 'N/A';
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_station_rvc_date(in_send_stock_id in INTEGER,IN_BILL_ID IN varchar,in_chan_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.stock_list_log
     where stock_id = in_send_stock_id
       and new_STATUS = 'N'
       AND new_CHAN_ID = in_chan_id;
    return v_ret;
  exception
    when others then
      return 'N/A';
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_bad_station_back_date(in_part_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.bad_stock_list
     where parts_id = in_part_id;
    return v_ret;
  exception
    when others then
      return  'N/A';
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_bad_zong_rvc_date(in_part_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select to_char(rvc_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.bad_stock_list
     where parts_id = in_part_id;
    return v_ret;
  exception
    when others then
      return 'N/A';
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_GOOD_station_date(IN_STOCK_ID in INTEGER,in_chan_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.stock_list_log
     where STOCK_ID = IN_STOCK_ID AND NEW_STATUS='H' AND OLD_STATUS='N' and old_chan_id=in_chan_id;
    return v_ret;
  exception
    when others then
      return  'N/A';
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_get_good_rvc_date(IN_STOCK_ID in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
 select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from site01.stock_list_log
     where STOCK_ID = IN_STOCK_ID AND NEW_STATUS='N' AND OLD_STATUS='H' and new_chan_id='100';
    return v_ret;
  exception
    when others then
      return 'N/A';
END;
$$;


CREATE OR REPLACE FUNCTION site01.func_get_arearname(in_chan_id in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
select area into v_ret from site01.chan_inf where chan_id = in_chan_id;
    return v_ret;
  exception
    when others then
      return '';
END;
$$;

/*
CREATE OR REPLACE FUNCTION site01.CHECK_imei_UPLOAD(IN_imei in varchar)
  RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE
   v_cnt integer;
BEGIN
SELECT COUNT(1)
      INTO v_cnt
      FROM site01.imei_inf
     WHERE imei_main = IN_imei;
    IF v_cnt = 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END;
$$;
*/

CREATE OR REPLACE FUNCTION site01.CHECK_SN_UPLOAD(IN_imei in varchar)
  RETURNS BOOLEAN LANGUAGE plpgsql AS $$
DECLARE
   v_cnt integer;
BEGIN
SELECT COUNT(1)
      INTO v_cnt
      FROM site01.upload_inf
     WHERE IMEI = IN_imei;
    IF v_cnt = 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION site01.func_parse_date(v_date in varchar,v_format in varchar)
   RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
  if v_date is null or trim(v_date)='' then
    return null;
  ELSEIF v_format is not NULL THEN
    return to_date(v_date,v_format);
  ELSE
    return to_date(v_date,'yyyy-mm-dd');
  end if;
END;
$$

CREATE OR REPLACE FUNCTION site01.func_get_stock_count(in_pn_no in varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
  vcont integer;
BEGIN
    select count(1) into vcont from site01.stock_list
    where pn_no = in_pn_no and status='N' and chan_id='157' ;
    v_ret:=vcont;
    return v_ret;
  exception
    when others then
      return in_bill_id;
END;
$$;

