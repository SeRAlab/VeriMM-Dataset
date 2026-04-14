module top_module(
   input clk,
   input rst,
   input [7:0] speed,
   output reg [7:0] motor_speed
);always @(posedge clk, posedge rst) begin
      if (rst) begin
         motor_speed <= 0;
      end else if (clk) begin
         motor_speed <= speed;
      end
   end
endmodule