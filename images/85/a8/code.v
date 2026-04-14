module top_module(
  input [3:0] A,
  input [3:0] B,
  input [1:0] op,
  output reg eq
);always @ (A, B, op) begin
    case(op)
      2'b00: eq = (A == B);
      2'b01: eq = (A > B);
      2'b10: eq = (A < B);
      2'b11: eq = (A != B);
      default: eq = 0;
    endcase
  end

endmodule