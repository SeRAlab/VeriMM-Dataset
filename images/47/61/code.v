module top_module(de_Rs, de_Rt, em_write_reg, mw_write_reg, em_reg_wr, mw_reg_wr,
  frwrd_sel_A, frwrd_sel_B);input em_reg_wr, mw_reg_wr; 
  input [2:0] de_Rs, de_Rt; 
  input [2:0] em_write_reg, mw_write_reg; 
  output [1:0] frwrd_sel_A, frwrd_sel_B; 

  assign frwrd_sel_A = (de_Rs == em_write_reg & em_reg_wr) ? 2'b01 : 
                       (de_Rs == mw_write_reg & mw_reg_wr) ? 2'b10 : 
                       2'b00; 

  assign frwrd_sel_B = (de_Rt == em_write_reg & em_reg_wr) ? 2'b01 : 
                       (de_Rt == mw_write_reg & mw_reg_wr) ? 2'b10 : 
                       2'b00; 

endmodule