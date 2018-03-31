create or replace trigger "TRIGGERS_PARTS" 
   before INSERT OR UPDATE on parts
  for each row
declare
  -- local variables here
begin
   if :new.back_type='1302' or :new.back_type='1303'  then 
  update stock_list 
  set  status='N' 
  where stock_id=:old.send_stock_id and status='F';
    IF SQL%ROWCOUNT != 1 THEN
          RAISE_APPLICATION_ERROR('-20001',
                                  :NEW.PARTS_ID || '更新失败B!');
       /* else
       update parts set status='8001', send_flag=null,send_date= null,back_flag='N',back_date=null,back_type=''
       where parts_id= :NEW.PARTS_ID and bill_id=:new.bill_id;
          IF SQL%ROWCOUNT != 1 THEN
          RAISE_APPLICATION_ERROR('-20002',
                                  :NEW.PARTS_ID || '更新失败B!'); 
                                  end if;*/
      END IF;
   end if;
  /*  IF INSERTING THEN 
     update bills set status='4003' where bill_no=:new.bill_id and status='4002' ; 
   end if;*/ 
  /*   if :new.back_type='1301' and :new.status='8004' and :new.get_flag='Y' then 
  update stock_list 
  set  status='R' 
  where stock_id=:new.send_stock_id and status='F';
    IF SQL%ROWCOUNT != 1 THEN
          RAISE_APPLICATION_ERROR('-20004',
                                  :NEW.PARTS_ID || '寄存备件不存在B!');
        END IF;
   end if;*/
end TRIGGERS_Parts;
/
