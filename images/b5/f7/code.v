module top_module(
input wire 			clk,
input wire 	[7:0]	io,
output reg [7:0]    d0,
output reg [7:0]    d1
);reg[7:0] dp0;
reg[7:0] dn0;
always@(posedge clk)
begin
	dp0<=io;
end

always@(negedge clk)
begin
	dn0=io;
end

always@(posedge clk)
begin
	d0<=dp0;
	d1<=dn0;
end

endmodule