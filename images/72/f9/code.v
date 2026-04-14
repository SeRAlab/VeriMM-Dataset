module top_module(output [3:0] addr,input clk,input din,input en);reg [3:0] addrreg = 0; 
  assign addr = addrreg; 
  always @(posedge clk) begin 
  if(en) begin 
  addrreg[3:1] <= addrreg[2:0]; 
  addrreg[0] <= din; 
  end 
  end 
 endmodule