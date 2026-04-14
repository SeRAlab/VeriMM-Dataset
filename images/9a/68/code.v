module top_module(
   input clk,
   input rst,
   input [31:0] pwm_freq,
   input [7:0] duty_cycle,
   output reg pwm_out
);reg [31:0] counter;
   reg [31:0] period;
   reg [31:0] high_time;

   always @ (posedge clk or posedge rst) begin
      if (rst) begin
         counter <= 0;
         pwm_out <= 0;
      end
      else begin
         if (counter >= period) begin
            counter <= 0;
            pwm_out <= 1;
         end
         else if (counter >= high_time) begin
            pwm_out <= 0;
         end
         counter <= counter + 1;
      end
   end

   always @ (pwm_freq, duty_cycle) begin
      period <= pwm_freq / 50;
      high_time <= period * duty_cycle / 100;
   end

endmodule