module top_module(input CLK_IN,input [7:0] PWM_DCycle,output reg PWM_OUT);parameter [4:0] N = 31, K=1; 
  reg [31:0] clk_div =0; 
  reg [7:0] pwm_clk =0; 
  always @ ( posedge CLK_IN ) begin 
  clk_div<=clk_div+K; 
  end 
  always @ (posedge clk_div[N]) begin 
  pwm_clk<=pwm_clk+1; 
  end 
 always @ ( * ) begin 
  if(pwm_clk<=PWM_DCycle & PWM_DCycle!=0) 
  PWM_OUT<=1; 
  else 
  PWM_OUT<=0; 
 end 
 endmodule