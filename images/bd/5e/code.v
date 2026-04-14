module mux2to1_3bit (
  input [2:0] in0,
  input [2:0] in1,
  input sel,
  output reg [2:0] out
);

  always @(*) begin
    case (sel)
      1'b0: out = in0;
      1'b1: out = in1;
      default: out = 3'b0;
    endcase
  end

endmodule