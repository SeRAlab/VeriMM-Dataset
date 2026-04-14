module top_module(clk, PWM_in, PWM_out);input clk; 
 input [7:0] PWM_in; 
 output reg PWM_out; 
 reg [8:0] PWM_accumulator; 
 reg [7:0] PWM_add; 
 initial 
 begin 
  PWM_accumulator <= 0; 
  PWM_add <=0; 
 end 
 always @(posedge clk) begin 
  PWM_accumulator <= PWM_accumulator[7:0] + PWM_add; 
  PWM_add <= PWM_in; 
 end 
 always @(negedge clk) begin 
  PWM_out <= PWM_accumulator[8]; 
 end 
 endmodule