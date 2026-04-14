module top_module(
  input [1:0] A,
  input [1:0] B,
  output reg Y
);always @(*) begin
    case ({A, B})
      4'b0000: Y = 1'b0; // Assuming A and B are combined for 4 bits
      4'b0001: Y = 1'b1;
      4'b0010: Y = 1'b1;
      4'b0011: Y = 1'b0;
      4'b0100: Y = 1'b1;
      4'b0101: Y = 1'b0;
      4'b0110: Y = 1'b0;
      4'b0111: Y = 1'b1;
      4'b1000: Y = 1'b1;
      4'b1001: Y = 1'b0;
      4'b1010: Y = 1'b0;
      4'b1011: Y = 1'b1;
      4'b1100: Y = 1'b0;
      4'b1101: Y = 1'b1;
      4'b1110: Y = 1'b1;
      4'b1111: Y = 1'b0;
      default: Y = 1'b0; // Added a default case
    endcase
  end

endmodule