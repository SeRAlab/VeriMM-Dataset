module top_module(clk, indata, outdata);parameter WIDTH = 1;
input clk;
input [WIDTH-1:0] indata;
output [WIDTH-1:0] outdata;
reg [WIDTH-1:0] outdata, next_outdata;
always @(posedge clk) outdata = next_outdata;
always @*
begin
  #1;
  next_outdata = indata;
end
endmodule