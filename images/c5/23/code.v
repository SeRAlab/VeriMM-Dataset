module binary_multiplier (
  input [7:0] a,
  input [7:0] b,
  output [15:0] result
);

  reg [15:0] temp;

  always @(*) begin
    temp = a * b;
  end

  assign result = temp;

endmodule