module top_module(instruction, nsel, opcode, readnum, writenum, ALUop, op, shift, sximm5, sximm8);input[15:0] instruction; 
  input [1:0] nsel; 
  output [2:0] opcode, readnum, writenum; 
  output [1:0] ALUop, op, shift; 
  output [15:0] sximm5, sximm8; 
  reg [2:0] tempReg; 
  wire [2:0] Rd, Rn, Rm; 
  assign opcode = instruction[15:13]; 
  assign op = instruction[12:11]; 
  assign ALUop = instruction[12:11]; 
  assign sximm5 = instruction[4]? {10'b1111111111,instruction[4:0]} : {10'b0000000000, instruction[4:0]}; 
  assign sximm8 = instruction[7]? {7'b1111111,instruction[7:0]} : {7'b0000000, instruction[7:0]}; 
  assign shift = instruction[4:3]; 
  assign Rn = instruction[10:8]; 
  assign Rd = instruction[7:5]; 
  assign Rm = instruction[2:0]; 
  always@(*) begin 
  case(nsel) 
  2'b00: tempReg = Rn; 
  2'b01: tempReg = Rd; 
  2'b10: tempReg = Rm; 
  default: tempReg = 3'bxxx; 
  endcase 
  end 
  assign readnum = tempReg; 
  assign writenum = tempReg; 
 endmodule