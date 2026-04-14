module top_module(
  input wire A, B, C, D,
  output reg F
);always @(*) begin
    case ({A,B,C,D})
      4'b0000, 4'b0010, 4'b0101, 4'b1001: F = 1;
      4'b0001, 4'b0100, 4'b1010, 4'b1111: F = 0;
      default: F = 1'b0;
    endcase
  end

endmodule