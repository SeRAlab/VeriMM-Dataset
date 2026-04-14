module top_module(input wire D_I,input wire CLK_I,output reg D_O);reg [1:0] sreg; 
  always@(posedge CLK_I) 
  begin 
  D_O <= sreg[1]; 
  sreg <= {sreg[0],D_I}; 
  end 
 endmodule