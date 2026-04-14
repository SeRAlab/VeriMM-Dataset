module top_module(input [31:0] X,input [31:0] Y,output reg [31:0] Dout,input CLK);always @(posedge CLK) 
 begin 
  Dout <= X ^ Y; 
 end 
 endmodule