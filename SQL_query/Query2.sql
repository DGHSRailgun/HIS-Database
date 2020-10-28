USE his;
SELECT
	( max( DrugsPrice ) - min( DrugsPrice ) ) AS '最大单价和最小单价之差' 
FROM
	drugs;