module top_module( clk, rst_n, load, enable, seed, d, m);parameter k = 23; 
  parameter N = 23; 
  input clk; 
  input rst_n; 
  input load; 
  input enable; 
  input [N-1:0] seed; 
  input [N-1:0] d; 
  output [N-1:0] m; 
  reg [N-1:0] m; 
  reg [N-1:0] tmpa; 
  reg [N-1:0] tmpb; 
  integer i,j; 
  always @ (d) 
  begin 
  tmpa = d; 
  for (i=0; i<k; i=i+1) 
  begin 
  for (j=0; j<(N-1); j=j+1) begin tmpb[j] = tmpa[j+1]; end 
  tmpb[N-1] = tmpa[18] ^ tmpa[0]; 
  tmpa = tmpb; 
  end 
  end 
  always @(posedge clk or negedge rst_n) 
  begin 
  begin 
  if (!rst_n) m <= 0; 
  else if (load) m <= seed; 
  else if (enable) m <= tmpb; 
  end 
  end 
  endmodule