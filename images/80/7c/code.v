module top_module(
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] add_out,
  output reg [7:0] sub_out,
  output reg [7:0] mul_out,
  output reg [7:0] div_out
);always @(*) begin
    add_out = a + b;
    sub_out = a - b;
    mul_out = a * b;
    div_out = a / b;
  end

endmodule