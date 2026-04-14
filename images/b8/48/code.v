module top_module(
  input [3:0] bcd0,
  input [3:0] bcd1,
  input [3:0] bcd2,
  input [3:0] bcd3,
  output reg [3:0] bin
);always @* begin
    bin = (bcd3 * 1000) + (bcd2 * 100) + (bcd1 * 10) + bcd0;
  end

endmodule