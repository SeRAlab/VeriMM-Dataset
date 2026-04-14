module top_module(
  // Clock out ports
  output reg clk_out1,
  // Status and control signals
  output reg locked,
  // Clock in ports
  input clk_in1
);parameter FREQ_MULT = 2;
  parameter LOCK_CYCLES = 10;

  reg [31:0] counter;
  reg [31:0] lock_counter;
  reg locked_temp;

  always @(posedge clk_in1) begin
    if (counter == 0) begin
      clk_out1 <= ~clk_out1;
      counter <= (FREQ_MULT - 1);
    end else begin
      counter <= counter - 1;
    end
  end

  always @(posedge clk_in1) begin
    if (locked_temp) begin
      lock_counter <= LOCK_CYCLES - 1;
    end else if (lock_counter > 0) begin
      lock_counter <= lock_counter - 1;
    end else if (lock_counter == 0) begin
      locked <= 1;
      locked_temp <= 1;
    end
  end

  always @(posedge clk_out1) begin
    if (locked_temp) begin
      locked_temp <= 0;
    end
  end

endmodule