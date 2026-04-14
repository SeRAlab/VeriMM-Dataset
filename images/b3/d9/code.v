module top_module(
	input [7:0] x,
	input [7:0] y,
	output out
);wire [9:0] and_outputs;
wire [4:0] or_outputs;

genvar i;

generate
	// Create 8 AND gates
	for(i = 0; i < 8; i = i + 1)
	begin: and_1st_row
		assign and_outputs[i] = x[i] & y[i];
	end
	
	// Create 4 OR gates
	for(i = 0; i < 4; i = i + 1)
	begin: or_2nd_row
		assign or_outputs[i] = and_outputs[2 * i] | and_outputs[2 * i + 1];
	end

	// Create 2 AND gates
	assign and_outputs[8] = or_outputs[0] & or_outputs[1];
	assign and_outputs[9] = or_outputs[2] & or_outputs[3];
	
	// Create 1 OR gate
	assign out = and_outputs[8] | and_outputs[9];

endgenerate

endmodule