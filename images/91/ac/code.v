module top_module(
  input x,
  input y,
  input z,
  input [1:0] sel,
  output reg out
);always @(*) begin
    case (sel)
      2'b00: out = x;
      2'b01: out = y;
      2'b10: out = z;
      default: out = 1'bx;
    endcase
  end

endmodule