module top_module(clk, pad, indata, indata180);parameter WIDTH=32; 
 input clk; 
 input [WIDTH-1:0] pad; 
 output [WIDTH-1:0] indata; 
 output [WIDTH-1:0] indata180; 
 reg [WIDTH-1:0] indata, indata180, next_indata; 
 always @(posedge clk) indata = next_indata; 
 always @(negedge clk) indata180 = next_indata; 
 always @* begin #1; next_indata = pad; end 
 endmodule