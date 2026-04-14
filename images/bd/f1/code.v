module top_module(clk, rst, valid, real_a, imag_a, real_b, imag_b, real_out, imag_out);input clk, rst;
input valid;
input signed [31:0] real_a, imag_a;
input signed [31:0] real_b, imag_b;
output signed [31:0] real_out;
output signed [31:0] imag_out;

reg signed [31:0] real_out;
reg signed [31:0] imag_out;

always@(posedge clk or posedge rst)
	if(rst)
	begin
		real_out <= 0;
		imag_out <= 0;
	end
	else if(valid)
	begin
		real_out <= real_a + real_b;
		imag_out <= imag_a + imag_b;
	end


endmodule