module top_module(
  input clk,
  input reset,
  input [31:0] a,
  input [31:0] b,
  output [31:0] out
);reg [31:0] accum; // register to hold accumulated value

  always @(posedge clk) begin
    if (reset) begin
      accum <= 0;
    end else begin
      accum <= accum + (a * b);
    end
  end

  assign out = accum;

endmodule