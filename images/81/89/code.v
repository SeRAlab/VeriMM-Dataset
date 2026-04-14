module top_module(
    input clk_1m,
    input [11:0] pwm_duty0,
    input [11:0] pwm_duty1,
    output [1:0] pwm_out
    );reg [14:0]cnt = 0;
       
       always@(posedge clk_1m) begin
           if(cnt == 19999) cnt <= 0;
           else cnt <= cnt + 1;
       end
       
       assign pwm_out[0] = (cnt < pwm_duty0) ? 1'b1 : 1'b0;
       assign pwm_out[1] = (cnt < pwm_duty1) ? 1'b1 : 1'b0;
   
endmodule