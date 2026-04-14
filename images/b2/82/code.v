module top_module(clk, rstn, load, shift, parallelin, lsbout);input clk; 
  input rstn; 
  input load; 
  input shift; 
  input [7:0] parallelin; 
  output lsbout; 
  reg [7:0] shiftreg; 
  assign lsbout = shiftreg[0]; 
  always @(posedge clk or negedge rstn) begin 
  if(rstn == 0) 
  shiftreg <= 0; 
  else begin 
  if(load == 1) 
  shiftreg <= parallelin; 
  else if (shift == 1) begin 
  shiftreg[6:0] <= shiftreg[7:1]; 
  shiftreg[7] <= 0; 
  end 
  end 
  end 
 endmodule