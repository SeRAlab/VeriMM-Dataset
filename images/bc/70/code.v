module top_module(imm, ID_imm);input wire [15:0] imm;
  output wire [31:0] ID_imm;
  
  assign ID_imm = { {16{imm[15]}} , imm};

endmodule