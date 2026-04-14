module top_module(
  input        clock,
  input        reset,
  input  [3:0] io_in,
  output [3:0] io_out
);wire  ff_clock;
  wire  ff_reset;
  wire [3:0] ff_io_in;
  wire [3:0] ff_io_out;

  // Declare a 4-bit flip-flop module
  reg [3:0] q; // Storage for the flip-flop

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      q <= 4'b0; // Reset the flip-flop
    end else begin
      q <= io_in; // Load the input into the flip-flop
    end
  end

  assign io_out = q; // Output the stored value

endmodule