module top_module(D, clock, enable, Q);parameter WIDTH = 32; 
  parameter DEPTH = 1; 
  input [WIDTH-1:0] D; 
  input clock, enable; 
  output [WIDTH-1:0] Q; 
  reg [WIDTH-1:0] local_ffs [0:DEPTH-1]; 
  genvar i; 
  generate 
  for(i = 0; i<=DEPTH-1; i = i+1) 
  begin : local_register 
  always @(posedge clock) 
  if (enable) 
  if (i==0) 
  local_ffs[0] <= D; 
  else 
  local_ffs[i] <= local_ffs[i-1]; 
  end 
  endgenerate 
  assign Q = local_ffs[DEPTH-1]; 
 endmodule