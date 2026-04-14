module top_module(Instruction, ALUOp, OpCode);input wire [5:0] Instruction; 
input wire [1:0] ALUOp; 
output wire [3:0] OpCode; 







assign OpCode= (ALUOp==2'b00)?4'b0010: 
(ALUOp==2'b01)?4'b0110:
(ALUOp==2'b10)&&(Instruction==6'b100000)?4'b0010: 
(ALUOp==2'b10)&&(Instruction==6'b100010)?4'b0110:
(ALUOp==2'b10)&&(Instruction==6'b100100)?4'b0000:
(ALUOp==2'b10)&&(Instruction==6'b100101)?4'b0001:
(ALUOp==2'b10)&&(Instruction==6'b101010)?4'b0111:
(ALUOp==2'b10)&&(Instruction==6'd8)?4'd3: 
(ALUOp==2'b10)&&(Instruction==6'd0)?4'd4: 
(ALUOp==2'b10)&&(Instruction==6'd2)?4'd5: 
4'b00; 


endmodule