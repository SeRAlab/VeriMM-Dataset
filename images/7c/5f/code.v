module top_module(output reg done, Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR,input reset_b, start, AR_gt_0, AR_lt_0, clk);always @(posedge clk) begin 
  if (start) begin 
  Ld_AR_BR = 1; 
  Mul_BR_x2_CR = 0; 
  Div_AR_x2_CR = 0; 
  Clr_CR = 0; 
  done = 0; 
  end else begin 
  if (AR_gt_0) begin 
  Ld_AR_BR = 0; 
  Mul_BR_x2_CR = 1; 
  Div_AR_x2_CR = 0; 
  Clr_CR = 0; 
  done = 1; 
  end else if (AR_lt_0) begin 
  Ld_AR_BR = 0; 
  Mul_BR_x2_CR = 0; 
  Div_AR_x2_CR = 1; 
  Clr_CR = 0; 
  done = 1; 
  end else begin 
  Ld_AR_BR = 0; 
  Mul_BR_x2_CR = 0; 
  Div_AR_x2_CR = 0; 
  Clr_CR = 1; 
  done = 1; 
  end 
  end 
  end 
  always @(reset_b) 
  if (reset_b == 0) begin 
  Ld_AR_BR = 0; 
  Mul_BR_x2_CR = 0; 
  Div_AR_x2_CR = 0; 
  Clr_CR = 0; 
  done = 0; 
  end 
 endmodule