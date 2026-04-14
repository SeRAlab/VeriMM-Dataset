module top_module(clk,reset,data_in,write,read,wr_addr,rd_addr,data_out);input clk,reset,write,read;
input [7:0]data_in;
input [3:0]wr_addr;
input [3:0]rd_addr;
output reg [7:0] data_out;

parameter width = 8;
parameter depth = 16;

reg [(width-1):0] mem [(depth-1):0];

integer i;

always@(posedge clk)
	begin
	if (reset)
	begin
	for (i = 0; i < depth; i = i+1)
	mem[i] <= 0;
	data_out <= 8'b0;
	end
else if (clk)
	begin
	if (write == 1)
	mem[wr_addr] <= data_in;
else if (read == 1)
	data_out <= mem[rd_addr];
	end
	end
endmodule