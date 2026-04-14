module top_module(
	input [31:0] ins_in,
	input [31:0] pc_in,
	
	input clk,
	input reset,
	input stop,
	
	output reg [31:0] ins_d,
	output reg [31:0] pc_d
    );always @(posedge clk) begin
		
		
		if(reset == 0) begin
			if(stop == 0) begin
				ins_d = ins_in;
				pc_d = pc_in;
			end
		end
		
		else begin
			ins_d = 0;
			pc_d = 0;
		end
		
	end
	
	


endmodule