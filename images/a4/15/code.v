module top_module(
  input clk,             // Added clk input
  input in,
  output reg rising_edge,
  output reg falling_edge
);reg prev_in;

  always @(posedge clk) begin
    if (in && !prev_in) begin
      rising_edge <= 1;
    end else begin
      rising_edge <= 0;
    end

    if (!in && prev_in) begin
      falling_edge <= 1;
    end else begin
      falling_edge <= 0;
    end

    prev_in <= in;
  end

endmodule