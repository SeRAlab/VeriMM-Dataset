module comb_circuit (
  input [3:0] in,
  output reg [2:0] out
);

  always @(*) begin
    if (in < 4) begin
      out = in + 1;
    end else begin
      out = in - 1;
    end
  end

endmodule
