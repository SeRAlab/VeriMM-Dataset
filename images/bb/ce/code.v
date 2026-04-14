module top_module(
  EX_MEM_RegWrite,
  MEM_WB_RegWrite,
  EX_MEM_RegisterRd,
  MEM_WB_RegisterRd,
  ID_EX_RegisterRs,
  ID_Ex_RegisterRt,
  ForwardA,
  ForwardB
);input               EX_MEM_RegWrite, MEM_WB_RegWrite;
input       [4:0]   EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_Ex_RegisterRt;
output reg  [1:0]   ForwardA, ForwardB;

always @(*) begin
  ForwardA = 2'b00;
  ForwardB = 2'b00;
  
  if (EX_MEM_RegWrite && 
      EX_MEM_RegisterRd != 5'b0 &&
      EX_MEM_RegisterRd == ID_EX_RegisterRs)
      ForwardA = 2'b10;
  if (EX_MEM_RegWrite &&
      EX_MEM_RegisterRd != 5'b0 &&
      EX_MEM_RegisterRd == ID_Ex_RegisterRt)
      ForwardB = 2'b10;
  
  if (MEM_WB_RegWrite &&
      MEM_WB_RegisterRd != 5'b0 &&
      MEM_WB_RegisterRd == ID_EX_RegisterRs)
      ForwardA = 2'b01;
  if (MEM_WB_RegWrite &&
      MEM_WB_RegisterRd != 5'b0 &&
      MEM_WB_RegisterRd == ID_Ex_RegisterRt)
      ForwardB = 2'b01;
end

endmodule