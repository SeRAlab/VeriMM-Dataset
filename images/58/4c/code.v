module top_module(
	input clk,
	input nRST,
	input SW_WR,		
	input SW_RD,		
	input 	[47:0]	LBA_BEGIN,
	input 	[47:0]	LBA_END,
	input	[7:0]	test,
	
	output reg	begin_work,
	output reg	nWRpRD,
	output reg	start_WR,
	output reg	start_RD,
	output reg  [47:0]begin_LBA,
	output reg  [47:0]end_LBA
	
	);reg [31:0] count;	



reg SW_WR_REG,SW_RD_REG;

always@(posedge clk)
begin
	SW_WR_REG <= SW_WR;
	SW_RD_REG <= SW_RD;
	begin_LBA <= LBA_BEGIN;
	end_LBA <= LBA_END;
end

always@(posedge clk or negedge nRST)
begin
if(!nRST)
	begin
		start_WR <= 1'd0;
		start_RD <= 1'd0;
		begin_work <= 1'd0;
		nWRpRD <= 1'd0;
	end
else
	begin
		if(SW_WR_REG)			
		begin
			start_WR <= 1'd1;
			start_RD <= 1'd0;
			begin_work <= 1'd1;
			nWRpRD <= 1'd0;
		end
		else if(SW_RD_REG)			
		begin
			start_WR <= 1'd0;
			start_RD <= 1'd1;
			begin_work <= 1'd1;
			nWRpRD <= 1'd1;
		end
		else
		begin
			start_WR <= 1'd0;
			start_RD <= 1'd0;
			begin_work <= 1'd0;
			nWRpRD <= 1'd0;
		end
	end
end

endmodule