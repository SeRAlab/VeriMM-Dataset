module top_module(reset,address,in,out,write,clk, testWire);input [7:0] in;
input clk,write,reset;
input [14:0] address;
output  reg [7:0] out;
output wire [7:0] testWire;
reg [7:0] mem [0:255];
integer i;
assign testWire = mem[0];

always @(negedge clk)
begin

out = mem[address];	
if(reset== 1'b0)
begin
for(i=0;i<256;i=i+1)
mem [i] = 0;
mem[0] = 8'b10010010;
mem[1] = 8'b01100100;
mem[2] = 8'b00010110;
end
if(write ==1'b0)
begin
	mem[address] <= in;
end

end

endmodule