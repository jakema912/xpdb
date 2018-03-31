create or replace package PK_PARTS is
  PROCEDURE Zong_Send_Part(in_stock_id   IN VARCHAR2,
                     in_imei      IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     in_trace_no varchar2,
                     out_ret      OUT VARCHAR2);
  --维修站收货
  PROCEDURE Station_RVC_Part(in_stock_id   IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2);
 PROCEDURE Station_Send_Part(in_stock_id   IN VARCHAR2, 
                      in_parts_id in varchar2,
                      in_bill_id in varchar2,
                      in_pn in varchar2,
                      in_sn in varchar2,                  
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2);
  PROCEDURE Station_bad_Part(in_parts_id in varchar2,
                             in_bill_id  in varchar2,
                             in_pn       in varchar2,
                             in_sn       in varchar2,
                             in_imei     in varchar2,
                             in_opt_user in varchar2,
                             in_chan_id  varchar2,
                             in_trace_no in varchar2,
                              in_trace_name in varchar2,
                             out_ret     OUT VARCHAR2) ;
PROCEDURE JCSTOCKIN(IN_ID       IN VARCHAR2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_MEMO     IN VARCHAR2,
                      IN_STATUS   IN VARCHAR2,
                      OUT_R       OUT VARCHAR2);
    --总部确认坏件入库
  PROCEDURE zong_rvc_bad( in_stock_id      IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_chan_id     IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) ;
      --维修站还好货
  PROCEDURE station_Back_Good(in_stock_id   IN VARCHAR2,
                     in_imei      IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id  in varchar2,
                     in_trace_no in varchar2,
                     in_trace_name in varchar2,
                     out_ret      OUT VARCHAR2);
      --总部确认好件入库
  PROCEDURE zong_rvc_good( in_stock_id      IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_chan_id     IN VARCHAR2,
                      OUT_R       OUT VARCHAR2);
                      
    --维修站发货
  PROCEDURE Station_Send_Part_fei(in_stock_id   IN VARCHAR2, 
                      in_parts_id in varchar2,
                      in_bill_id in varchar2,
                      in_pn in varchar2,
                      in_sn in varchar2,                  
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2) ;
    --总部普通发货
 PROCEDURE zong_putong_Send_Part(in_stock_id IN VARCHAR2,
                                 in_parts_id in varchar2,
                                 in_bill_id  in varchar2,
                                 in_opt_user in varchar2,
                                 in_chan_id  in varchar2,
                                 in_trace_no in varchar2,
                                 out_ret     OUT VARCHAR2);
  --上传imei信息
PROCEDURE UPLOADIMEIINF(IN_IMEI_ID                IN VARCHAR2,
                        IN_IMEI_MAIN              IN VARCHAR2,
                        IN_IMEI_VICE              IN VARCHAR2,
                        IN_MOBILE_MODEL           IN VARCHAR2,
                        IN_REPORT_DATE            IN VARCHAR2,
                        IN_VERSION                IN VARCHAR2,
                        IN_ROM                    IN VARCHAR2,
                        IN_NETWORK_OPERATORS_MAIN IN VARCHAR2,
                        IN_NETWORK_OPERATORS_VICE IN VARCHAR2,
                        IN_FREQUENCY_CHANNEL      IN VARCHAR2,
                        IN_LOCATION               IN VARCHAR2,
                        IN_DISTRIBUTOR            IN VARCHAR2,
                        OUT_R                     OUT VARCHAR2);
  --总部普通发货
 PROCEDURE zong_putong_Send_Part_new(in_stock_id IN VARCHAR2,
                                 in_parts_id in varchar2,
                                 in_bill_id  in varchar2,
                                 in_opt_user in varchar2,
                                 in_chan_id  in varchar2,
                                 in_trace_no in varchar2,
                                  in_trace_name in varchar2,
                                 out_ret     OUT VARCHAR2);
  PROCEDURE Approve_Part(in_parts_id in varchar2,
                             in_bill_id  in varchar2,
                             in_memo in varchar2,
                             in_app_flag in varchar2,
                             in_opt_user in varchar2,
                             out_ret     OUT VARCHAR2);
