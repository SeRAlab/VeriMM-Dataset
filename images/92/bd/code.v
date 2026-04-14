module top_module(address,in,out,write,clk);input [7:0] in;
input clk,write;
input [14:0] address;
output  [7:0] out;
reg [7:0] mem [0:255];

reg [14:0] addreg;
always @(negedge clk)
begin

if(write ==1'b0)
begin
	mem[address] <= in;
	addreg <= address;
end

end

assign out = mem[addreg];	
endmodule