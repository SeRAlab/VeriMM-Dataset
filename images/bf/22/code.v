module top_module(
	input clk,
	input pRST,
	input cpu_wr_n,
	input [8:0] cpu_addr,
	input [31:0] cpu_wdata,
	
	output reg [31:0] packet_head,
	output reg [15:0] flag_set,
	output reg [23:0] length_set,
	output reg scramble,
		
	output reg error
	);always @(posedge clk or posedge pRST)
if(pRST)
	packet_head<=0;
else
	if((cpu_wr_n==0) && (cpu_addr==200))
		packet_head<=cpu_wdata;	
		
always @(posedge clk or posedge pRST)
if(pRST)
	flag_set<=0;
else
	if((cpu_wr_n==0) && (cpu_addr==201))
		flag_set<=cpu_wdata[15:0];
		
always @(posedge clk or posedge pRST)
if(pRST)
	length_set<=0;
else
	if((cpu_wr_n==0) && (cpu_addr==202))
		length_set<=cpu_wdata[23:0];
		
always @(posedge clk or posedge pRST)
if(pRST)
	scramble<=0;
else
	if((cpu_wr_n==0) && (cpu_addr==203))
		scramble<=cpu_wdata[0];
		
endmodule