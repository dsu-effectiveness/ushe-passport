
--Error scripts for the financial aid file



--P01A - Institution
select *
from ushe_passport_2020
where p_inst = ''
or p_inst is null;


--P02A - Year
select *
from ushe_passport_2020
where p_fis_year is null;

--P02B - Financial Aid Year
select *
from ushe_passport_2020
where p_fis_year not in ('1920');

--P02C - Term
select p_date, p_TERM, p_ID, p_BANNER_ID
from ushe_passport_2020
where (p_term != '202023'
or p_term is null);

--P03A - ID
select distinct p_date, p_fis_year, p_id, p_banner_id
from ushe_passport_2020
where (p_id is null
or p_id = '');

--P03B - ID in students table
select distinct p_date, p_ID, p_banner_id
from ushe_passport_2020
where p_id not in (select s_id from students03@dscir where s_inst = '3671')
order by p_banner_id;


--P-03c invalid p_ID, 9/17/2015 JRNolasco; edited by EGuinto 03/09/2016 to populate single institution
select p_date, p_id, p_banner_id,
	(case 
		when p_ID in ('078051120','111111111','123456789','219099999')
			or (p_ID >= '987654320' and p_ID <= '987654329') 
			or p_ID='999999999'
			then 'dummy p_ID'
		when p_ID like '000%' then 'cant begin w/ 000'
		when p_ID like '666%' then 'cant begin w/ 666'
		when p_ID like '9%'	then 'cant begin w/ 9'
		when len(p_ID)<9 then 'not 9 digits'
		when p_ID like '%[a-z]%' then 'contains nondigit'
		when substring(p_ID,4,2)='00' then 'middle cant be 00'
		when substring(p_ID,6,4)='0000'	then 'last four cant be 0000'
		when p_ID=p_BANNER_ID then 'banner_ID'
		when (right(p_ID,8) like right(p_BANNER_ID,8) 
			and p_INST in ('3677','3680','3678','5220','5221','63'))
			then 'like banner_ID'
		when (right(p_ID,7) like right(p_BANNER_ID,7) 
			and p_INST in ('3675','3679','3671','4027'))
			then 'like banner_ID'
	end) as p_ID_error
from ushe_passport_2020
where (p_ID in ('078051120','111111111','123456789','219099999')
or (p_ID >= '987654320' and p_ID <= '987654329') 
or p_ID='999999999' or p_ID like '000%' or p_ID like '666%' or p_ID like '9%'
or p_ID like '%[a-z]%' or len(p_ID)<9
or substring(p_ID,4,2)='00' or substring(p_ID,6,4)='0000'
or (right(p_ID,8) like right(p_BANNER_ID,8) and p_INST in ('3677','3680','3678','5220','5221','63'))
or (right(p_ID,7) like right(p_BANNER_ID,7) and p_INST in ('3675','3679','3671','4027')))
order by p_ID_error,p_ID;


--P04A - Banner ID
select p_date, p_ID, p_banner_id
from ushe_passport_2020
where (p_banner_id = ''
or p_banner_id is null);

--P04B - Banner ID in students table
select distinct  p_date, p_ID, p_banner_id
from ushe_passport_2020
where p_banner_id not in (select s_banner_id from students03@dscir);

--P05 - P_Type
select * from ushe_passport_2020
where p_type NOT IN ('P1', 'P2');


