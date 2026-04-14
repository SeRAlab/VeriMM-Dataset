module top_module(Rout_hi, Rout_low, clr, clk, write_enable, input_value);input clr,clk, write_enable;
	input [63:0] input_value;
	output [31:0]Rout_hi, Rout_low;
	reg[31:0] Rout_hi, Rout_low;

	always @ (posedge clk)begin
		if(write_enable == 1) begin
			Rout_hi = input_value[63:32];
			Rout_low = input_value[31:0];
			end
		else if(clr) begin
			Rout_hi = 0;
			Rout_low = 0;
			end
	end
	
endmodule