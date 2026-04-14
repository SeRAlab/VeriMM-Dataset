module top_module(	clock, resetn, left_mantissa, right_mantissa, left_sign, right_sign, common_exponent,
										resulting_mantissa, resulting_exponent, resulting_sign,
										valid_in, valid_out, stall_in, stall_out, enable);parameter HIGH_CAPACITY = 1;
	
	
	input clock, resetn, left_sign, right_sign;
	input [26:0] left_mantissa;
	input [26:0] right_mantissa;
	input [8:0] common_exponent;
	input valid_in, stall_in, enable;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) output reg [27:0] resulting_mantissa;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) output reg [8:0] resulting_exponent;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) output reg resulting_sign;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) output reg valid_out;
	output stall_out;
	
	wire enable_add = (HIGH_CAPACITY==1) ? (~valid_out | ~stall_in) : enable;
	wire do_subtraction = right_sign ^ left_sign;
	assign stall_out = valid_out & stall_in;
	wire [27:0] op_ab = left_mantissa + ({28{do_subtraction}} ^ right_mantissa) + do_subtraction;
	
	always@(posedge clock or negedge resetn)
	begin
		if (~resetn)
		begin
			resulting_mantissa <= 28'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			resulting_exponent <= 9'bxxxxxxxx;
			resulting_sign <= 1'bx;
			valid_out <= 1'b0;
		end
		else if (enable_add)
		begin
			valid_out <= valid_in;
			resulting_mantissa <= op_ab;
			resulting_exponent <= common_exponent;
			resulting_sign <= left_sign;
		end
	end
	
endmodule