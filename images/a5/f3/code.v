module top_module(nrst, clk, en, si, load, pi, po);parameter width = 8; 
  input nrst; 
  input clk; 
  input en; 
  input si; 
  input load; 
  input [width-1:0] pi; 
  output [width-1:0] po; 
  reg [width-1:0] po; 
  always @(posedge clk or negedge nrst) begin 
  if (~nrst) begin 
  po <= 0; 
  end else if (load) begin 
  po <= pi; 
  end else if (en) begin 
  po <= {po[width-2:0], si}; 
  end 
  end 
 endmodule