create or replace trigger "TRIGGERS_STOCK" 
  before INSERT OR UPDATE on upload_inf
  for each row
declare
  v_qty integer;
  v_err EXCEPTION;
  -- local variables here
begin
  
  IF :NEW.STATUS = 'C' AND :OLD.STATUS = 'N' then
    v_qty:=:old.qty;
    if v_qty is null or v_qty<0 then 
      RAISE v_err;
    END IF;
   for i in 1..v_qty loop  
  insert into stock_list
      (stock_id,
       pn_no,
       imei,
       PN_DESC,
       chan_id,
       in_date,
       in_user,
       status,
       opt_date,
       opt_user)
    values
      (seq_stock_id.nextval,
       :new.pn_no,
       :new.imei,
       :new.PN_DESC,
       :new.chan_id,
       :new.opt_date,
       :new.opt_user,
       'N',
       sysdate,
       :new.opt_user);
      end loop;  
  end if;
  EXCEPTION
   WHEN v_err THEN     RAISE_APPLICATION_ERROR(-20010, :new.id||'数量不是数字或为空 !');
end Triggers_Stock;
/
