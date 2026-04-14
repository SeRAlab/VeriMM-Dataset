module top_module(
  input clk,
  input rst,
  output reg [3:0] leds_0,
  output reg [3:0] leds_1,
  output reg [3:0] leds_2,
  output reg [3:0] leds_3
);reg [26:0] counter;

  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      leds_0 <= 0;
      leds_1 <= 0;
      leds_2 <= 0;
      leds_3 <= 0;
    end else begin
      counter <= counter + 1;
      if (counter == 0) begin
        leds_0 <= 15;
      end else if (counter == 25000000) begin
        leds_0 <= 0;
      end else if (counter == 50000000) begin
        leds_1 <= 15;
      end else if (counter == 100000000) begin
        leds_1 <= 0;
      end else if (counter == 200000000) begin
        leds_2 <= 15;
      end else if (counter == 400000000) begin
        leds_2 <= 0;
      end else if (counter == 800000000) begin
        leds_3 <= 15;
      end else if (counter == 1600000000) begin
        leds_3 <= 0;
        counter <= 0;
      end
    end
  end

endmodule