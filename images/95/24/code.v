module top_module(input[31:0] insn, output[3:0] idxZ, idxX, output reg[3:0] idxY,output reg signed[31:0] valI, output reg[3:0] op,output[1:0] kind, output storing, loading, deref_rhs, branching);wire [19:0] tI; 
  wire [1:0] dd; 
  assign {kind, dd, idxZ, idxX, tI} = insn; 
  always @* case (kind) 
  default: {idxY,op,valI[11:0],valI[31:12]} = { tI,{20{tI[11]}}}; 
  2'b11: {idxY,op,valI[19:0],valI[31:20]} = {8'h0,tI,{12{tI[19]}}}; 
  endcase 
  assign storing = ^dd; 
  assign loading = &dd; 
  assign deref_rhs = dd[0]; 
  assign branching = &idxZ & ~storing; 
 endmodule