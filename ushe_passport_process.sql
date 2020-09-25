
 ------------------------------------------------------------------------------------------------------------
 /*
    PASSPORT SUBMISSION FILE
    MARCH 1, 2017 
    
    File Description
    
    This file is designed to identify who and when a student was awarded a General Educations Passport as 
    defined by the Passport project.  The information will be used to update the records in the USHE database 
    with the purpose of studying the effectiveness of the passport credential.
    ----------------------------------------------
    
    Capture Date
    The capture date for the Passport Data Submission File is June 30 of each year.  (Report all General 
    Education Passports conferred by your institution between July 1 of the previous calendar year and 
    June 30 of the current calendar year.  
    
    Submission File Usage
    The Passport Data Submission File is used for reporting and assessment of the Passport credential.
    
    Submission File Naming Convention
    The Passport Data Submission File should be named as follows:  
    •	School short name (hyphen) grad (hyphen) two digit fiscal ending year .txt file extension  
    •	Example:  wsu-PassPt-16.txt for Weber State University’s Passport Data Submission File for the 
    fiscal year of 2015-2016.
    
    Delimiter
    The Passport Data Submission File may be submitted in either fixed field or delimited format.  A single 
    pipe symbol ‘|’ will be used as the delimiter.  When submitting a delimited file, the pipe symbol must 
    appear between each field in the file (Note: some data elements will have multiple fields, e.g. name has 
    4 fields).  Column spacing references are provided below for those wishing to submit data in a fixed 
    length format.

 */
 ------------------------------------------------------------------------------------------------------------
 -- CREATE
 
 /*

    CREATE TABLE ushe_passport_2020
    (
      pidm        VARCHAR2(8),
      p_id        VARCHAR2(9),
      p_last      VARCHAR2(60),
      p_first     VARCHAR2(15),
      p_middle    VARCHAR2(15),
      p_suffix    VARCHAR2(4),
      p_date      VARCHAR2(8),
      p_type      VARCHAR2(6),
      p_banner_id VARCHAR2(9),
      p_fis_year  VARCHAR2(4),
      p_term      VARCHAR2(6)
    );
 */
 ------------------------------------------------------------------------------------------------------------
 -- INSERT

    TRUNCATE TABLE ushe_passport_2020;
    INSERT INTO ushe_passport_2020
    SELECT DISTINCT
        -- shrtmcm_comment,
           shrtmcm_pidm,
           nvl(spbpers_ssn,spriden_id),
           spriden_last_name,
           CAST(spriden_first_name AS VARCHAR(15)),
           CAST(spriden_mi AS VARCHAR2(15)),
           CAST(spbpers_name_suffix AS VARCHAR2(4)),
           to_char(shrtmcm_effective_date,'YYYYMMDD'),
           'P2',
           'D' || spriden_id,
           '1920',
           '202023'
    FROM   shrtmcm, spriden, spbpers
    WHERE  shrtmcm_pidm = spriden_pidm
    AND    shrtmcm_pidm = spbpers_pidm
    AND    spriden_change_ind IS NULL
    AND    upper(shrtmcm_comment) LIKE '%PASSPORT%'
    AND    to_char(shrtmcm_effective_date,'YYYYMMDD') BETWEEN '20190630' AND '20200701'; -- Update Yearly.


    COMMIT;

/* Manual Fixes */
UPDATE ushe_passport_2020
SET p_id = '000353948'
WHERE p_id = '855041470';

UPDATE ushe_passport_2020
SET p_id = '000369609'
WHERE p_id = '064576257';

UPDATE ushe_passport_2020
SET p_id = '000354774'
WHERE p_id = '781721889';

UPDATE ushe_passport_2020
SET p_id = '000365814'
WHERE p_id = '787012511';

UPDATE ushe_passport_2020
SET p_id = '000369609'
WHERE p_id = '64576257';

UPDATE ushe_passport_2020
SET p_id = '000398133'
WHERE p_id = '369991298';

COMMIT;

 ------------------------------------------------------------------------------------------------------------
 -- Export

    SELECT '3671' AS p_inst,
           p_id,
           p_last,
           p_first,
           p_middle,
           p_suffix,
           p_date,
           p_type,
           p_banner_id,
           p_fis_year,
           SUBSTR(p_term,5,1) AS p_term
    FROM   ushe_passport_2020;

 -- Confirm
    SELECT p_date, count(*)
    FROM   ushe_passport_2020
    GROUP  BY p_date
    ORDER  BY p_date;

 ------------------------------------------------------------------------------------------------------------
 -- end of file

