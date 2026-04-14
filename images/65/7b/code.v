module top_module(
  input clock,
  input reset,
  output reg clk_out
);parameter divisor = 2; // factor by which the frequency of the input clock signal is divided

// Declare the counter with a constant width
reg [31:0] counter; // Counter should be of a sufficient bit width

always @ (posedge clock or posedge reset) begin
  if (reset) begin
    clk_out <= 0;
    counter <= 0;
  end else begin
    if (counter == (divisor - 1)) begin
      clk_out <= ~clk_out;
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
end

// Calculate the number of bits needed for the counter
localparam COUNTER_WIDTH = $clog2(divisor); // Use $clog2 instead of log2 function

endmodule