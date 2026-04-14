module top_module(
  input [63:0] in0,
  input [63:0] in1,
  input [1:0] sel,
  output reg [63:0] out
);always @(*) begin
    case(sel)
      2'b00: out = in0[31:0];
      2'b01: out = in0[63:32];
      2'b10: out = in1[31:0];
      2'b11: out = in1[63:32];
    endcase
  end

endmodule