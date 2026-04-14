module top_module(
	input  clk,
	input  sync,
	input  reset,

	
	input sel_async,      
	input sel_sync,       
	input sel_single,     
	input sel_gen,        
	input sel_pg,         

	input sel_dir_async,  
	input sel_dir_sync,   
	input sel_dir_single, 
	input sel_dir_gen,    
	input sel_dir_pg,     

	input sel_chain,      
	input sel_sync_out,   

	
	
	
	input  [4:0]src_async,  
	input  [3:0]src_async_pos,

	
	input  [4:0]src_sync, 
	input  src_sync_direct,

	
	input  [4:0]src_single, 

	
	input  [4:0]src_gen, 

	
	input  [4:0]src_pg, 


	

	
	output [4:0]dst_tbm, 
	output [3:0]dst_tbm_pos,
	
	
	output [4:0]dst_sync, 
	output dst_sync_direct,
	
	
	output [4:0]dst_dir  
);localparam SYN = 0;
	localparam TRG = 1;
	localparam RSR = 2;
	localparam RST = 3;
	localparam CAL = 4;

	
	wire [4:0]src_async_gated  = {5{sel_async}}  & src_async;
	wire [4:0]src_sync_gated   = {5{sel_sync}}   & src_sync;
	wire [4:0]src_single_gated = {5{sel_single}} & src_single;
	wire [4:0]src_gen_gated    = {5{sel_gen}}    & src_gen;
	wire [4:0]src_pg_gated     = {5{sel_pg}}     & src_pg;
	
	wire [4:0]sum = src_async_gated | src_sync_gated
		| src_single_gated | src_gen_gated | src_pg_gated;
	
	assign dst_sync_direct = sel_chain & src_sync_direct;
	
	assign dst_tbm = sum;
	assign dst_sync = {5{sel_sync_out & !sel_chain}} & sum;

	assign dst_tbm_pos = src_async_pos & {4{src_async_gated[1]}};

	
	wire [4:0]src_dir_async_gated  = {5{sel_dir_async}}  & src_async;
	wire [4:0]src_dir_sync_gated   = {5{sel_dir_sync}}   & src_sync;
	wire [4:0]src_dir_single_gated = {5{sel_dir_single}} & src_single;
	wire [4:0]src_dir_gen_gated    = {5{sel_dir_gen}}    & src_gen;
	wire [4:0]src_dir_pg_gated     = {5{sel_dir_pg}}     & src_pg;

	wire [4:0]sum_dir = src_dir_async_gated | src_dir_sync_gated
		| src_dir_single_gated | src_dir_gen_gated | src_dir_pg_gated;
	
	assign dst_dir = sum_dir;

endmodule