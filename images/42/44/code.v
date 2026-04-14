module top_module(
	input sys_clk,

	input we,
	input [2:0] wa,
	input [31:0] wd,

	input [1:0] ra,
	output [63:0] rd
);reg [31:0] mem1[0:3];
reg [31:0] mem1_do;
always @(posedge sys_clk) begin
	if(we & ~wa[0])
		mem1[wa[2:1]] <= wd;
	mem1_do <= mem1[ra];
end

reg [31:0] mem2[0:3];
reg [31:0] mem2_do;
always @(posedge sys_clk) begin
	if(we & wa[0])
		mem2[wa[2:1]] <= wd;
	mem2_do <= mem2[ra];
end

assign rd = {mem1_do, mem2_do};

endmodule