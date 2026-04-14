module demux1to4 (
  input in,
  input [1:0] sel,
  output reg out0,
  output reg out1,
  output reg out2,
  output reg out3
);

  always @(*) begin
    out0 = 1'b0;
    out1 = 1'b0;
    out2 = 1'b0;
    out3 = 1'b0;
    case (sel)
      2'b00: out0 = in;
      2'b01: out1 = in;
      2'b10: out2 = in;
      2'b11: out3 = in;
    endcase
  end

endmodule