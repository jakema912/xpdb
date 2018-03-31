create or replace package pk_func is
  function func_get_simple(in_id in varchar2) return varchar2;
   function func_get_is_open(in_imei in varchar2,in_sn in varchar2) return varchar2;
    function func_get_chan_name(in_chanid in varchar2) return varchar2;
    function func_get_username(in_userid in varchar2) return varchar2;
     function func_get_fault(in_code in varchar2) return varchar2;
      function func_get_fault_name(in_code in varchar2) return varchar2;
       --判断此单是否备件发货
     function func_get_part_sendflag(in_bill_id in varchar2) return varchar2;
      --判断此单是否备件处理
     function func_get_part_back_type(in_bill_id in varchar2) return varchar2 ;
      function func_get_pats_name(in_code in varchar2) return varchar2;
       --是否申备
  function func_get_pats_send_flag(in_code in varchar2) return varchar2;
   --是否有未发货
  function func_get_pats_send_qty(in_code in varchar2) return varchar2;
   --总部发货普通备件时间
   function func_get_zong_send_date(in_send_stock_id in varchar2,IN_BILL_ID IN VARCHAR2) return varchar2 ;
   --维修站收货时间
   function func_get_station_rvc_date(in_send_stock_id in varchar2,IN_BILL_ID IN VARCHAR2,in_chan_id in varchar2) return varchar2;
    --坏件返厂时间
    function func_get_bad_station_back_date(in_part_id in varchar2) return varchar2 ;
     --总部收到坏件时间
    function func_get_bad_zong_rvc_date(in_part_id  in varchar2) return varchar2 ;
    function func_get_GOOD_station_date(IN_STOCK_ID in varchar2,in_chan_id in varchar2) return varchar2;
    --总部收到好件时间
   
    function func_get_good_rvc_date(IN_STOCK_ID in varchar2) return varchar2;
     -- areaname
  function func_get_arearname(in_chan_id in varchar2) return varchar2;
   function func_get_GU_name(in_code in varchar2) return varchar2 ;
