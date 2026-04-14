module top_module(input [15:0] D0,input [7:0] D1,output wire[15:0] DOUT,input [2:0]OP);reg [15:0] mux; 
  always @* 
  case(OP) 
  0: mux = 0; 
  1: mux = 1; 
  2: mux = 2; 
  3: mux = {D1[7], D1[7], D1[7], D1[7], D1[7], D1[7], D1[7], D1[7], D1[7:0]}; 
  4: mux = 0; 
  5: mux = 16'hffff; 
  6: mux = 16'hfffe; 
  default: mux = 16'hxxxx; 
  endcase 
  assign DOUT = D0 + mux; 
 endmodule