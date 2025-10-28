select 
	ses.login_time,
	req.[start_time] [request_start_time], 
	cast(req.total_elapsed_time / 86400000 as varchar)+' '
	+convert(varchar,DATEADD(millisecond, req.total_elapsed_time % 86400000, 0),114) [elapsed_time_h],
	ses.[session_id],
	req.[blocking_session_id],
	ses.[original_login_name],
	ses.[program_name],
	isnull(jbs.name,'') [Job],
	con.[client_net_address],
	db_name(ses.database_id) [Database],
	ses.[host_name],
	req.[status],
	req.[start_time],
	req.[command],
	isnull(object_name(txt.[objectid],txt.[dbid]),'AdHoc') [Object],
	req.[wait_type],
	req.[wait_time],
	req.[last_wait_type],
	req.[cpu_time],
	req.granted_query_memory / 128 [granted_query_memory_mb],
	ses.memory_usage / 128 [memory_usage_mb],
	req.[logical_reads],
	req.[total_elapsed_time],
	txt.[text],
	case 
		when statement_end_offset > 0 
			then substring(txt.[text],(req.statement_start_offset/2)+1,((statement_end_offset - req.statement_start_offset)/2)+1) 
		else 'ver coluna Text' 
	end [Statement],
	pln.query_plan,
	bff.event_info
from sys.dm_exec_requests req
	join sys.dm_exec_sessions ses
		on req.session_id = ses.session_id
	join sys.dm_exec_connections con
		on req.session_id = con.session_id
			and con.net_transport <> 'Session'
	left join msdb.dbo.sysjobs jbs
		on master.dbo.fn_varbintohexstr(convert(varbinary(16), job_id)) = substring(ses.[program_name],30,34)
	outer apply sys.dm_exec_sql_text(sql_handle) txt
	outer apply sys.dm_exec_query_plan(plan_handle) pln
	cross apply sys.dm_exec_input_buffer(req.session_id,null) bff
where req.session_id <> @@spid--= 142
	and ses.is_user_process = 1