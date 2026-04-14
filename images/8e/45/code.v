module top_module(
	input sys_clk,
	input alu_rst,

	input [31:0] a,
	input [31:0] b,
	input valid_i,

	output reg [31:0] r, // Change 'wire' to 'reg'
	output reg valid_o
);reg [31:0] abs_a;
reg [31:0] abs_b;
reg [31:0] abs_r;
reg [1:0] sign;
reg [31:0] a_div_b;

always @(posedge sys_clk) begin
	if(alu_rst) begin
		valid_o <= 1'b0;
		r <= 32'b0; // Initialize r on reset
	end
	else begin
		valid_o <= valid_i;

		// Calculate absolute values of inputs
		if(a[31] == 1)
			abs_a = ~a + 1;
		else
			abs_a = a;

		if(b[31] == 1)
			abs_b = ~b + 1;
		else
			abs_b = b;

		// Determine sign of output
		if(a[31] == 0 && b[31] == 0)
			sign = 2'b00; // both inputs are positive
		else if(a[31] == 1 && b[31] == 0)
			sign = 2'b01; // a is negative, b is positive
		else if(a[31] == 0 && b[31] == 1)
			sign = 2'b10; // a is positive, b is negative
		else if(a[31] == 1 && b[31] == 1)
			sign = 2'b11; // both inputs are negative

		// Calculate output based on sign
		case(sign)
			2'b00: abs_r = 32'h3f800000; // positive / positive = 1.0
			2'b01: abs_r = 32'h80000000; // negative / positive = -0.0
			2'b10: abs_r = 32'h00000000; // positive / negative = +0.0
			2'b11: abs_r = 32'hbf800000; // negative / negative = -1.0
			default: abs_r = 32'b0;      // Default case
		endcase

		// Calculate division if inputs have different signs
		if(sign != 2'b00 && sign != 2'b11)
			a_div_b = abs_a / abs_b;

		// Set output based on sign and division
		if(sign == 2'b00 || sign == 2'b11)
			r = abs_r;
		else
			r = {sign[1], a_div_b[22:0]} + abs_r[31:23];
	end
end

endmodule