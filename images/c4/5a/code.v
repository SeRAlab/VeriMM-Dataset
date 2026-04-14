module karnaugh_map(
  input wire A, B, C, D, // 4-bit input variables
  output reg F // 1-bit output variable
);

  always @(*) begin
    case ({A,B,C,D})
      4'b0000: F = 1'b0;
      4'b0001: F = 1'b1;
      4'b0010: F = 1'b0;
      4'b0011: F = 1'b1;
      4'b0110: F = 1'b1;
      4'b0111: F = 1'b0;
      4'b1110: F = 1'b1;
      4'b1111: F = 1'b0;
      default: F = 1'b0;
    endcase
  end

endmodule