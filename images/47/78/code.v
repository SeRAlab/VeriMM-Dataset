module top_module(clk,sig,f);`define CLK_COUNTER_SIZE 14 
 `define SIG_COUNTER_SIZE 7 
 input clk,sig; 
 output reg [13:0] f; 
 reg [13:0] n_clk; 
 reg [13:0] n_clk_last; 
 reg [6:0] n_sig; 
 reg cnt_flg; 
 reg reset; 
 parameter F_CLK=35795; 
 parameter M=50; 
 parameter MIN_CHANGE=`CLK_COUNTER_SIZE'b10; 
 initial begin 
  #0 
  n_clk=`CLK_COUNTER_SIZE'b0; 
  n_sig=`SIG_COUNTER_SIZE'b0; 
  reset=1'b1; 
 end 
 always @(posedge clk or posedge reset) begin 
  if (reset) begin 
  n_clk=`CLK_COUNTER_SIZE'b0; 
  end else begin 
  n_clk=n_clk+`CLK_COUNTER_SIZE'b1; 
  end 
 end 
 always @(posedge sig) begin 
  if (n_sig==M) begin 
  if(n_clk==`CLK_COUNTER_SIZE'b0) f=(M)*F_CLK; 
  else if ((n_clk>n_clk_last && n_clk-n_clk_last>MIN_CHANGE) || ( n_clk_last>n_clk && n_clk_last-n_clk>MIN_CHANGE) ) begin 
  n_clk_last=n_clk; 
  f=(M*F_CLK)/n_clk; 
  end 
  n_sig=`SIG_COUNTER_SIZE'b0; 
  reset=1'b1; 
  end else begin 
  reset=1'b0; 
  n_sig=n_sig+`SIG_COUNTER_SIZE'b1; 
  end 
 end 
 endmodule