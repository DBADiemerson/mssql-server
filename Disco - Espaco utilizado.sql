select distinct 
			
				dovs.volume_mount_point as drive,
				dovs.logical_volume_name as name,
				convert(int,dovs.total_bytes/1048576.0)/1024 as totalspacegb,
				convert(int,dovs.total_bytes/1048576.0)/1024 - convert(int,dovs.available_bytes/1048576.0)/1024 as usedspacegb,
				convert(int,dovs.available_bytes/1048576.0)/1024 as freespacegb,
				convert(dec(18,2),(convert(int,dovs.total_bytes/1048576.0)/1024 - convert(int,dovs.available_bytes/1048576.0)/1024) / (convert(dec(18,2),(convert(int,dovs.total_bytes/1048576.0)/1024))) * 100) as pctused
				
from sys.master_files mf
cross apply sys.dm_os_volume_stats(mf.database_id, mf.file_id) dovs
order by 1 asc
