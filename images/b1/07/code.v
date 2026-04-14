module top_module(
	address_a,
	address_b,
	clock,
	data_a,
	data_b,
	wren_a,
	wren_b,
	q_a,
	q_b
);input 	[5:0]	address_a;
	input 	[5:0]	address_b;
	input 		clock;
	input 	[15:0]	data_a;
	input 	[15:0]	data_b;
	input 		wren_a;
	input 		wren_b;
	output 	[15:0]	q_a;
	output 	[15:0]	q_b;

	reg [15:0] ram [0:63];

	always @(posedge clock) begin
		if (wren_a) ram[address_a] <= data_a;
		if (wren_b) ram[address_b] <= data_b;
	end

	assign q_a = ram[address_a];
	assign q_b = ram[address_b];

endmodule