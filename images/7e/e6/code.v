module top_module(
  input i_clk,
  input i_reset,
  input [31:0] i_data,
  output reg o_error
);reg [31:0] prev_data;

always @(posedge i_clk) begin
  // Reset error flag
  o_error <= 0;

  // Check for X values
  if (i_data === 32'hxxxxxxxx) begin
    o_error <= 1;
  end

  // Store previous data
  prev_data <= i_data;
end

// Reset error flag on reset signal
always @(posedge i_clk) begin
  if (i_reset) begin
    o_error <= 0;
  end
end

endmodule