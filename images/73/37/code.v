module top_module(input wire sysclock,input wire [31:0] a,input wire b,output reg e);reg [3:0] fsmstate; 
 initial begin 
  e <= 1'd0; 
  fsmstate <= 4'd0; 
 end 
 always @ (posedge sysclock) begin 
  case (fsmstate) 
  4'h0: begin 
  fsmstate <= 4'h1; 
  e <= 1'h0; 
  end 
  4'h1: begin 
  fsmstate <= 4'h2; 
  e <= 1'h1; 
  end 
  4'h2: begin 
  fsmstate <= 4'h3; 
  e <= 1'h1; 
  end 
  4'h3: begin 
  fsmstate <= 4'h1; 
  e <= 1'h0; 
  end 
  endcase 
 end 
 endmodule