module top_module(
    input clk,
    input rst,
    input [7:0] brightness,
    output reg led_out
);reg [17:0] counter;
   reg [7:0] threshold;

   always @(posedge clk) begin
      if (rst) begin
         counter <= 18'd0;
         threshold <= 8'd0;
         led_out <= 1'b0;
      end else begin
         counter <= counter + 1;
         if (counter == 18'd999) begin
            counter <= 18'd0;
         end
         if (threshold < brightness) begin
            threshold <= threshold + 1;
            led_out <= 1'b1;
         end else begin
            threshold <= 8'd0;
            led_out <= 1'b0;
         end
      end
   end

endmodule