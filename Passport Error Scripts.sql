select *
from loads.dbo.passport_ext1718
where p_inst = '3679'

--Error scripts for the financial aid file

--P01A - Institution
select *
from loads.dbo.passport_ext1718
where p_inst = '' 
or p_inst is null

--delete from loads.dbo.passport_ext1718 where p_inst is null

--P01B - Matching Institution*
select distinct s_inst, loads.dbo.passport_ext1718.*
into #inst
from loads.dbo.passport_ext1718, production.dbo.students
where p_id = s_id
and p_inst = s_inst
and p_inst = '3679'

select distinct '' [F01B - No matching enrollment], p_INST, p_fis_year, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where p_id not in (select p_id from #inst)
and p_inst = '3679'
order by p_BANNER_ID

drop table #inst

--P02A - Year
select *
from loads.dbo.passport_ext1718
where p_fis_year is null
and p_inst = '3679'

--P02B - Financial Aid Year
select *
from loads.dbo.passport_ext1718
where p_fis_year not in ('1617')
and p_inst = '3679' 


--P02C - Term
select '' [F02C - Missing Term], p_INST, p_date, p_TERM, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where (p_term not in ('1','2','3')
or p_term is null)
and p_inst = '3679'

--P03A - ID
select distinct '' [F03A - Missing p_ID], p_INST, p_date, p_fis_year, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where (p_id is null
or p_id = '')
and p_inst = '3679'

--P03B - ID in students table
select distinct '' [F03B - p_ID not in students table], p_INST, p_date, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where p_id not in (select s_id from production.dbo.students where s_inst = '3679')
and p_inst = '3679'
order by p_BANNER_ID


--P-03c invalid p_ID, 9/17/2015 JRNolasco; edited by EGuinto 03/09/2016 to populate single institution
select ''[F03C: Invalid p_ID], p_INST, p_date, p_ID, p_BANNER_ID, 
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
from loads.dbo.passport_ext1718
where (p_ID in ('078051120','111111111','123456789','219099999')
or (p_ID >= '987654320' and p_ID <= '987654329') 
or p_ID='999999999' or p_ID like '000%' or p_ID like '666%' or p_ID like '9%'
or p_ID like '%[a-z]%' or len(p_ID)<9
or substring(p_ID,4,2)='00' or substring(p_ID,6,4)='0000'
or (right(p_ID,8) like right(p_BANNER_ID,8) and p_INST in ('3677','3680','3678','5220','5221','63'))
or (right(p_ID,7) like right(p_BANNER_ID,7) and p_INST in ('3675','3679','3671','4027')))
and p_inst = '3679'
order by p_ID_error,p_ID


--P04A - Banner ID
select '' [F04A - Banner ID not in students table], p_INST, p_date, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where (p_banner_id = ''
or p_banner_id is null)
and p_inst = '3679'

--P04B - Banner ID in students table
select distinct '' [F04B - Banner ID in students table], p_INST, p_date, p_ID, p_BANNER_ID
from loads.dbo.passport_ext1718
where p_banner_id not in (select s_banner_id from production.dbo.students)
and p_inst = '3679'

--P05 - P_Type
select * from loads.dbo.passport_ext1718
where p_type NOT IN ('p1', 'p2') 


