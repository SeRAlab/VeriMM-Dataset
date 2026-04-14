module top_module(input [2:0] state, output reg Z11);always @(*) begin 
  casez (state) 
  3'b000: Z11 = 1'b0; 
  3'b0?1: Z11 = 1'b1; 
  default: Z11 = 1'bx; 
  endcase 
  end 
 endmodule