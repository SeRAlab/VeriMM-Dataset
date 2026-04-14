module top_module(
  input clk,
  input rx,
  output reg [3:0] leds
);localparam BAUD = 115200;
  localparam BITRATE = (1000000000 / BAUD); // Direct calculation
  localparam FRAME = (10 * BITRATE);
  localparam FRAME_WAIT = (4 * BITRATE);

  reg [9:0] shift_reg;
  reg [3:0] data_reg;
  reg [3:0] led_reg;

  always @(posedge clk) begin
    shift_reg <= {shift_reg[8:0], rx};
    if (shift_reg[9:0] == 10'b1_0000_0001) begin
      data_reg <= shift_reg[8:1];
    end
  end

  always @(posedge clk) begin
    if (shift_reg[9:0] == 10'b1_0000_0001) begin
      led_reg <= data_reg;
    end
  end

  always @(posedge clk) begin
    leds <= led_reg;
  end

endmodule