create or replace package pk_PN is
  PROCEDURE add_pn_imp(in_pn_no       IN VARCHAR2,
                       in_stn_code    IN VARCHAR2,
                       in_part_class  IN VARCHAR2,
                       in_reference   IN VARCHAR2,
                       in_opt_user_id IN VARCHAR2,
                       in_sn          IN VARCHAR2,
                       in_qty         in varchar2,
                       out_r          OUT VARCHAR2);

end pk_PN;

 
 
/
