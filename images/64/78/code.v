module top_module(input wire Sel,input wire [95:0]I1, I2,output reg [95:0] O1);always @( * ) 
  begin 
  case (Sel) 
  1'b0: O1 = I1; 
  1'b1: O1 = I2; 
  endcase 
  end 
 endmodule