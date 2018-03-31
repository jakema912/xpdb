create or replace package PK_HEDY is

  --DIC_simple����
  function func_get_simple(in_status_id in varchar2) return varchar2;
  --����ʦ����
  function func_get_ENG(in_user_id in varchar2) return varchar2;
  --ά��վ����
  function func_get_chan(in_chan_id in varchar2) return varchar2;

  --��������
  PROCEDURE partapp(in_opt_user IN VARCHAR2, --������
                    in_part_id  IN VARCHAR2,
                    in_status   IN VARCHAR2,
                    in_send_pn  in varchar2,
                    in_memo     in varchar2,
                    out_r       OUT VARCHAR2);
  --ά�޵����乤��ʦ
  PROCEDURE allocater(in_user_id  IN VARCHAR2,
                      in_opt_user IN VARCHAR2,
                      in_bill_no  IN VARCHAR2,
                      in_stn_code IN VARCHAR2,
                      in_type     in varchar2,
                      out_r       OUT VARCHAR2);
  --�ⷿ���ձ���
  procedure part_in(in_opt_user in varchar2,
                    in_part_id  in varchar2,
                    in_stn_code in varchar2,
                    out_r       OUT VARCHAR2);
  --�����ɷ�
  procedure send_part(in_opt_user in varchar2,
                      in_part_id  in varchar2,
                      in_stn_code in varchar2,
                      out_r       OUT VARCHAR2);
  --���ҷ���
  procedure fc_send_part(in_opt_user in varchar2,
                         in_part_id  in varchar2,
                         in_track_no in varchar2,
                         in_stn_code in varchar2,
                         out_r       OUT VARCHAR2);
  --��������
  procedure back_part(in_opt_user in varchar2,
                      in_part_id  in varchar2,
                      in_status   in varchar2,
                      in_wl       in varchar2,
                      in_stn_code in varchar2,
                      out_r       OUT VARCHAR2);
  --����
  procedure fc_part(in_opt_user in varchar2,
                    in_part_id  in varchar2,
                    in_sdno     in varchar2,
                    in_stn_code in varchar2,
                    out_r       OUT VARCHAR2);
  --���ҽ���
  procedure fc_get_part(in_opt_user in varchar2,
                        in_part_id  in varchar2,
                        in_stn_code in varchar2,
                        out_r       OUT VARCHAR2);
  --���Ŀ��
  PROCEDURE usp_change_stock(in_stn_code    IN VARCHAR2,
                             in_pn_no       IN VARCHAR2,
                             in_good_number IN NUMBER,
                             in_bad_number  IN NUMBER);
  --��Account_inf ��������
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
