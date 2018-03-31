create or replace package PK_FIX is
PROCEDURE OPEN_ORDERS(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2) ;
PROCEDURE UPDATE_ORDERS(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2);
PROCEDURE AssignEng(in_bill_id  IN VARCHAR2,
                      in_engid    IN VARCHAR2,
                      in_opt_user in varchar2,
                      out_ret     OUT VARCHAR2);
PROCEDURE insert_part_list(in_bill_id  IN VARCHAR2,
                             in_pn   IN VARCHAR2,
                             in_PART_SN   IN VARCHAR2,  
                              in_name in varchar2,
                             in_desc in varchar2,                        
                             in_userid   IN VARCHAR2,
                             in_chanid   IN VARCHAR2,
                             in_stock_id in varchar2,
                              in_ovo_flag in varchar2,
                             out_ret     OUT VARCHAR2);
   --取机操作
  PROCEDURE GetOut(in_bill_id   IN VARCHAR2,
                   in_engid     IN VARCHAR2,
                   in_is_satify IN VARCHAR2,
                   in_addvise   IN VARCHAR2,
                   in_getmemo   IN VARCHAR2,
                   -- in_get_date in varchar2,
                   in_opt_user  in varchar2,
                   in_fix_money in varchar2,
                   
                   out_ret OUT VARCHAR2);
 --上传email信息
  PROCEDURE UPLOADINF(IN_PN_NO    IN VARCHAR2,
                      IN_IMEI       IN VARCHAR2,
                      IN_memo IN VARCHAR2,
                      in_QTY in varchar2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_TRACE_NO IN VARCHAR2,
                      OUT_R       OUT VARCHAR2);
  FUNCTION CHECK_SN_UPLOAD(IN_IMEI VARCHAR2)  RETURN BOOLEAN;
  PROCEDURE Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng2      IN VARCHAR2,
                     in_test_code    IN VARCHAR2,
                     in_fix_code     IN VARCHAR2,
                     in_test_desc IN VARCHAR2,
                     in_eng3      IN VARCHAR2,
                     in_fix_desc  IN VARCHAR2,
                     in_is_end    IN VARCHAR2,
                     in_fix_res   IN VARCHAR2,
                     in_opt_user  in varchar2,
                     in_version in varchar2,
                     in_gimei in varchar2,
                     out_ret      OUT VARCHAR2);
 --返还
  PROCEDURE Back_Part(in_bill_id   IN VARCHAR2,
                   in_back_class IN VARCHAR2,
                   in_opt_user  in varchar2,
                   in_part_id in varchar2,
                   out_ret OUT VARCHAR2) ;
                    --开单修改 
    PROCEDURE OPEN_ORDERS_NEW(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2);
    PROCEDURE First_Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng2      IN VARCHAR2,
                     in_test_code    IN VARCHAR2,
                     in_test_desc IN VARCHAR2,
                     in_m_nbr      IN VARCHAR2,
                     in_d_nbr  IN VARCHAR2,
                     in_m_hour    IN VARCHAR2,
                     in_d_hour   IN VARCHAR2, 
                     in_power_on in varchar2,
                     in_power_off in varchar2,
                     in_test_result in varchar2,
                     in_is_end in varchar2,
                     in_opt_user  in varchar2,
                     out_ret      OUT VARCHAR2);
      PROCEDURE Sencond_Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng3      IN VARCHAR2,
                     in_fix_code    IN VARCHAR2,
                     in_fix_desc IN VARCHAR2,
                     in_is_end      IN VARCHAR2,
                     in_fix_nbr  IN VARCHAR2,
                     in_fix_light    IN VARCHAR2,
                     in_opt_user  in varchar2,
                     out_ret      OUT VARCHAR2);
     PROCEDURE uploadinf_new(IN_PN_NO    IN VARCHAR2,
                      IN_IMEI       IN VARCHAR2,
                      IN_memo IN VARCHAR2,
                      in_QTY in varchar2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_TRACE_NO IN VARCHAR2,
                      OUT_R       OUT VARCHAR2);
       PROCEDURE insert_part_list_app(in_bill_id  IN VARCHAR2,
                             in_pn   IN VARCHAR2,
                             in_PART_SN   IN VARCHAR2,
                             in_name in varchar2,
                             in_desc in varchar2,                        
                             in_userid   IN VARCHAR2,
                             in_chanid   IN VARCHAR2,
                             in_stock_id in varchar2,
                             in_ovo_flag in varchar2,
                             out_ret     OUT VARCHAR2);
                              --shouji
    PROCEDURE OPEN_dealer_open(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2);
   PROCEDURE fix_station_rvc(
                             in_bill_id  in varchar2,
                             in_memo in varchar2,
                             in_app_flag in varchar2,
                             in_opt_user in varchar2,
                             in_bill_status  in varchar2,
                             out_ret     OUT VARCHAR2);
       PROCEDURE update_dealer_RVC(
                             in_bill_id  in varchar2,
                             in_opt_user in varchar2,
                             in_bill_status  in varchar2,
                             out_ret     OUT VARCHAR2);
         --取机操作
  PROCEDURE GetOutStation(in_bill_id   IN VARCHAR2,
                          in_engid     IN VARCHAR2,
                          in_is_satify IN VARCHAR2,
                          in_addvise   IN VARCHAR2,
                          in_getmemo   IN VARCHAR2,
                          in_opt_user  in varchar2,
                          in_fix_money in varchar2,
                          in_billtype  in varchar2,
                          in_traceno   in varchar2,
                          in_tracename in varchar2,
                          out_ret      OUT VARCHAR2) ;