END;

 
/
create or replace package body PK_PARTS is
 --总部给维修站发货
  PROCEDURE Zong_Send_Part(in_stock_id   IN VARCHAR2,
                     in_imei      IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     in_trace_no varchar2,
                     out_ret      OUT VARCHAR2) is
  begin
  if in_imei is null then 
    update STOCK_LIST
       set 
           status    = 'T',
           chan_id     = in_chan_id,
           OPT_USER     = in_opt_user,
           SEND_TRACE_NO =in_trace_no,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
       and status ='N' ;
  else
    update STOCK_LIST
       set 
           status    = 'T',
           chan_id     = in_chan_id,
          opt_user     = in_opt_user,
          SEND_TRACE_NO =in_trace_no,
          OPT_DATE     = sysdate
     where stock_id = in_stock_id
       and imei=in_imei 
       and status ='N' ;
    end if;
    
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Zong_Send_Part;
  --总部确认收货
  --维修站收货
  PROCEDURE Station_RVC_Part(in_stock_id   IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2) is
      v_cnt integer;  
  begin
  select count(1) into v_cnt from parts where send_stock_id=in_stock_id;
  if v_cnt>0 then 
  --总部普通发货收货
  update STOCK_LIST
       set 
           status    = 'V', 
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
  end if;
  if v_cnt=0 then 
    update STOCK_LIST
       set 
           status    = 'N',
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
 end if;
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Station_RVC_Part;
 --维修站发货
  PROCEDURE Station_Send_Part(in_stock_id   IN VARCHAR2, 
                      in_parts_id in varchar2,
                      in_bill_id in varchar2,
                      in_pn in varchar2,
                      in_sn in varchar2,                  
                     in_opt_user  in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2) is
  begin


    
      update parts 
       set 
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=sysdate,
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
          
          --send_stock_id=in_stock_id
     where PARTS_ID = in_parts_id
       and status ='8001' and BILL_ID=in_bill_id and stn_code=in_chan_id ; 
      
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Station_Send_Part;
  --维修站发货
  PROCEDURE Station_Send_Part_fei(in_stock_id   IN VARCHAR2, 
                      in_parts_id in varchar2,
                      in_bill_id in varchar2,
                      in_pn in varchar2,
                      in_sn in varchar2,                  
                     in_opt_user  in varchar2,
                     in_chan_id in  varchar2,
                     out_ret      OUT VARCHAR2) is
  begin


    
      update parts 
       set 
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=sysdate,
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where PARTS_ID = in_parts_id
       and status ='8001' and BILL_ID=in_bill_id and stn_code=in_chan_id and  send_stock_id=in_stock_id; 
      
    if sql%rowcount = 1 then
     update stock_list
        set status = 'F', opt_date = sysdate, opt_user = in_opt_user
      where stock_id = in_stock_id
        and status = 'V'
        and chan_id = in_chan_id;
       if sql%rowcount = 1 then
       out_ret := 'OK';
      else
        out_ret := '库存变更出错,请重新发货!';
      end if;
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Station_Send_Part_fei;
  --维修站返还坏件
  PROCEDURE Station_bad_Part(in_parts_id in varchar2,
                             in_bill_id  in varchar2,
                             in_pn       in varchar2,
                             in_sn       in varchar2,
                             in_imei     in varchar2,
                             in_opt_user in varchar2,
                             in_chan_id in   varchar2,
                             in_trace_no in varchar2,
                             in_trace_name in varchar2,
                             out_ret     OUT VARCHAR2) is
   
  begin
    
 
    update parts p
       set status = '8004',
           GET_FLAG = 'Y',
           get_date = sysdate,
           get_eng = in_opt_user,
           OPT_USER  = in_opt_user,
           OPT_DATE  = sysdate
     where PARTS_ID = in_parts_id
       and status = '8003'
      and BILL_ID = in_bill_id;
   dbms_output.put_line('2：'||sql%rowcount );
    if sql%rowcount = 1 then
       INSERT INTO BAD_STOCK_LIST 
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
        (SEQ_STOCK_ID.NEXTVAL,
         in_pn,
         in_sn,
         in_imei,
         in_opt_user,
         in_trace_no,
         in_trace_name,
         sysdate,
         'T',
         in_bill_id,
         in_parts_id,
         in_chan_id);
    
      out_ret := 'OK';
    else
      out_ret := '11维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
  end Station_bad_Part;
   --寄存备件入库
   PROCEDURE JCSTOCKIN(IN_ID       IN VARCHAR2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_MEMO     IN VARCHAR2,
                      IN_STATUS   IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) IS
  BEGIN
    UPDATE upload_inf s
       SET OPT_USER = IN_OPT_USER, MEMO = IN_MEMO, STATUS = IN_STATUS
     WHERE ID = IN_ID
       AND STATUS = 'N';
    IF SQL%ROWCOUNT != 1 THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := SQLERRM;
  END JCSTOCKIN;
     --总部确认坏件入库
  PROCEDURE zong_rvc_bad( in_stock_id      IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_chan_id     IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) IS
  BEGIN
    UPDATE bad_stock_list s
       SET RVC_USER = IN_OPT_USER, chan_id = in_chan_id, STATUS = 'N',RVC_DATE=sysdate
     WHERE b_stock_id = in_stock_id
       AND STATUS = 'T';
    IF SQL%ROWCOUNT != 1 THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := SQLERRM;
  END zong_rvc_bad;
   --维修站还好货
  PROCEDURE station_Back_Good(in_stock_id   IN VARCHAR2,
                     in_imei      IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_chan_id in  varchar2,
                     in_trace_no in  varchar2,
                     in_trace_name in varchar2,
                     out_ret      OUT VARCHAR2) is
  begin
  if in_imei is null then 
    update STOCK_LIST
       set 
           status    = 'H',
           OPT_USER     = in_opt_user,
           RETURN_TRACE_NO =in_trace_no,
           RETURN_TRACE_NAME=in_trace_name,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
        and  chan_id     = in_chan_id
       and status ='N' ;
  else
    update STOCK_LIST
       set 
           status    = 'H',
          opt_user     = in_opt_user,
          RETURN_TRACE_NO =in_trace_no,
          RETURN_TRACE_NAME=in_trace_name,
          OPT_DATE     = sysdate
     where stock_id = in_stock_id
       and  chan_id   = in_chan_id
       and imei=in_imei 
       and status ='N' ;
    end if;
    
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end station_Back_Good;
    --总部确认好件入库
  PROCEDURE zong_rvc_good( in_stock_id      IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_chan_id     IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) IS
  BEGIN
    UPDATE stock_list s
       SET OPT_USER = IN_OPT_USER, chan_id = in_chan_id, STATUS = 'N'
     WHERE stock_id = in_stock_id
       AND STATUS = 'H';
    IF SQL%ROWCOUNT != 1 THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := SQLERRM;
  END zong_rvc_good;
 --总部普通发货
 PROCEDURE zong_putong_Send_Part(in_stock_id IN VARCHAR2,
                                 in_parts_id in varchar2,
                                 in_bill_id  in varchar2,
                                 in_opt_user in varchar2,
                                 in_chan_id  in varchar2,
                                 in_trace_no in varchar2,
                                 out_ret     OUT VARCHAR2) is
 begin
   update STOCK_LIST
      set status        = 'T',
          chan_id       = in_chan_id,
          OPT_USER      = in_opt_user,
          SEND_TRACE_NO = in_trace_no,
          OPT_DATE      = sysdate
    where stock_id = in_stock_id
      and status = 'N'
      and chan_id = '100';
 
   if sql%rowcount = 1 then
     update parts
        set ovo_flag = 'N', send_stock_id = in_stock_id
      where PARTS_ID = in_parts_id
        and status = '8001'
        and BILL_ID = in_bill_id
        and stn_code = in_chan_id;
     if sql%rowcount = 1 then
       out_ret := 'OK';
     else
       out_ret := '维修单不存在或者状态已改变!';
     end if;
     -- out_ret := 'OK';
   else
     out_ret := '维修单不存在或者状态已改变!';
   end if;
 
 exception
   when others then
     out_ret := sqlerrm;
   
 end zong_putong_Send_Part;
  --总部普通发货
 PROCEDURE zong_putong_Send_Part_new(in_stock_id IN VARCHAR2,
                                 in_parts_id in varchar2,
                                 in_bill_id  in varchar2,
                                 in_opt_user in varchar2,
                                 in_chan_id  in varchar2,
                                 in_trace_no in varchar2,
                                 in_trace_name in varchar2,
                                 out_ret     OUT VARCHAR2) is
 begin
   update STOCK_LIST
      set status        = 'T',
          chan_id       = in_chan_id,
          OPT_USER      = in_opt_user,
          SEND_TRACE_NO = in_trace_no,
          send_TRACE_name = in_trace_name,
          send_date = sysdate,
          OPT_DATE      = sysdate
    where stock_id = in_stock_id
      and status = 'N'
      and chan_id = '157';
 
   if sql%rowcount = 1 then
     update parts
        set ovo_flag = 'N', send_stock_id = in_stock_id
      where PARTS_ID = in_parts_id
        and status = '8001'
        and BILL_ID = in_bill_id
        and stn_code = in_chan_id;
     if sql%rowcount = 1 then
       out_ret := 'OK';
     else
       out_ret := '维修单不存在或者状态已改变!';
     end if;
     -- out_ret := 'OK';
   else
     out_ret := '维修单不存在或者状态已改变!';
   end if;
 
 exception
   when others then
     out_ret := sqlerrm;
   
 end zong_putong_Send_Part_new;
  --判断是否重复
  FUNCTION CHECK_imei_UPLOAD(IN_imei VARCHAR2)
    RETURN BOOLEAN IS
    v_cnt integer;
  BEGIN
    SELECT COUNT(1)
      INTO v_cnt
      FROM imei_inf
     WHERE imei_main = IN_imei;
    IF v_cnt = 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  
  END CHECK_imei_UPLOAD;
