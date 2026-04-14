module top_module(
  input clk,
  input reset,
  input [3:0] d,
  output [3:0] q
);reg [3:0] q_reg;

  always @(posedge clk) begin
    if (reset) begin
      q_reg <= 4'b0;
    end else begin
      q_reg <= d;
    end
  end

  assign q = q_reg;
endmodule