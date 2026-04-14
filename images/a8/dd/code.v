module top_module(output sold,input [2:0] cycle);reg [2:0] regsold = 0; 
  assign sold = regsold; 
  always @(cycle) begin 
  regsold = 0; 
  case(cycle) 
  4'h0: 
  regsold = 1; 
  4'h1, 4'h2, 4'h3, 4'h4, 
  4'h5, 4'h6, 4'h7: 
  regsold = 0; 
  default: 
  regsold = 1'bx; 
  endcase 
  end 
 endmodule