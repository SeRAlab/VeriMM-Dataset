module top_module(clk, PWM_in, PWM_out);input clk;
input [7:0] PWM_in;
output PWM_out;

reg [8:0] PWM_accumulator;
always @(posedge clk) PWM_accumulator <= PWM_accumulator[7:0] + PWM_in;

assign PWM_out = PWM_accumulator[8];
endmodule