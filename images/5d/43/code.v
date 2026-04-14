module top_module(
  input clk, reset,
  input [31:0] count_to, frequency,
  output reg [31:0] count,
  output reg done
);// Internal register to keep track of the count value
  reg [31:0] internal_count;

  // Internal register to keep track of whether the counter has reached the count_to value
  reg done_flag;

  // Divide the clock frequency to generate a frequency signal
  reg frequency_clk;
  always @(posedge clk) begin
    if (frequency_clk == frequency - 1) begin
      frequency_clk <= 0;
    end else begin
      frequency_clk <= frequency_clk + 1;
    end
  end

  // Synchronous counter
  always @(posedge clk) begin
    if (reset) begin
      internal_count <= 0;
      done_flag <= 0;
    end else if (frequency_clk == frequency - 1) begin
      if (internal_count == count_to - 1) begin
        internal_count <= 0;
        done_flag <= 1;
      end else begin
        internal_count <= internal_count + 1;
        done_flag <= 0;
      end
    end
  end

  // Assign outputs
  assign count = internal_count;
  assign done = done_flag;

endmodule