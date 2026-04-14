module xor_8bit (
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] out
);

  always @(*) begin
    out = a ^ b;
  end

endmodule