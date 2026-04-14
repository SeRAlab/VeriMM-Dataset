module top_module(A, B, op, Z);input [31:0] A, B;
  input [1:0] op;
  output reg [31:0] Z;

  always @ (A, B, op) begin
    case (op)
      2'b00: Z = A + B;
      2'b01: Z = A - B;
      2'b10: Z = A * B;
      2'b11: Z = A / B;
    endcase
  end

endmodule