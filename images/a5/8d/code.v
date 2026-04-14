module top_module(out, in0, s0, in1, s1, in2, s2, in3, s3);parameter bits = 32; 
 output [bits-1:0] out; 
 input [bits-1:0] in0, in1, in2, in3; 
 input s0, s1, s2, s3; 
  reg [bits-1:0] out; 
  always @ (s0 or s1 or s2 or s3 or in0 or in1 or in2 or in3) begin 
  case ({s3, s2, s1, s0}) 
  4'b0001: out = in0; 
  4'b0010: out = in1; 
  4'b0100: out = in2; 
  4'b1000: out = in3; 
  default: out = 65'hx; 
  endcase 
  end 
 endmodule