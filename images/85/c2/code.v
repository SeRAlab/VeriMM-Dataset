module top_module(input in,input reset,input clock,output reg out);reg [2:0] state; 
 parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101; 
 always @(posedge clock) 
 begin 
  if (reset) 
  begin 
  state <= s0; 
  out <= 0 ; 
  end 
  else 
  case(state) 
  s0 : if (in) begin state <= s1; out <= 0 ; end 
  else begin state <= s0; out <= 0 ; end 
  s1 : if (in) begin state <= s1; out <= 0 ; end 
  else begin state <= s2; out <= 0 ; end 
  s2 : if (in) begin state <= s1; out <= 0 ; end 
  else begin state <= s3; out <= 0 ; end 
  s3 : if (in) begin state <= s1; out <= 0 ; end 
  else begin state <= s4; out <= 0 ; end 
  s4 : if (in) begin state <= s5; out <= 1 ; end 
  else begin state <= s0; out <= 0 ; end 
  s5 : if (in) begin state <= s1; out <= 0 ; end 
  else begin state <= s2; out <= 0 ; end 
  default: if (in) begin state <= s0; out <= 0 ; end 
  else begin state <= s0; out <= 0 ; end 
  endcase 
 end 
 endmodule