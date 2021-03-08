--Main--
begin
prova_proc;
exception
    when others then
        dbms_output.put_line('[MAIN] unhandled exception:' || sqlerrm);
end;
/

SELECT * FROM prova;

truncate table prova;

--END Main--

--Procedure for Exception Handler test case--
create or replace procedure prova_proc
is 
--SQLCODE
l_err_num number;
--SQLERRM
l_err_desc varchar2(100);
--TEST Result
test_err varchar2(10) := 'TEST_ERR';

this_violation_exception exception;

PRAGMA EXCEPTION_INIT(this_violation_exception, -88888);

begin
insert into prova values(1);
SAVEPOINT A;
insert into prova values(2);
insert into prova values(1);
commit;

IF (test_err = 'TEST_ERR') THEN
    RAISE this_violation_exception;
END IF;

EXCEPTION
    WHEN this_violation_exception THEN
        l_err_num := SQLCODE;
        l_err_desc := SQLERRM;
        dbms_output.put_line('[ERR] violation exception!!!'||l_err_num||' : '||l_err_desc);
        RAISE;
    WHEN OTHERS THEN
        l_err_num := SQLCODE;
        l_err_desc := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('[ERROR]'||l_err_num||' : '||l_err_desc);
        DBMS_OUTPUT.PUT_LINE('SQLCODE :'||l_err_num);
        DBMS_OUTPUT.PUT_LINE('SQLERRM :'||l_err_desc);
        ROLLBACK to A;
        SELECT COD INTO test_err from prova;
        DBMS_OUTPUT.PUT_LINE('TEST_ERR :'||test_err);
        RAISE;
insert into prova values(3);
commit;
end;
/


SELECT * FROM prova;

truncate table prova;

--Configuration
select * from user_tables;
--drop table prova;
create table prova (cod number); 

alter table prova add constraint pk_prova primary key (cod);
