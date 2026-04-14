module top_module(
	input clk,
	input reset,					
	input D_En,							
	input [31:0] IR,
	input [31:0] pc,
	input [31:0] pc8,
	output reg [31:0] IR_D,
	output reg [31:0] pc_D,
	output reg [31:0] pc8_D
    );always @ (posedge clk) begin
		if(reset) begin
			IR_D 	<= 0;
			pc_D	<= 0;
			pc8_D	<= 0;
		end
		else if(D_En) ;
		else begin
			IR_D	<= IR;
			pc_D	<= pc;
			pc8_D	<= pc8;
		end
	end

endmodule