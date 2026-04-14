module top_module(clk, rst, in, out );input clk, rst; 
  input in; 
  output reg [1:0] out; 
  wire w, w2; 
  assign w2 = in; 
  reg [1:0] state, nextstate; 
  parameter [1:0] s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11; 
  always @ (w2 or state ) 
  if(w2 == 2'b0) nextstate = state; 
  else 
  case (state) 
  s0: 
  begin 
  if(w2) begin nextstate = s1; out <= 2'b00; end 
  end 
  s1: 
  begin 
  if (w2) begin nextstate = s2; out<= 2'b01;end 
  end 
  s2: 
  begin 
  if (w2) begin nextstate = s3; out<= 2'b10;end 
  end 
  s3: 
  begin 
  if (w2) begin nextstate = s0; out <= 2'b11;end 
  end 
  default: begin 
  nextstate = 2'bx; 
  end 
  endcase 
  always @ (posedge clk or posedge rst) 
  begin 
  if (rst) begin state <= s0; end 
  else state <= nextstate; 
  end 
 endmodule