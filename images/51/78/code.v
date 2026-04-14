module top_module(input [2:0] OpCode,input [3:0] A,input [3:0] B,output reg [3:0] Final,output reg Status);always @ (A or B or OpCode) 
 begin 
  Status = 0; 
  case (OpCode) 
  3'b000: begin 
  Final = ~A; 
  end 
  3'b001: begin 
  Final = ~(A&B); 
  end 
  3'b010: begin 
  Final = ~(A|B); 
  end 
  3'b011: begin 
  Final = A ^ B; 
  end 
  3'b100: begin 
  Final = A + B; 
  if (A[3] == B[3] && Final[3] != B[3]) 
  Status = 1; 
  end 
  3'b101: begin 
  Final = A - B; 
  if (A[3] == (B[3] ^ 1) && Final[3] != A[3]) 
  Status = 1; 
  end 
  3'b110: begin 
  Final = B + 4'b0001; 
  if (0 == B[3] && Final[3] != B[3]) 
  Status = 1; 
  end 
  3'b111: begin 
  Final = B - 4'b0001; 
  if (1 == B[3] && Final[3] != 1 ) 
  Status = 1; 
  end 
  endcase 
 end 
 endmodule