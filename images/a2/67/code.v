module top_module(LogicImm, LowLogicImm, HighLogicImm,LowMaskSel_Top, HighMaskSel_Top, LowMaskSel_Bot, HighMaskSel_Bot);input [4:0] LowMaskSel_Top, HighMaskSel_Top; 
  input [4:0] LowMaskSel_Bot, HighMaskSel_Bot; 
  output [63:0] LogicImm; 
  output [63:0] LowLogicImm, HighLogicImm; 
  genvar i; 
  generate 
  for (i=0;i<64;i=i+1) begin : MaskVal 
  if (i >= 32) begin 
  assign LowLogicImm[i] = (LowMaskSel_Top <= i[4:0]); 
  assign HighLogicImm[i] = (HighMaskSel_Top >= i[4:0]); 
  end 
  else begin 
  assign LowLogicImm[i] = (LowMaskSel_Bot <= i[4:0]); 
  assign HighLogicImm[i] = (HighMaskSel_Bot >= i[4:0]); 
  end 
  end 
  endgenerate 
  assign LogicImm = LowLogicImm & HighLogicImm; 
 endmodule