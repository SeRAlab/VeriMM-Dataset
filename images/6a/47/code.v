module top_module(id_ex_registerrt, if_id_register_rs, if_id_registerrt, id_ex_memread, pcwrite, if_id_write, id_flush_lwstall);input [4:0] id_ex_registerrt, if_id_register_rs, if_id_registerrt;
	input id_ex_memread;
	output pcwrite, if_id_write, id_flush_lwstall;
	wire equal_idexrt_ifid_rs,equal_idexrt_ifidrt;
	assign equal_idexrt_ifid_rs=(id_ex_registerrt==if_id_register_rs)?1:0;
	assign equal_idexrt_ifidrt=(id_ex_registerrt==if_id_registerrt)?1:0;
	reg pcwrite, if_id_write, id_flush_lwstall;
	
	always@(id_ex_memread or equal_idexrt_ifid_rs or equal_idexrt_ifidrt)
	begin
		if(id_ex_memread & (equal_idexrt_ifid_rs|equal_idexrt_ifidrt))
		begin pcwrite<=0;if_id_write<=0;id_flush_lwstall<=1; end
		else 
		begin pcwrite<=1;if_id_write<=1;id_flush_lwstall<=0; end
	end
endmodule