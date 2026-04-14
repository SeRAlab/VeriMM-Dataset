module top_module(A, B, factor);input[64 - 1:0] A; 
  output[64 - 1:0] B; 
  reg[64 - 1:0] B; 
  input[1:0] factor; 
  always @(factor or A) 
  begin 
  case (factor) 
  2'b00 : 
  begin 
  B = A ; 
  end 
  2'b01 : 
  begin 
  B = {4'b0000, A[64 - 1:4]} ; 
  end 
  2'b10 : 
  begin 
  B = {8'b00000000, A[64 - 1:8]} ; 
  end 
  2'b11 : 
  begin 
  B = {12'b000000000000, A[64 - 1:12]} ; 
  end 
  endcase 
  end 
  endmodule