--上传email信息
PROCEDURE UPLOADIMEIINF(IN_IMEI_ID                IN VARCHAR2,
                        IN_IMEI_MAIN              IN VARCHAR2,
                        IN_IMEI_VICE              IN VARCHAR2,
                        IN_MOBILE_MODEL           IN VARCHAR2,
                        IN_REPORT_DATE            IN VARCHAR2,
                        IN_VERSION                IN VARCHAR2,
                        IN_ROM                    IN VARCHAR2,
                        IN_NETWORK_OPERATORS_MAIN IN VARCHAR2,
                        IN_NETWORK_OPERATORS_VICE IN VARCHAR2,
                        IN_FREQUENCY_CHANNEL      IN VARCHAR2,
                        IN_LOCATION               IN VARCHAR2,
                        IN_DISTRIBUTOR            IN VARCHAR2,
                        OUT_R                     OUT VARCHAR2) IS
BEGIN
 
    IF NOT CHECK_imei_UPLOAD(IN_IMEI_MAIN) THEN
      OUT_R := '序列号重复上传--' || IN_IMEI_MAIN;
      RETURN;
    END IF;


  INSERT INTO imei_inf
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
  IF SQL%ROWCOUNT != 1 THEN
    OUT_R := 'error';
    RETURN;
  END IF;
  OUT_R := 'OK';
