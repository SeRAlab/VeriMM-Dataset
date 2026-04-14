module top_module(
	address,
	clock,
	q);input[7:0] address;
input clock;
output[31:0] q;
reg [31:0] q;
reg [31:0] memory[0:256];
always @(posedge clock)
begin
	q = memory[address];
end
endmodule