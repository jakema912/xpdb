/* Create all Functions*/

CREATE OR REPLACE FUNCTION site01.zong_send_part(in_stock_id   IN varchar,
                     in_imei      IN varchar,
                     in_opt_user  in varchar,
                     in_chan_id varchar,
                     in_trace_no varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
if in_imei is null then
    update site01.STOCK_LIST
       set
           status    = 'T',
           chan_id     = in_chan_id,
           OPT_USER     = in_opt_user,
           SEND_TRACE_NO =in_trace_no,
           OPT_DATE    = now()
     where stock_id = in_stock_id
       and status ='N' ;
  else
    update site01.STOCK_LIST
       set
           status    = 'T',
           chan_id     = in_chan_id,
          opt_user     = in_opt_user,
          SEND_TRACE_NO =in_trace_no,
          OPT_DATE     = now()
     where stock_id = in_stock_id
       and imei=in_imei
       and status ='N' ;
    end if;

    if FOUND then
      out_ret := 'OK';
    else
      --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
      out_ret := 'Order not exists or status has changed';
    end if;

  exception
    when others then
      out_ret := 'EXCEPTION';
END;
$$;


CREATE OR REPLACE FUNCTION site01.station_rvc_part(in_stock_id   IN varchar,
                     in_opt_user  in varchar,
                     in_chan_id varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_cnt integer;
BEGIN
select count(1) into v_cnt from site01.parts where send_stock_id=in_stock_id;
  if v_cnt>0 then

  update site01.STOCK_LIST
       set
           status    = 'V',
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
  end if;
  if v_cnt=0 then
    update site01.STOCK_LIST
       set
           status    = 'N',
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
 end if;
    if FOUND then
      out_ret := 'OK';
    else
      out_ret := 'Order not exists or status changed';
    end if;

  exception
    when others then
      out_ret := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.Station_Send_Part(in_stock_id   IN varchar,
                      in_parts_id in varchar,
                      in_bill_id in varchar,
                      in_pn in varchar,
                      in_sn in varchar,
                     in_opt_user  in varchar,
                     in_chan_id varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

      update site01.parts
       set
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=now(),
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()

          --send_stock_id=in_stock_id
     where PARTS_ID = in_parts_id
       and status ='8001' and BILL_ID=in_bill_id and stn_code=in_chan_id ;

    if FOUND then
      out_ret := 'OK';
    else
      --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
      out_ret := 'Order not exists or status changed';
    end if;

  exception
    when others then
      out_ret := 'Exception';
END;
$$;

CREATE OR REPLACE FUNCTION site01.Station_Send_Part_fei(in_stock_id   IN varchar,
                      in_parts_id in varchar,
                      in_bill_id in varchar,
                      in_pn in varchar,
                      in_sn in varchar,
                     in_opt_user  in varchar,
                     in_chan_id in  varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

      update site01.parts
       set
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=now(),
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where PARTS_ID = in_parts_id
       and status ='8001' and BILL_ID=in_bill_id and stn_code=in_chan_id and  send_stock_id=in_stock_id;

    if found then
     update site01.stock_list
        set status = 'F', opt_date = now(), opt_user = in_opt_user
      where stock_id = in_stock_id
        and status = 'V'
        and chan_id = in_chan_id;
       if FOUND then
       out_ret := 'OK';
      else
        --out_ret := '���������,�����·���!';
         out_ret :='Inventory update failed, resend please';
      end if;
    else
      --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
      out_ret := 'Order not exists or status changed';
    end if;

  exception
    when others then
      out_ret := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.station_bad_part(in_parts_id in varchar,
                             in_bill_id  in varchar,
                             in_pn       in varchar,
                             in_sn       in varchar,
                             in_imei     in varchar,
                             in_opt_user in varchar,
                             in_chan_id in   varchar,
                             in_trace_no in varchar,
                             in_trace_name in varchar,
                             out_ret     OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN

    update site01.parts p
       set status = '8004',
           GET_FLAG = 'Y',
           get_date = now(),
           get_eng = in_opt_user,
           OPT_USER  = in_opt_user,
           OPT_DATE  = now()
     where PARTS_ID = in_parts_id
       and status = '8003'
      and BILL_ID = in_bill_id;
   --dbms_output.put_line('2��'||sql%rowcount );
    if FOUND then
       INSERT INTO site01.BAD_STOCK_LIST
        (B_STOCK_ID,
         PN,
         SN,
         imei,
         OPT_USER,
         TRACE_NO,
         trace_name,
         OPT_DATE,
         STATUS,
         BILL_NO,
         PARTS_ID,
         chan_id)
      values
        (nextval('site01.seq_stock_id' :: REGCLASS),
         in_pn,
         in_sn,
         in_imei,
         in_opt_user,
         in_trace_no,
         in_trace_name,
         now(),
         'T',
         in_bill_id,
         in_parts_id,
         in_chan_id);

      out_ret := 'OK';
    else
      --out_ret := '11ά�޵������ڻ���״̬�Ѹı�!';
      out_ret := 'Exception';
    end if;
END;
$$;

CREATE OR REPLACE FUNCTION site01.JCSTOCKIN(IN_ID IN INTEGER,
                      IN_OPT_USER IN varchar,
                      IN_MEMO     IN varchar,
                      IN_STATUS   IN varchar,
                      OUT_R       OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
UPDATE site01.upload_inf s
       SET OPT_USER = IN_OPT_USER, MEMO = IN_MEMO, STATUS = IN_STATUS
     WHERE ID = IN_ID
       AND STATUS = 'N';
    IF  not FOUND THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  /*EXCEPTION
    WHEN OTHERS THEN
      OUT_R := 'EXCEPTION';*/
END;
$$;

CREATE OR REPLACE FUNCTION site01.zong_rvc_bad( in_stock_id      IN varchar,
                      in_opt_user IN varchar,
                      in_chan_id     IN varchar,
                      OUT_R       OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
UPDATE site01.bad_stock_list s
       SET RVC_USER = IN_OPT_USER, chan_id = in_chan_id, STATUS = 'N',RVC_DATE=now()
     WHERE b_stock_id = in_stock_id
       AND STATUS = 'T';
    IF FOUND THEN
      OUT_R := 'OK';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := 'error';
END;
$$;


CREATE OR REPLACE FUNCTION site01.station_Back_Good(in_stock_id   IN varchar,
                     in_imei      IN varchar,
                     in_opt_user  in varchar,
                     in_chan_id in  varchar,
                     in_trace_no in  varchar,
                     in_trace_name in varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
if in_imei is null then
    update site01.STOCK_LIST
       set
           status    = 'H',
           OPT_USER     = in_opt_user,
           RETURN_TRACE_NO =in_trace_no,
           RETURN_TRACE_NAME=in_trace_name,
           OPT_DATE    = now()
     where stock_id = in_stock_id
        and  chan_id     = in_chan_id
       and status ='N' ;
  else
    update site01.STOCK_LIST
       set
           status    = 'H',
          opt_user     = in_opt_user,
          RETURN_TRACE_NO =in_trace_no,
          RETURN_TRACE_NAME=in_trace_name,
          OPT_DATE     = now()
     where stock_id = in_stock_id
       and  chan_id   = in_chan_id
       and imei=in_imei
       and status ='N' ;
    end if;

    if FOUND then
      out_ret := 'OK';
    else
      --out_ret := 'ά�޵������ڻ���״̬�Ѹı�!';
      out_ret :='Order not exists or status chagned';
    end if;

  exception
    when others then
      out_ret := 'Exception';
END;
$$;

CREATE OR REPLACE FUNCTION site01.zong_rvc_good( in_stock_id      IN varchar,
                      in_opt_user IN varchar,
                      in_chan_id     IN varchar,
                      OUT_R       OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
UPDATE site01.stock_list s
       SET OPT_USER = IN_OPT_USER, chan_id = in_chan_id, STATUS = 'N'
     WHERE stock_id = in_stock_id
       AND STATUS = 'H';
    IF FOUND THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.zong_putong_Send_Part(in_stock_id IN varchar,
                                 in_parts_id in varchar,
                                 in_bill_id  in varchar,
                                 in_opt_user in varchar,
                                 in_chan_id  in varchar,
                                 in_trace_no in varchar,
                                 out_ret     OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE

BEGIN
update STOCK_LIST
      set status        = 'T',
          chan_id       = in_chan_id,
          OPT_USER      = in_opt_user,
          SEND_TRACE_NO = in_trace_no,
          OPT_DATE      = now()
    where stock_id = in_stock_id
      and status = 'N'
      and chan_id = '100';

   if FOUND then
     update site01.parts
        set ovo_flag = 'N', send_stock_id = in_stock_id
      where PARTS_ID = in_parts_id
        and status = '8001'
        and BILL_ID = in_bill_id
        and stn_code = in_chan_id;
     if FOUND then
       out_ret := 'OK';
     else
       out_ret :='Order not exists or status changed';
     end if;
     -- out_ret := 'OK';
   else
     out_ret :='Order not exists or status changed';
   end if;

 exception
   when others then
     out_ret := 'Exception';
END;
$$;


CREATE OR REPLACE FUNCTION site01.zong_putong_Send_Part_new(in_stock_id IN INTEGER,
                                 in_parts_id in varchar,
                                 in_bill_id  in varchar,
                                 in_opt_user in varchar,
                                 in_chan_id  in varchar,
                                 in_trace_no in varchar,
                                 in_trace_name in varchar,
                                 out_ret     OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  --v_ret varchar(128);
BEGIN
update site01.STOCK_LIST
      set status        = 'T',
          chan_id       = in_chan_id,
          OPT_USER      = in_opt_user,
          SEND_TRACE_NO = in_trace_no,
          send_TRACE_name = in_trace_name,
          send_date = now(),
          OPT_DATE      = now()
    where stock_id = in_stock_id
      and status = 'N'
      and chan_id = '157';

   if FOUND then
     update site01.parts
        set ovo_flag = 'N', send_stock_id = in_stock_id
      where PARTS_ID = in_parts_id
        and status = '8001'
        and BILL_ID = in_bill_id
        and stn_code = in_chan_id;
     if FOUND then
       out_ret := 'OK';
     else
       out_ret :='Order not exists or status changed';
     end if;
     -- out_ret := 'OK';
   else
     out_ret :='Order not exists or status changed';
   end if;

 /*exception
   when others then
     out_ret := 'sqlerrm';*/
END;
$$;

/*
CREATE OR REPLACE FUNCTION site01.UPLOADIMEIINF(IN_IMEI_ID                IN varchar,
                        IN_IMEI_MAIN              IN varchar,
                        IN_IMEI_VICE              IN varchar,
                        IN_MOBILE_MODEL           IN varchar,
                        IN_REPORT_DATE            IN varchar,
                        IN_VERSION                IN varchar,
                        IN_ROM                    IN varchar,
                        IN_NETWORK_OPERATORS_MAIN IN varchar,
                        IN_NETWORK_OPERATORS_VICE IN varchar,
                        IN_FREQUENCY_CHANNEL      IN varchar,
                        IN_LOCATION               IN varchar,
                        IN_DISTRIBUTOR            IN varchar,
                        OUT_R                     OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_ret varchar(128);
BEGIN
IF NOT site01.CHECK_imei_UPLOAD(IN_IMEI_MAIN) THEN
      OUT_R := 'SERIAL DUPLICATED:' || IN_IMEI_MAIN;
      RETURN;
    END IF;


  INSERT INTO site01.imei_inf
    (IMEI_ID,
     IMEI_MAIN,
     IMEI_VICE,
     MOBILE_MODEL,
     REPORT_DATE,
     VERSION,
     ROM,
     NETWORK_OPERATORS_MAIN,
     NETWORK_OPERATORS_VICE,
     FREQUENCY_CHANNEL,
     LOCATION,
     DISTRIBUTOR)
  VALUES
    (IN_IMEI_ID,
     IN_IMEI_MAIN,
     IN_IMEI_VICE,
     IN_MOBILE_MODEL,
     to_date(IN_REPORT_DATE,'YYYY/MM/DD hh24:mi:ss'),
     IN_VERSION,
     IN_ROM,
     IN_NETWORK_OPERATORS_MAIN,
     IN_NETWORK_OPERATORS_VICE,
     IN_FREQUENCY_CHANNEL,
     IN_LOCATION,
     IN_DISTRIBUTOR);
  IF FOUND THEN
    OUT_R := 'error';
    RETURN;
  END IF;
  OUT_R := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    OUT_R := 'SQLERRM';
END;
$$;

*/

CREATE OR REPLACE FUNCTION site01.Approve_Part(in_parts_id in varchar,
                             in_bill_id  in varchar,
                             in_memo in varchar,
                             in_app_flag in varchar,
                             in_opt_user in varchar,
                             out_ret     OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_status varchar(16);
BEGIN
if in_app_flag='T' then
     v_status:='8001';
  else
     v_status:='8009';
  end if;

    update site01.parts p
       set status = v_status,
           APPROVE_USER=in_opt_user,
           APPROVE_DATE=now(),
           APPROVE_MEMO=in_memo,
           APPROVE_FLAG=in_app_flag
     where PARTS_ID = in_parts_id
       and status = '8000'
      and BILL_ID = in_bill_id;
   --dbms_output.put_line('2��'||sql%rowcount );
    if FOUND then
      out_ret := 'OK';
    else
      out_ret := 'Approval Failed';
    end if;
  exception
    when others then
      out_ret := 'sqlerrm';
END;
$$;


CREATE OR REPLACE FUNCTION site01.Station_RVC_Part_SEND(in_stock_id IN INTEGER,
                     in_opt_user  in varchar,
                     in_pn in varchar,
                     in_sn in varchar,
                     in_chan_id varchar,
                     out_ret      OUT varchar)
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  v_cnt integer;
BEGIN
select count(1) into v_cnt from site01.parts where send_stock_id=in_stock_id;
  if v_cnt>0 then

  update site01.STOCK_LIST
       set
           status    = 'F',
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
        if FOUND then
          update site01.parts
       set
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=now(),
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where status ='8001' and  send_stock_id=in_stock_id;
      out_ret := 'OK';
    else
      out_ret :='Order not exists or status changed';
    end if;

  end if;
  if v_cnt=0 then
    update site01.STOCK_LIST
       set
           status    = 'N',
           OPT_USER     = in_opt_user,
           OPT_DATE    = now()
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
        if FOUND then
      out_ret := 'OK';
    else
      out_ret :='Order not exists or status changed';
    end if;
 end if;


  exception
    when others then
      out_ret := 'sqlerrm';
END;
$$;



/*    SAMPLE           */
CREATE OR REPLACE FUNCTION site01.func_sampe()
  RETURNS VARCHAR LANGUAGE plpgsql AS $$
DECLARE
  
BEGIN

END;
$$;
