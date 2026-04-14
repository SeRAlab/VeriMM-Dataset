module adder(
  input [7:0] A, B,
  output reg [7:0] sum,
  output reg carry_out
);

  always @(*) begin
    sum = A + B;
    carry_out = (sum > 8'hFF);
  end

endmodule