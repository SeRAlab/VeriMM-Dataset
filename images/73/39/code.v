module top_module(
  input [31:0] a,
  input [31:0] b,
  output [31:0] out
);reg [31:0] temp;

  always @(*) begin
    temp = a ^ b;
  end

  assign out = temp;

endmodule