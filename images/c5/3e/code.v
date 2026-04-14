module karnaugh_map(
  input wire A, B, C,
  output reg F
);

  always @*
  begin
    case ({A,B,C})
      3'b000: F = 0;
      3'b001: F = 1;
      3'b010: F = 0;
      3'b011: F = 1;
      3'b100: F = 0;
      3'b101: F = 1;
      3'b110: F = 1;
      3'b111: F = 0;
    endcase
  end

endmodule