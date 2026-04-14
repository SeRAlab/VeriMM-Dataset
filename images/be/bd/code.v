module top_module(
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] result
);always @* begin
    result = a % b;
  end

endmodule