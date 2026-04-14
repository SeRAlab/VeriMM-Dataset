module mux2to1_1bit_active_low (
  input in0,
  input in1,
  input sel,
  input en_n,
  output reg out
);

  always @(*) begin
    if (~en_n) begin
      case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 1'b0;
      endcase
    end else begin
      out = 1'b0;
    end
  end

endmodule