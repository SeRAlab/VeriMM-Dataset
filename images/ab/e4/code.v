module top_module(input wire [2:0] in,output reg [2:0] out);always @* begin 
  case (in) 
  3'd0 : out = 3'd0; 
  3'd1 : out = 3'd1; 
  3'd2 : out = 3'd1; 
  3'd3 : out = 3'd2; 
  3'd4 : out = 3'd3; 
  3'd5 : out = 3'd3; 
  3'd6 : out = 3'd4; 
  3'd7 : out = 3'd5; 
  default: out = 3'd0; 
  endcase 
  end 
 endmodule