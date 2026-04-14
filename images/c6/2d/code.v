module mux2to1_case(
  input in1,
  input in2,
  input sel,
  output reg out
);

  always @(*) begin
    case (sel)
      1'b0: out = in1;
      1'b1: out = in2;
    endcase
  end

endmodule