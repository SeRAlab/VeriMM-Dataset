module top_module(
  input clk,
  input data,
  input reset,
  output reg parity
);reg d;
  wire xor_out;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      d <= 1'b0;
      parity <= 1'b0;
    end else begin
      d <= data;
      parity <= xor_out;
    end
  end

  assign xor_out = ^d;

endmodule