create or replace package PK_HEDY is

  --DIC_simple名称
  function func_get_simple(in_status_id in varchar2) return varchar2;
  --工程师姓名
  function func_get_ENG(in_user_id in varchar2) return varchar2;
  --维修站名称
  function func_get_chan(in_chan_id in varchar2) return varchar2;

  --备件审批
  PROCEDURE partapp(in_opt_user IN VARCHAR2, --审批人
                    in_part_id  IN VARCHAR2,
                    in_status   IN VARCHAR2,
                    in_send_pn  in varchar2,
                    in_memo     in varchar2,
                    out_r       OUT VARCHAR2);
  --维修单分配工程师
  PROCEDURE allocater(in_user_id  IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_bill_no  IN VARCHAR2,
                      in_stn_code IN VARCHAR2,
                      in_type     in varchar2,
                      out_r       OUT VARCHAR2);
  --库房接收备件
  procedure part_in(in_opt_user in varchar2,
                    in_part_id  in varchar2,
                    in_stn_code in varchar2,
                    out_r       OUT VARCHAR2);
  --备件派发
  procedure send_part(in_opt_user in varchar2,
                      in_part_id  in varchar2,
                      in_stn_code in varchar2,
                      out_r       OUT VARCHAR2);
  --厂家发货
  procedure fc_send_part(in_opt_user in varchar2,
                         in_part_id  in varchar2,
                         in_track_no in varchar2,
                         in_stn_code in varchar2,
                         out_r       OUT VARCHAR2);
  --备件返还
  procedure back_part(in_opt_user in varchar2,
                      in_part_id  in varchar2,
                      in_status   in varchar2,
                      in_wl       in varchar2,
                      in_stn_code in varchar2,
                      out_r       OUT VARCHAR2);
  --返厂
  procedure fc_part(in_opt_user in varchar2,
                    in_part_id  in varchar2,
                    in_sdno     in varchar2,
                    in_stn_code in varchar2,
                    out_r       OUT VARCHAR2);
  --厂家接收
  procedure fc_get_part(in_opt_user in varchar2,
                        in_part_id  in varchar2,
                        in_stn_code in varchar2,
                        out_r       OUT VARCHAR2);
  --更改库存
  PROCEDURE usp_change_stock(in_stn_code    IN VARCHAR2,
                             in_pn_no       IN VARCHAR2,
                             in_good_number IN NUMBER,
                             in_bad_number  IN NUMBER);
  --向Account_inf 插入数据
  PROCEDURE add_account_inf(in_pn_no       IN VARCHAR2,
                            in_stn_code    IN VARCHAR2,
                            in_type        IN VARCHAR2,
                            in_part_class  IN VARCHAR2,
                            in_reference   IN VARCHAR2,
                            in_opt_user_id IN VARCHAR2,
                            in_remark      IN VARCHAR2,
                            in_sn          IN VARCHAR2);
end PK_HEDY;

 
 
/
