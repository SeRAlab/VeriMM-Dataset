module top_module(
  input clk_in,
  input [31:0] divide_factor,
  output reg clk_out
);parameter clk_period = 10; // in nanoseconds
parameter delay_cycles = 0;

reg [31:0] counter = 0;

always @(posedge clk_in) begin
  if (counter == divide_factor - 1) begin
    counter <= 0;
    clk_out <= ~clk_out;
  end else begin
    counter <= counter + 1;
  end
end

initial begin
  #delay_cycles;
  clk_out <= 0;
end

endmodule