module top_module(input [15:0] x,output [15:0] o,output cfo,output ofo);assign o = ~x; 
  assign cfo = 1'b0; 
  assign ofo = 1'b0; 
 endmodule