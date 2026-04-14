module top_module(input [1:0] aluOp,input [5:0] instructionCodeLowBits,input [5:0] instructionCodeHighBits,output reg [3:0] aluOperation);always @(*)begin 
  case(aluOp) 
  0: aluOperation<=3; 
  1: aluOperation<=4; 
  2: begin 
  case(instructionCodeLowBits) 
  6'b000000: aluOperation<=0; 
  6'b000010: aluOperation<=1; 
  6'b000011: aluOperation<=2; 
  6'b000110: aluOperation<=1; 
  6'b000111: aluOperation<=2; 
  6'b000100: aluOperation<=0; 
  6'b100000: aluOperation<=3; 
  6'b100010: aluOperation<=4; 
  6'b100100: aluOperation<=5; 
  6'b100101: aluOperation<=6; 
  6'b100110: aluOperation<=7; 
  6'b100111: aluOperation<=8; 
  6'b101010: aluOperation<=9; 
  default: aluOperation<='hF; 
  endcase 
  end 
  3: begin 
  case(instructionCodeHighBits) 
  6'b001000: aluOperation<=3; 
  6'b001100: aluOperation<=5; 
  6'b001101: aluOperation<=6; 
  6'b001110: aluOperation<=7; 
  6'b001010: aluOperation<=9; 
  default: aluOperation<='hF; 
  endcase 
  end 
  default:aluOperation<='hF; 
  endcase 
 end 
 endmodule