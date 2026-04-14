module top_module(
	input clk,
	input signed [11:0] dataa,
	input signed [11:0] datab,
	output reg signed [23:0] dataout
);reg signed [11:0] dataa_reg;
	reg signed [11:0] datab_reg;
	wire signed [23:0] mult_out;

	
	assign mult_out = dataa_reg * datab_reg;

	
	always @ (posedge clk)
	begin
		dataa_reg <= dataa;
		datab_reg <= datab;
		dataout <= mult_out;
	end

endmodule