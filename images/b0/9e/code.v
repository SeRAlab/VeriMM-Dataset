module top_module(
  input in,
  input out_clk,
  input out_resetn,
  output reg out
);// Simple synchronizer for a single-bit signal
  reg [1:0] sync_reg = 2'b00;

  always @(posedge out_clk or negedge out_resetn) begin
    if (!out_resetn) begin
      sync_reg <= 2'b00;
      out <= 1'b0;
    end else begin
      sync_reg <= {sync_reg[0], in}; // Shift in the new value
      out <= sync_reg[1]; // Output the second stage
    end
  end
endmodule