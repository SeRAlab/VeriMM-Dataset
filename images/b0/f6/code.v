module top_module(output reg signed[15:0] CR, output reg AR_gt_0, AR_lt_0,input [15:0] Data_AR, Data_BR,input Ld_AR_BR, Div_AR_x2_CR, Mul_BR_x2_CR, Clr_CR, clk);reg signed [15:0] AR; 
  reg signed [15:0] BR; 
  always @(AR) begin 
  AR_lt_0 = (AR < 0); 
  AR_gt_0 = (AR > 0); 
  end 
  always @(negedge clk) begin 
  if (Ld_AR_BR) begin 
  AR = Data_AR; 
  BR = Data_BR; 
  end else if (Div_AR_x2_CR) begin 
  CR = AR / 2; 
  end else if (Mul_BR_x2_CR) begin 
  CR = BR * 2; 
  end else if (Clr_CR) begin 
  CR = 0; 
  end 
  end 
 endmodule