end pk_func;

 
/
create or replace package body pk_func is
  -- simple
  function func_get_simple(in_id in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select name into v_ret from dic_simple where id = in_id;
    return v_ret;
  exception
    when others then
      return 'N/A';
  end func_get_simple;
    function func_get_is_open(in_imei in varchar2,in_sn in varchar2) return varchar2 as
      v_ret varchar2(128);
      vcnt integer;
      vct integer;
    begin
     if in_imei is not null then 
      select count(1) into vcnt from bills where imei = in_imei and status in ('5001','5002','5003');
        if vcnt>0 then 
          v_ret:='Y';
        else
           v_ret:='N';
        end if;
      end if;
      if in_sn is not null then 
        select count(1) into vct from bills where sn = in_sn and status in ('5001','5002','5003'); 
        if vct>0 then 
         v_ret:='Y';
         else
            v_ret:='N';
          end if; 
        end if;
      return v_ret;
    exception
      when others then
        return 'N/A';
    end func_get_is_open;
     -- chan_name
  function func_get_chan_name(in_chanid in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select chan_name into v_ret from chan_inf where chan_id = in_chanid;
    return v_ret;
  exception
    when others then
      return in_chanid;
  end func_get_chan_name;
   -- username
  function func_get_username(in_userid in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select user_name into v_ret from users_inf where user_id = in_userid;
    return v_ret;
  exception
    when others then
      return in_userid;
  end func_get_username;
   function func_get_fault(in_code in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select fault_code||'-'||fault_description into v_ret from FAULT_CLASS where fault_code = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
  end func_get_fault;
     function func_get_fault_name(in_code in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select fault_description into v_ret from FAULT_CLASS where fault_code = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
  end func_get_fault_name;
  function func_get_GU_name(in_code in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select GU_DESC into v_ret from GU_ZHANG_INF where GU_ID = in_code;
    return v_ret;
  exception
    when others then
      return in_code;
  end func_get_GU_name;
  --判断此单是否备件发货
     function func_get_part_sendflag(in_bill_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    vcont integer;
  begin
    select count(1) into vcont from parts  where bill_id = in_bill_id and send_pn is null ;
    if vcont=0 then 
      v_ret:='N';
      else
       v_ret:='Y';
       end if;
    return v_ret;
  exception
    when others then
      return in_bill_id;
  end func_get_part_sendflag;
  --判断此单是否备件处理
     function func_get_part_back_type(in_bill_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    vcont integer;
  begin
    select count(1) into vcont from parts  where bill_id = in_bill_id and back_type is null ;
    if vcont=0 then 
      v_ret:='N';
      else
       v_ret:='Y';
       end if;
    return v_ret;
  exception
    when others then
      return in_bill_id;
  end func_get_part_back_type;
   function func_get_pats_name(in_code in varchar2) return varchar2 as
    v_ret varchar2(1024);
  begin
    select wm_concat(pn||'-'||part_name)  into v_ret from parts where bill_id= in_code;
    return v_ret;
  exception
    when others then
      return '-';
  end func_get_pats_name;
  --是否有未发货
  function func_get_pats_send_qty(in_code in varchar2) return varchar2 as
    v_ret varchar2(128);
    v_cnt integer;
    v_cns integer;
  begin
    select count(1) into v_cns from parts where bill_id=in_code;
    select count(1) into v_cnt from parts where bill_id=in_code and send_flag='N' ;
    if v_cnt=v_cns then 
      v_ret:='未发货';
     else
     if v_cnt<v_cns then 
       if v_cnt=0 then 
         v_ret:='已发货';
         else
         v_ret:='部分未发货';  
       end if; 
     else
         v_ret:='部分未发货'; 
     end if; 
   end if;  
    return v_ret;
  exception
    when others then
      return in_code;
  end func_get_pats_send_qty;
  --是否申备
  function func_get_pats_send_flag(in_code in varchar2) return varchar2 as
    v_ret varchar2(128);
    v_cnt integer;
  begin
    select count(1) into v_cnt from parts where bill_id=in_code  ;
    if v_cnt>0 then 
      v_ret:='Y';
      else
       v_ret:='N';
        end if;
    return v_ret;
  exception
    when others then
      return in_code;
  end func_get_pats_send_flag;
  --总部发货普通备件时间
   function func_get_zong_send_date(in_send_stock_id in varchar2,IN_BILL_ID IN VARCHAR2) return varchar2 as
    v_ret varchar2(128);
    
  begin
    select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from stock_list_log
     where stock_id = in_send_stock_id
       and new_STATUS = 'T'
       AND OLD_CHAN_ID = '100';
    return v_ret;
  exception
    when others then
      return 'N/A';
  end func_get_zong_send_date;
  --维修站收货时间
   function func_get_station_rvc_date(in_send_stock_id in varchar2,IN_BILL_ID IN VARCHAR2,in_chan_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    
  begin
    select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from stock_list_log
     where stock_id = in_send_stock_id
       and new_STATUS = 'N'
       AND new_CHAN_ID = in_chan_id;
    return v_ret;
  exception
    when others then
      return 'N/A';
  end func_get_station_rvc_date;
  --坏件返厂时间
    function func_get_bad_station_back_date(in_part_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    
  begin
    select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from bad_stock_list
     where parts_id = in_part_id;
    return v_ret;
  exception
    when others then
      return  'N/A';
  end func_get_bad_station_back_date;
  --总部收到坏件时间
    function func_get_bad_zong_rvc_date(in_part_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    
  begin
    select to_char(rvc_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from bad_stock_list
     where parts_id = in_part_id;
    return v_ret;
  exception
    when others then
      return 'N/A';
  end func_get_bad_zong_rvc_date;
   --好件返厂时间
    function func_get_GOOD_station_date(IN_STOCK_ID in varchar2,in_chan_id in varchar2) return varchar2 as
    v_ret varchar2(128);
    
  begin
    select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from stock_list_log
     where STOCK_ID = IN_STOCK_ID AND NEW_STATUS='H' AND OLD_STATUS='N' and old_chan_id=in_chan_id;
    return v_ret;
  exception
    when others then
      return  'N/A';
  end func_get_GOOD_station_date;
   --总部收到好件时间
   
    function func_get_good_rvc_date(IN_STOCK_ID in varchar2) return varchar2 as
    v_ret varchar2(128);
    
  begin
   select to_char(opt_date, 'YYYY-MM-DD hh24:mi:ss')
      into v_ret
      from stock_list_log
     where STOCK_ID = IN_STOCK_ID AND NEW_STATUS='N' AND OLD_STATUS='H' and new_chan_id='100';
    return v_ret;
  exception
    when others then
      return 'N/A';
  end func_get_good_rvc_date;
    -- areaname
  function func_get_arearname(in_chan_id in varchar2) return varchar2 as
    v_ret varchar2(128);
  begin
    select area into v_ret from chan_inf where chan_id = in_chan_id;
    return v_ret;
  exception
    when others then
      return '';
  end func_get_arearname;
end pk_func;
/
