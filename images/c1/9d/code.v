module rf_dist(
	a,
	d,
	dpra,
	clk,
	we,
	spo,
	dpo);
input [4 : 0] a;
input [31 : 0] d;
input [4 : 0] dpra;
input clk;
input we;
output [31 : 0] spo;
output [31 : 0] dpo;
reg	[31:0]		mem [31:0];
integer i;
initial begin
	for (i = 0; i < 32; i = i + 1) begin
		mem[i] <= 32'h0;
	end
end
always @(posedge clk)
	if (we) mem[a] <= #1 d;
assign spo = mem[a];
assign dpo = mem[dpra];
endmodule