module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);wire gated_clk;

  // Create a gated clock
  assign gated_clk = EN ? CLK : 1'b0;

  // Create a latch to hold the output
  always @(posedge CLK or posedge TE) begin
    if (TE) begin
      ENCLK <= 1'b0; // Reset output if TE is high
    end else begin
      ENCLK <= gated_clk; // Update output based on gated clock
    end
  end

endmodule