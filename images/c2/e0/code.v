module mux4to1 (
  input wire a,
  input wire b,
  input wire c,
  input wire d,
  input wire sel,
  output reg out
);

always @ (sel, a, b, c, d) begin
  case (sel)
    2'b00: out = a;
    2'b01: out = b;
    2'b10: out = c;
    2'b11: out = d;
  endcase
end

endmodule