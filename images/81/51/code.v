module shift_register (
	input clock,
	input load,
	input [3:0] data_in,
	output reg [3:0] shift_reg);always @(posedge clock) begin
		if (load)
			shift_reg <= data_in;
		else
			shift_reg <= {1'b0, shift_reg[3:1]};
	end
	
	initial shift_reg = 4'b0000;
endmodule