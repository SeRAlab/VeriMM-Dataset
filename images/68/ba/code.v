module multiplexer_2to1(
  input sel,
  input in0,
  input in1,
  output reg out
);

  always @(*) begin
    case (sel)
      1'b0: out = in0;
      1'b1: out = in1;
      default: out = 1'b0;
    endcase
  end

endmodule