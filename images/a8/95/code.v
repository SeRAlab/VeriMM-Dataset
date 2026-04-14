module top_module(
	address,
	q);input[9:0] address;
output[31:0] q;
reg [31:0] memory[0:1023];
assign	q = memory[address];
endmodule