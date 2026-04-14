module mux2to1_16bit_active_high (
  input [15:0] in0,
  input [15:0] in1,
  input sel,
  input en,
  output reg [15:0] out
);

  always @(*) begin
    if (en) begin
      case (sel)
        1'b0: out = in0;
        1'b1: out = in1;
        default: out = 16'b0000000000000000;
      endcase
    end else begin
      out = 16'b0000000000000000;
    end
  end

endmodule