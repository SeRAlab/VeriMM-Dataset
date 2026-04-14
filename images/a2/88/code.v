module top_module(clk,resetn, 
	a_reg, a_readdataout, a_en,
	b_reg, b_readdataout, b_en,
	c_reg, c_writedatain, c_we);parameter WIDTH=32;
parameter NUMREGS=32;
parameter LOG2NUMREGS=5;

input clk;
input resetn;

input a_en;
input b_en;

input [LOG2NUMREGS-1:0] a_reg,b_reg,c_reg;
output [WIDTH-1:0] a_readdataout, b_readdataout;
input [WIDTH-1:0] c_writedatain;
input c_we;

reg [WIDTH-1:0] a_readdataout, b_readdataout;
reg [31:0] rf [31:0];
always @(posedge clk) begin
	if(a_en) begin
		a_readdataout <= rf[a_reg];
	end

	if(b_en) begin
		b_readdataout <= rf[b_reg];
	end

	if(c_we&(|c_reg)) begin
		rf[c_reg] <= c_writedatain;
	end
end


endmodule