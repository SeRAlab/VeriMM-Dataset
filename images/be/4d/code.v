module top_module(Clk, Rst, Load_In, Count_Enable, Count_Load, Count_Down,Count_Out, Carry_Out);parameter C_NUM_BITS = 9; 
 parameter C_FAMILY = "nofamily"; 
 input Clk; 
 input Rst; 
 input[C_NUM_BITS - 1:0] Load_In; 
 input Count_Enable; 
 input Count_Load; 
 input Count_Down; 
 output[C_NUM_BITS - 1:0] Count_Out; 
 wire[C_NUM_BITS - 1:0] Count_Out; 
 output Carry_Out; 
 wire Carry_Out; 
 reg[C_NUM_BITS:0] icount_out; 
 wire[C_NUM_BITS:0] icount_out_x; 
 wire[C_NUM_BITS:0] load_in_x; 
 assign load_in_x = {1'b0, Load_In}; 
 assign icount_out_x = {1'b0, icount_out[C_NUM_BITS - 1:0]}; 
 always @(posedge Clk) 
 begin : CNTR_PROC 
  if (Rst == 1'b1) 
  begin 
  icount_out <= {C_NUM_BITS-(0)+1{1'b0}} ; 
  end 
  else if (Count_Load == 1'b1) 
  begin 
  icount_out <= load_in_x ; 
  end 
  else if (Count_Down == 1'b1 & Count_Enable == 1'b1) 
  begin 
  icount_out <= icount_out_x - 1 ; 
  end 
  else if (Count_Enable == 1'b1) 
  begin 
  icount_out <= icount_out_x + 1 ; 
  end 
 end 
 assign Carry_Out = icount_out[C_NUM_BITS] ; 
 assign Count_Out = icount_out[C_NUM_BITS - 1:0]; 
 endmodule