module top_module(clk_0 ,clk_1 ,sel ,clk_o);input clk_0 ; 
  input clk_1 ; 
  input sel ; 
  output clk_o ; 
  wire clk_0_sel1 ; 
  wire clk_0_sel2 ; 
  reg clk_0_reg1 ; 
  reg clk_0_reg2 ; 
  wire clk_1_sel1 ; 
  wire clk_1_sel2 ; 
  reg clk_1_reg1 ; 
  reg clk_1_reg2 ; 
  assign clk_0_sel1 = (~sel) & (~clk_1_reg2); 
  assign clk_1_sel1 = sel & (~clk_0_reg2); 
  always @(posedge clk_0) begin : CLK_0_REG1 
  clk_0_reg1 <= clk_0_sel1; 
  end 
  always @(posedge clk_1) begin : CLK_1_REG1 
  clk_1_reg1 <= clk_1_sel1; 
  end 
  always @(negedge clk_0) begin : CLK_0_REG2 
  clk_0_reg2 <= clk_0_reg1; 
  end 
  always @(negedge clk_1) begin : CLK_1_REG2 
  clk_1_reg2 <= clk_1_reg1; 
  end 
  assign clk_0_sel2 = clk_0 & clk_0_reg2; 
  assign clk_1_sel2 = clk_1 & clk_1_reg2; 
  assign clk_o = clk_0_sel2 | clk_1_sel2; 
 endmodule