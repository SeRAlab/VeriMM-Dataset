module top_module(a, b, q, clk);parameter width = 16, cycles=1; 
  input signed [width-1:0] a, b; 
  input clk; 
  output signed [width-1:0] q; 
  reg signed [width-1:0] res[cycles-1:0]; 
  assign q = res[cycles-1]; 
  integer i; 
  always @(posedge clk) begin 
  res[0] <= a-b; 
  for (i=1; i < cycles; i = i+1) 
  res[i] <= res[i-1]; 
  end 
 endmodule