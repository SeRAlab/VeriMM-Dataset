module top_module(
    input [5:0] op,
    output [1:0] alu_op,
    output regDst, aluSrc, memToReg, regWrite,
    output memRead, memWrite, branch
  );// Generate complement of op bits
  wire [5:0] op_bar;
  assign op_bar = ~op;

  // Generate control signals
  assign alu_op[0] = op_bar[0] & op_bar[1] & op_bar[2] & op[2] & op_bar[4] & op_bar[5];
  assign alu_op[1] = op_bar[0] & op_bar[1] & op_bar[2] & op_bar[3] & op_bar[4] & op_bar[5];
  assign regDst = op_bar[0] & op_bar[1] & op_bar[2] & op_bar[3] & op_bar[4] & op_bar[5];
  assign memToReg = op[0] & op_bar[1] & op_bar[2] & op_bar[3] & op[4] & op[5];
  assign regWrite = (op[0] & op_bar[1] & op_bar[2] & op_bar[3] & op_bar[4] & op_bar[5]) | (op[5] & op_bar[1] & op_bar[2] & op_bar[3] & op_bar[4] & op_bar[5]);
  assign memRead = op[0] & op_bar[1] & op_bar[2] & op_bar[3] & op[4] & op_bar[5];
  assign memWrite = op[0] & op_bar[1] & op_bar[3] & op_bar[4] & op_bar[5];
  assign branch = op_bar[0] & op_bar[1] & op_bar[2] & op[2] & op_bar[4] & op_bar[5];
  assign aluSrc = op[5] & op_bar[1] & op_bar[2] & op[4] & op[3];

endmodule