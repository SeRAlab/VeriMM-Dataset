module top_module(input clk,input rst,input in,output out);reg [1:0] state, nextstate; 
  parameter [1:0] Zero = 2'b00, Edge = 2'b01, One=2'b10 ; 
  always @ (*) 
  case (state) 
  Zero: if(in) nextstate = Edge; 
  else nextstate = Zero; 
  Edge: if (in) nextstate = One; 
  else nextstate = Zero; 
  One: if(in) nextstate= One; 
  else nextstate= Zero; 
  default: 
  nextstate = 2'bx; 
  endcase 
  always @ (posedge clk or posedge rst) 
  begin 
  if (rst) state <=Zero; 
  else state <= nextstate; 
  end 
  assign out = (state == Edge); 
 endmodule