EXCEPTION
  WHEN OTHERS THEN
    OUT_R := SQLERRM;
END UPLOADIMEIINF;
--审批备件
  PROCEDURE Approve_Part(in_parts_id in varchar2,
                             in_bill_id  in varchar2,
                             in_memo in varchar2,
                             in_app_flag in varchar2,
                             in_opt_user in varchar2,
                             out_ret     OUT VARCHAR2) is
   v_status varchar2(16);
  begin
  if in_app_flag='T' then 
     v_status:='8001';
  else 
     v_status:='8009';
  end if; 
  
    update parts p
       set status = v_status,
           APPROVE_USER=in_opt_user,
           APPROVE_DATE=sysdate,
           APPROVE_MEMO=in_memo,
           APPROVE_FLAG=in_app_flag
     where PARTS_ID = in_parts_id
       and status = '8000'
      and BILL_ID = in_bill_id;
   dbms_output.put_line('2：'||sql%rowcount );
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '审批失败';
    end if;
  exception
    when others then
      out_ret := sqlerrm;
  end Approve_Part;
PROCEDURE Station_RVC_Part_DEND(in_stock_id   IN VARCHAR2,                   
                     in_opt_user  in varchar2,
                     in_pn in varchar2,
                     in_sn in varchar2,
                     in_chan_id varchar2,
                     out_ret      OUT VARCHAR2) is
      v_cnt integer;  
  begin
  select count(1) into v_cnt from parts where send_stock_id=in_stock_id;
  if v_cnt>0 then 
  --总部普通发货收货
  update STOCK_LIST
       set 
           status    = 'F', 
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
        if sql%rowcount = 1 then
          update parts 
       set 
           STATUS    = '8002',
           SEND_FLAG='Y',
           SEND_DATE=sysdate,
           NEW_SN=in_sn,
           send_pn=in_pn,
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where status ='8001' and  send_stock_id=in_stock_id; 
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
      
  end if;
  if v_cnt=0 then 
    update STOCK_LIST
       set 
           status    = 'N',
           OPT_USER     = in_opt_user,
           OPT_DATE    = sysdate
     where stock_id = in_stock_id
       and status ='T' and chan_id=in_chan_id;
        if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
 end if;
   
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Station_RVC_Part_DEND;
end PK_PARTS;
/