end PK_FIX;

 
/
create or replace package body PK_FIX is
  V_SN INT;
--添加手机开单信息
  PROCEDURE OPEN_ORDERS(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2) IS
    V_XML XMLTYPE;
  BEGIN
    V_XML := XMLTYPE(IN_DATA);
     INSERT INTO bills
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
     )
     SELECT
       EXTRACTVALUE(V_XML, '/xml/billno'),
        EXTRACTVALUE(V_XML, '/xml/sn'),
        '4001',
       EXTRACTVALUE(V_XML, '/xml/custtype'),
       EXTRACTVALUE(V_XML, '/xml/custname'),
       EXTRACTVALUE(V_XML, '/xml/custtel'),
       EXTRACTVALUE(V_XML, '/xml/dealer'),
       EXTRACTVALUE(V_XML, '/xml/parttype'),
       EXTRACTVALUE(V_XML, '/xml/model'),     
       EXTRACTVALUE(V_XML, '/xml/pcolor'),
       EXTRACTVALUE(V_XML, '/xml/imei'),
       upper(EXTRACTVALUE(V_XML, '/xml/pcode')),
       EXTRACTVALUE(V_XML, '/xml/appearance'),
       EXTRACTVALUE(V_XML, '/xml/warranty'),
       EXTRACTVALUE(V_XML, '/xml/warea'),
       EXTRACTVALUE(V_XML, '/xml/fixtype'),
       EXTRACTVALUE(V_XML, '/xml/changetype'),
       decode(EXTRACTVALUE(V_XML, '/xml/purdate'),'',null,null,null,to_date(EXTRACTVALUE(V_XML, '/xml/purdate'),'yyyy-mm-dd')),
       EXTRACTVALUE(V_XML, '/xml/invoice'),
       EXTRACTVALUE(V_XML, '/xml/invoiceno'),
       EXTRACTVALUE(V_XML, '/xml/sid'),
       EXTRACTVALUE(V_XML, '/xml/optuser'),
       EXTRACTVALUE(V_XML, '/xml/optuser'),
       EXTRACTVALUE(V_XML, '/xml/rcid'),
       EXTRACTVALUE(V_XML, '/xml/symptom'),
       EXTRACTVALUE(V_XML, '/xml/zhengzhuangdesc'),
        EXTRACTVALUE(V_XML, '/xml/total_class'),
         EXTRACTVALUE(V_XML, '/xml/vserion'),
           EXTRACTVALUE(V_XML, '/xml/email')
       --pk_func.func_get_paystatus(EXTRACTVALUE(V_XML, '/xml/warranty'),EXTRACTVALUE(V_XML, '/xml/rcid'))
     FROM DUAL; 
    
         
    OUT_DATA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_DATA := SQLERRM;
  END;
  --
  
    PROCEDURE UPDATE_ORDERS(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2) IS
    V_XML XMLTYPE;
  BEGIN
    V_XML := XMLTYPE(IN_DATA);
     UPDATE bills set  SN= upper(EXTRACTVALUE(V_XML, '/xml/sn')),
        CUST_NAME= EXTRACTVALUE(V_XML, '/xml/custname'),
        CUST_TEL=EXTRACTVALUE(V_XML, '/xml/custtel'),
        DEALER=EXTRACTVALUE(V_XML, '/xml/dealer'),
        PART_TYPE=EXTRACTVALUE(V_XML, '/xml/parttype'),
        MODEL= EXTRACTVALUE(V_XML, '/xml/model'),
        PCOLOR= EXTRACTVALUE(V_XML, '/xml/pcolor'),
        IMEI=EXTRACTVALUE(V_XML, '/xml/imei'),
        PCODE=upper(EXTRACTVALUE(V_XML, '/xml/pcode')),
        APPEARANCE=EXTRACTVALUE(V_XML, '/xml/appearance'),
        WARRANTY= EXTRACTVALUE(V_XML, '/xml/warranty'),
        WAREA=EXTRACTVALUE(V_XML, '/xml/warea'),
        FIX_TYPE=EXTRACTVALUE(V_XML, '/xml/fixtype'),
        CHANGETYPE= EXTRACTVALUE(V_XML, '/xml/changetype'),
        PURDATE=decode(EXTRACTVALUE(V_XML, '/xml/purdate'),'',null,null,null,to_date(EXTRACTVALUE(V_XML, '/xml/purdate'),'yyyy-mm-dd')),
        --INVOICE= EXTRACTVALUE(V_XML, '/xml/invoice'),
       -- INVOICE_NO=EXTRACTVALUE(V_XML, '/xml/invoiceno'),
        SID=EXTRACTVALUE(V_XML, '/xml/sid'), 
        --OPEN_USER=EXTRACTVALUE(V_XML, '/xml/optuser'),
        --OPT_USER= EXTRACTVALUE(V_XML, '/xml/optuser'),   
        --RC_ID= EXTRACTVALUE(V_XML, '/xml/rcid'),
        SYMPTOM_CODE= EXTRACTVALUE(V_XML, '/xml/symptom'),
        SYMPTOM_DESC=EXTRACTVALUE(V_XML, '/xml/zhengzhuangdesc'),
        FAULT_TOTAL= EXTRACTVALUE(V_XML, '/xml/total_class'),
        OLD_VERSION= EXTRACTVALUE(V_XML, '/xml/vserion'),
        E_MAIL= EXTRACTVALUE(V_XML, '/xml/email')
     where bill_no= EXTRACTVALUE(V_XML, '/xml/billno');

    OUT_DATA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_DATA := SQLERRM;
  END;
   --分派工程师
  PROCEDURE AssignEng(in_bill_id  IN VARCHAR2,
                      in_engid    IN VARCHAR2,
                      in_opt_user in varchar2,
                      out_ret     OUT VARCHAR2) is
  
  begin
  
    update bills
       set status       = '4002',
           ASSIGN_ENGINEER     = in_engid,
           FIX_ENGINEER    = in_engid,
           opt_user     = in_opt_user,
           opt_date     = sysdate
     where bill_no = in_bill_id
       and status = '4001';
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
  end AssignEng;
    --申请信备件
  PROCEDURE insert_part_list(in_bill_id  IN VARCHAR2,
                             in_pn   IN VARCHAR2,
                             in_PART_SN   IN VARCHAR2,
                             in_name in varchar2,
                             in_desc in varchar2,                        
                             in_userid   IN VARCHAR2,
                             in_chanid   IN VARCHAR2,
                             in_stock_id in varchar2,
                             in_ovo_flag in varchar2,
                             out_ret     OUT VARCHAR2) is
  --  v_num varchar2(32);
  v_cont integer;
  begin
  
  select count(1) into v_cont from parts where send_stock_id=in_stock_id ;
  if v_cont>0 then 
    out_ret := '库存已使用，请直接申备。!';
    return;
  end if;
  
   
      insert into parts
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
      values
        (seq_part_list_id.nextval,
         in_bill_id,
         '8001',
         in_pn,
         in_chanid,
         in_PART_SN,
         in_name,
         in_desc,
         sysdate,
         in_stock_id,
         in_ovo_flag,
         in_userid
         );
     
     if sql%rowcount = 1 then  
      update bills set status='4003' where  bill_no=in_bill_id;
       if in_stock_id is not null then  
     update stock_list set status='F' ,opt_date=sysdate,opt_user=in_userid
     where stock_id=in_stock_id and status='N' and pn_no=in_pn;
      if sql%rowcount = 1 then
        
      out_ret := 'OK';
     else
      out_ret := '库存保存不成功!';
     end if;
     else 
      out_ret := 'OK';  
     end if;
   else
      out_ret := '保存备件不成功!';
    end if;
  exception
    when others then
      out_ret := sqlerrm;
  end insert_part_list;
    --检测维修操作
  PROCEDURE Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng2      IN VARCHAR2,
                     in_test_code    IN VARCHAR2,
                     in_fix_code     IN VARCHAR2,
                     in_test_desc IN VARCHAR2,
                     in_eng3      IN VARCHAR2,
                     in_fix_desc  IN VARCHAR2,
                     in_is_end    IN VARCHAR2,
                     in_fix_res   IN VARCHAR2,
                     in_opt_user  in varchar2,
                     in_version in varchar2,
                     in_gimei in varchar2,
                     out_ret      OUT VARCHAR2) is
  --  v_rma_status varchar(32);
  
  begin
  
    update bills
       set 
           engineer2    = in_eng2,
           test_code     = in_test_code,
           fix_code     = in_fix_code,
           test_Desc    = in_test_desc,
           engineer3    = in_eng3,
           fix_desc     = in_fix_desc,
           fix_result   = in_fix_res,
           opt_user     = in_opt_user,
           opt_date     = sysdate,
           NEW_VERSION  =in_version,
           GIMEI=in_gimei
     where bill_no = in_bill_id;
      -- and status in ('4002');
    if in_is_end = 'Y' then
      
      update bills
         set is_end      = 'Y',
             status      = '4004',
             fix_date     = sysdate
       where bill_no = in_bill_id;
       --  and status in ('4003');
    end if;
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变1!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
    
  end Test_Fix;
  --取机操作
  PROCEDURE GetOut(in_bill_id   IN VARCHAR2,
                   in_engid     IN VARCHAR2,
                   in_is_satify IN VARCHAR2,
                   in_addvise   IN VARCHAR2,
                   in_getmemo   IN VARCHAR2,
                   -- in_get_date in varchar2,
                   in_opt_user  in varchar2,
                   in_fix_money in varchar2,
                   
                   out_ret OUT VARCHAR2) is
  
  begin
  
    update bills
       set status        = '4005',
           end_user     = in_engid,
           is_satify     = in_is_satify,
           cust_advice   = in_addvise,
           getout_memo   = in_getmemo,
           end_date = sysdate,
           opt_user      = in_opt_user,
           opt_date      = sysdate,        
           fix_money = in_fix_money
     where bill_no = in_bill_id
       and status = '4004';
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变2!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
  end GetOut;
   --上传email信息
  PROCEDURE UPLOADINF(IN_PN_NO    IN VARCHAR2,
                      IN_IMEI       IN VARCHAR2,
                      IN_memo IN VARCHAR2,
                      in_QTY in varchar2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_TRACE_NO IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) IS
  BEGIN
    IF IN_IMEI is not null THEN
      IF NOT CHECK_SN_UPLOAD(IN_IMEI) THEN
        OUT_R := 'IMEI重复上传--' || IN_IMEI;
        RETURN;
      END IF;
    END IF;
    IF IN_PN_NO IS NULL THEN
      OUT_R := 'PN不能为空--' || IN_PN_NO;
      RETURN;
    END IF;
    IF in_QTY IS NULL THEN
      OUT_R := '数量不能为空--' || in_QTY;
      RETURN;
    END IF;
    IF IN_TRACE_NO IS NULL THEN
      OUT_R := '运单号不能为空--' || IN_TRACE_NO;
      RETURN;
    END IF;
    INSERT INTO UPLOAD_INF
      (ID,PN_NO, IMEI, QTY, OPT_USER, OPT_DATE, TRACE_NO,CHAN_ID,MEMO)
    VALUES
      (seq_stock_id.nextval, IN_PN_NO, IN_IMEI, in_QTY, IN_OPT_USER, SYSDATE, IN_TRACE_NO,'100',IN_memo);
    IF SQL%ROWCOUNT != 1 THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := SQLERRM;
  END UPLOADINF;
  --上传email信息新
  PROCEDURE uploadinf_new(IN_PN_NO    IN VARCHAR2,
                      IN_IMEI       IN VARCHAR2,
                      IN_memo IN VARCHAR2,
                      in_QTY in varchar2,
                      IN_OPT_USER IN VARCHAR2,
                      IN_TRACE_NO IN VARCHAR2,
                      OUT_R       OUT VARCHAR2) IS
  BEGIN
    IF IN_IMEI is not null THEN
      IF NOT CHECK_SN_UPLOAD(IN_IMEI) THEN
        OUT_R := 'IMEI重复上传--' || IN_IMEI;
        RETURN;
      END IF;
    END IF;
    IF IN_PN_NO IS NULL THEN
      OUT_R := 'PN不能为空--' || IN_PN_NO;
      RETURN;
    END IF;
    IF in_QTY IS NULL THEN
      OUT_R := '数量不能为空--' || in_QTY;
      RETURN;
    END IF;
    IF IN_TRACE_NO IS NULL THEN
      OUT_R := '运单号不能为空--' || IN_TRACE_NO;
      RETURN;
    END IF;
    INSERT INTO UPLOAD_INF
      (ID,PN_NO, IMEI, QTY, OPT_USER, OPT_DATE, TRACE_NO,CHAN_ID,MEMO)
    VALUES
      (seq_stock_id.nextval, IN_PN_NO, IN_IMEI, in_QTY, IN_OPT_USER, SYSDATE, IN_TRACE_NO,'157',IN_memo);
    IF SQL%ROWCOUNT != 1 THEN
      OUT_R := 'error';
      RETURN;
    END IF;
    OUT_R := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_R := SQLERRM;
  END uploadinf_new;
   --判断是否重复
  FUNCTION CHECK_SN_UPLOAD(IN_IMEI VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    SELECT COUNT(1)
      INTO V_SN
      FROM UPLOAD_INF
     WHERE IMEI = IN_IMEI;
      -- AND APPLE_NO = IN_pn;
    IF V_SN = 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  
  END CHECK_SN_UPLOAD;
  --返还
  PROCEDURE Back_Part(in_bill_id    IN VARCHAR2,
                      in_back_class IN VARCHAR2,
                      in_opt_user   in varchar2,
                      in_part_id    in varchar2,
                      out_ret       OUT VARCHAR2) is
  v_send_stock_id varchar2(32);
  begin
  
    IF in_back_class = '1302' OR in_back_class = '1303' THEN
    
      update parts
         set status    = '8001',
             send_flag = null,
             send_date = null,
             send_stock_id = '',
             back_date = null,
             back_type = in_back_class,
             back_flag = 'Y',
             opt_user    = in_opt_user,
             opt_date    = sysdate
       where bill_id = in_bill_id
         and parts_id = in_part_id;
           update stock_list
       set status = 'N', opt_date = sysdate, opt_user = in_opt_user
       where stock_id = v_send_stock_id;
    ELSE
   
    select send_stock_id into v_send_stock_id from parts where parts_id = in_part_id;
      update parts p
         set status      = '8003',
             p.back_flag = 'Y',
             p.back_date = sysdate,
             p.back_type = '1301',
             opt_user    = in_opt_user,
             opt_date    = sysdate
       where bill_id = in_bill_id
         and parts_id = in_part_id
         and status = '8002'
         and send_flag = 'Y';
         
      update stock_list
       set status = 'Y', opt_date = sysdate, opt_user = in_opt_user
       where stock_id = v_send_stock_id;
     
    END IF;
    
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
  end Back_Part;
  --开单修改 
    PROCEDURE OPEN_ORDERS_NEW(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2) IS
    V_XML XMLTYPE;
  BEGIN
    V_XML := XMLTYPE(IN_DATA);
     INSERT INTO bills
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
       -- PCODE,
        APPEARANCE,
        WARRANTY,
        WAREA,
        FIX_TYPE,
       -- CHANGETYPE,
        PURDATE,
        INVOICE,
        INVOICE_NO,
       -- SID, 
        OPEN_USER,
        OPT_USER,   
        RC_ID,
        SYMPTOM_CODE,
        SYMPTOM_DESC,
       -- FAULT_TOTAL,
        OLD_VERSION,
        E_MAIL,
        M_USE_HOUSE,
        D_USE_HOUSE,
        M_LIGHT,
        m_type
     )
     SELECT
       EXTRACTVALUE(V_XML, '/xml/billno'),
        EXTRACTVALUE(V_XML, '/xml/sn'),
        '4001',
       EXTRACTVALUE(V_XML, '/xml/custtype'),
       EXTRACTVALUE(V_XML, '/xml/custname'),
       EXTRACTVALUE(V_XML, '/xml/custtel'),
       EXTRACTVALUE(V_XML, '/xml/dealer'),
       EXTRACTVALUE(V_XML, '/xml/parttype'),
       EXTRACTVALUE(V_XML, '/xml/model'),     
       EXTRACTVALUE(V_XML, '/xml/appearance'),
       EXTRACTVALUE(V_XML, '/xml/warranty'),
       EXTRACTVALUE(V_XML, '/xml/warea'),
       EXTRACTVALUE(V_XML, '/xml/fixtype'),
       decode(EXTRACTVALUE(V_XML, '/xml/purdate'),'',null,null,null,to_date(EXTRACTVALUE(V_XML, '/xml/purdate'),'yyyy-mm-dd')),
       EXTRACTVALUE(V_XML, '/xml/invoice'),
       EXTRACTVALUE(V_XML, '/xml/invoiceno'),     
       EXTRACTVALUE(V_XML, '/xml/optuser'),
       EXTRACTVALUE(V_XML, '/xml/optuser'),
       EXTRACTVALUE(V_XML, '/xml/rcid'),
      -- EXTRACTVALUE(V_XML, '/xml/symptom'),
      EXTRACTVALUE(V_XML, '/xml/total_class'),
       EXTRACTVALUE(V_XML, '/xml/zhengzhuangdesc'),
       
        EXTRACTVALUE(V_XML, '/xml/vserion'),
        EXTRACTVALUE(V_XML, '/xml/email'),
        EXTRACTVALUE(V_XML, '/xml/m_use_house'),
        EXTRACTVALUE(V_XML, '/xml/d_use_house'),
        EXTRACTVALUE(V_XML, '/xml/m_light'),
        EXTRACTVALUE(V_XML, '/xml/m_type')
       --pk_func.func_get_paystatus(EXTRACTVALUE(V_XML, '/xml/warranty'),EXTRACTVALUE(V_XML, '/xml/rcid'))
     FROM DUAL; 
    
         
    OUT_DATA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_DATA := SQLERRM;
  END;
  --shouji
    PROCEDURE OPEN_dealer_open(IN_DATA IN VARCHAR2, OUT_DATA OUT VARCHAR2) IS
    V_XML XMLTYPE;
  BEGIN
    V_XML := XMLTYPE(IN_DATA);
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
       EXTRACTVALUE(V_XML, '/xml/billno'),
        EXTRACTVALUE(V_XML, '/xml/sn'),
        '6001',
       EXTRACTVALUE(V_XML, '/xml/parttype'),
       EXTRACTVALUE(V_XML, '/xml/model'),     
       EXTRACTVALUE(V_XML, '/xml/appearance'),
       EXTRACTVALUE(V_XML, '/xml/warranty'),
  
       decode(EXTRACTVALUE(V_XML, '/xml/purdate'),'',null,null,null,to_date(EXTRACTVALUE(V_XML, '/xml/purdate'),'yyyy-mm-dd')),
       EXTRACTVALUE(V_XML, '/xml/rcid'),
       EXTRACTVALUE(V_XML, '/xml/total_class'),
       EXTRACTVALUE(V_XML, '/xml/zhengzhuangdesc'),
        EXTRACTVALUE(V_XML, '/xml/m_use_house'),
        EXTRACTVALUE(V_XML, '/xml/d_use_house'),
        EXTRACTVALUE(V_XML, '/xml/m_type'),
        sysdate,
         EXTRACTVALUE(V_XML, '/xml/traceno'),
         EXTRACTVALUE(V_XML, '/xml/tracename'),
          EXTRACTVALUE(V_XML, '/xml/optuser')
       --pk_func.func_get_paystatus(EXTRACTVALUE(V_XML, '/xml/warranty'),EXTRACTVALUE(V_XML, '/xml/rcid'))
     FROM DUAL; 
    
         
    OUT_DATA := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      OUT_DATA := SQLERRM;
  END;
   --初检测维修操作
  PROCEDURE First_Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng2      IN VARCHAR2,
                     in_test_code    IN VARCHAR2,
                     in_test_desc IN VARCHAR2,
                     in_m_nbr      IN VARCHAR2,
                     in_d_nbr  IN VARCHAR2,
                     in_m_hour    IN VARCHAR2,
                     in_d_hour   IN VARCHAR2, 
                     in_power_on in varchar2,
                     in_power_off in varchar2,
                     in_test_result in varchar2,
                     in_is_end in varchar2,
                     in_opt_user  in varchar2,
                     out_ret      OUT VARCHAR2) is
  --  v_rma_status varchar(32);
  
  begin
  
    update bills
       set 
           engineer2    = in_eng2,
           test_code     = in_test_code,
           test_Desc    = in_test_desc,
           M_NBR    = in_m_nbr,
           D_NBR     = in_d_nbr,
           M_USE_HOUSE   = in_m_hour,
            D_USE_HOUSE   = in_d_hour,
            POWER_ON   = in_power_on,
            POWER_OFF   = in_power_off,
            TEST_RESULT=  in_test_result,
            IS_END=in_is_end,
           opt_user     = in_opt_user,
           opt_date     = sysdate         
     where bill_no = in_bill_id;
      -- and status in ('4002');
    if in_is_end = 'Y' then
      
      update bills
         set is_end      = 'Y',
             status      = '4004',
             fix_date     = sysdate
       where bill_no = in_bill_id;
       --  and status in ('4003');
    end if;
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变1!';
    end if;
    exception
    when others then
      out_ret := sqlerrm;
   end First_Test_Fix;
      --检测维修操作
  PROCEDURE Sencond_Test_Fix(in_bill_id   IN VARCHAR2,
                     in_eng3      IN VARCHAR2,
                     in_fix_code    IN VARCHAR2,
                     in_fix_desc IN VARCHAR2,
                     in_is_end      IN VARCHAR2,
                     in_fix_nbr  IN VARCHAR2,
                     in_fix_light    IN VARCHAR2,
                     in_opt_user  in varchar2,
                     out_ret      OUT VARCHAR2) is
  --  v_rma_status varchar(32);
  
  begin
  
    update bills
       set 
           engineer3    = in_eng3,
           FIX_CODE     = in_fix_code,
           FIX_DESC    = in_fix_desc,
           FIX_NBR	    = in_fix_nbr,
           FIX_LIGHT     = in_fix_light,
            IS_END=in_is_end,
           opt_user     = in_opt_user,
           opt_date     = sysdate         
     where bill_no = in_bill_id;
      -- and status in ('4002');
    if in_is_end = 'Y' then
      
      update bills
         set is_end      = 'Y',
             status      = '4004',
             fix_date     = sysdate
       where bill_no = in_bill_id;
       --  and status in ('4003');
    end if;
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变1!';
    end if;
    exception
    when others then
      out_ret := sqlerrm;
   end Sencond_Test_Fix;
    --申请信备件
  PROCEDURE insert_part_list_app(in_bill_id  IN VARCHAR2,
                             in_pn   IN VARCHAR2,
                             in_PART_SN   IN VARCHAR2,
                             in_name in varchar2,
                             in_desc in varchar2,                        
                             in_userid   IN VARCHAR2,
                             in_chanid   IN VARCHAR2,
                             in_stock_id in varchar2,
                             in_ovo_flag in varchar2,
                             out_ret     OUT VARCHAR2) is
  --  v_num varchar2(32);
  v_cont integer;
  begin
  
  select count(1) into v_cont from parts where send_stock_id=in_stock_id ;
  if v_cont>0 then 
    out_ret := '库存已使用，请直接申备。!';
    return;
  end if;
  
   
      insert into parts
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
      values
        (seq_part_list_id.nextval,
         in_bill_id,
         '8000',
         in_pn,
         in_chanid,
         in_PART_SN,
         in_name,
         in_desc,
         sysdate,
         in_stock_id,
         in_ovo_flag,
         in_userid
         );
     
     if sql%rowcount = 1 then  
      update bills set status='4003' where  bill_no=in_bill_id;
       if in_stock_id is not null then  
     update stock_list set status='F' ,opt_date=sysdate,opt_user=in_userid
     where stock_id=in_stock_id and status='N' and pn_no=in_pn;
      if sql%rowcount = 1 then
        
      out_ret := 'OK';
     else
      out_ret := '库存保存不成功!';
     end if;
     else 
      out_ret := 'OK';  
     end if;
   else
      out_ret := '保存备件不成功!';
    end if;
  exception
    when others then
      out_ret := sqlerrm;
  end insert_part_list_app;
   PROCEDURE fix_station_rvc(
                             in_bill_id  in varchar2,
                             in_memo in varchar2,
                             in_app_flag in varchar2,
                             in_opt_user in varchar2,
                             in_bill_status  in varchar2,
                             out_ret     OUT VARCHAR2) is
   
  begin
    update bills_dealer p
       set status = in_bill_status,
           RVC_USER_ID=in_opt_user,
           RVC_DATE=sysdate,
           RVC_MEMO=in_memo,
           RVC_FLAG=in_app_flag
     where bill_no = in_bill_id
       and status = '6001';
     
   dbms_output.put_line('2：'||sql%rowcount );
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '收机失败';
    end if;
  exception
    when others then
      out_ret := sqlerrm;
  end fix_station_rvc;
   PROCEDURE update_dealer_RVC(
                             in_bill_id  in varchar2,
                             in_opt_user in varchar2,
                             in_bill_status  in varchar2,
                             out_ret     OUT VARCHAR2) is
   
  begin
    update bills_dealer p
       set status = in_bill_status,
           DEALER_RVC_USER_ID=in_opt_user,
           DEALER_RVC_DATE=sysdate
     where bill_no = in_bill_id;
      -- and status = '6001';
     
   dbms_output.put_line('2：'||sql%rowcount );
    if sql%rowcount = 1 then
      out_ret := 'OK';
    else
      out_ret := '收机失败';
    end if;
  exception
    when others then
      out_ret := sqlerrm;
  end update_dealer_RVC;
  --取机操作
  PROCEDURE GetOutStation(in_bill_id   IN VARCHAR2,
                          in_engid     IN VARCHAR2,
                          in_is_satify IN VARCHAR2,
                          in_addvise   IN VARCHAR2,
                          in_getmemo   IN VARCHAR2,
                          in_opt_user  in varchar2,
                          in_fix_money in varchar2,
                          in_billtype  in varchar2,
                          in_traceno   in varchar2,
                          in_tracename in varchar2,
                          out_ret      OUT VARCHAR2) is
  
  begin
  
    update bills
       set status      = '4005',
           end_user    = in_engid,
           is_satify   = in_is_satify,
           cust_advice = in_addvise,
           getout_memo = in_getmemo,
           end_date    = sysdate,
           opt_user    = in_opt_user,
           opt_date    = sysdate,
           fix_money   = in_fix_money
     where bill_no = in_bill_id
       and status = '4004';
    if sql%rowcount = 1 then
      if in_billtype = 'D' then
        update bills_dealer
           set RETURN_DATE       = sysdate,
               RETURN_USER_ID    =in_opt_user,
               RETURN_TRACE_NO   = in_traceno,
               RETURN_TRACE_NAME = in_tracename
         where bill_no = in_bill_id;
      end if;
      out_ret := 'OK';
    else
      out_ret := '维修单不存在或者状态已改变2!';
    end if;
  
  exception
    when others then
      out_ret := sqlerrm;
  end GetOutStation;
end PK_FIX;
/
