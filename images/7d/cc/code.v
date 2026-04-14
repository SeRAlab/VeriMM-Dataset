module top_module(
  input [15:0] a,
  input [15:0] dt,
  input enable,
  input rst,
  input clk,
  output reg [31:0] v,
  output reg busy
);reg [31:0] accumulator;

  always @(posedge clk) begin
    if (rst) begin
      accumulator <= 0;
      busy <= 0;
    end else if (enable) begin
      accumulator <= accumulator + (a * dt);
      busy <= 1;
    end else begin
      busy <= 0;
    end
  end

  assign v = accumulator;

endmodule