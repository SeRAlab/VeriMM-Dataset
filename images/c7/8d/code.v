module multiplier_module(
  input clk,
  input reset,
  input [15:0] a,
  input [15:0] b,
  output reg [15:0] p
);

  always @(posedge clk) begin
    if (reset) begin
      p <= 0;
    end else begin
      p <= a * b;
    end
  end

endmodule