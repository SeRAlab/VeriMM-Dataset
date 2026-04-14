module top_module(
    ID_EX_MemRead,
    IF_ID_RegisterRs,
    IF_ID_RegisterRt,
    ID_EX_RegisterRt,
    PC_Write,
    IF_ID_Write,
    data_o
);input               ID_EX_MemRead;
input       [4:0]   IF_ID_RegisterRs, IF_ID_RegisterRt, ID_EX_RegisterRt;
output reg          PC_Write, IF_ID_Write, data_o;

always @(*) begin
  data_o      = 1'b0;
  PC_Write    = 1'b0;
  IF_ID_Write = 1'b0;
  if (ID_EX_MemRead &&
      (ID_EX_RegisterRt == IF_ID_RegisterRs || ID_EX_RegisterRt == IF_ID_RegisterRt)) begin 
      data_o = 1'b1;
      PC_Write    = 1'b1;
      IF_ID_Write = 1'b1;
    end
end

endmodule