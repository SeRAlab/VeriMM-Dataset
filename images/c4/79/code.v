module comb_circuit (
  input [3:0] in,
  output reg [2:0] out
);

  always @(*) begin
    out = (in < 4) ? in + 2 : in - 2;
  end

endmodule
