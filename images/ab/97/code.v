module top_module(
  input [3:0] A,
  output reg [3:0] B // Changed to output reg to allow assignment in always block
);always @(*) begin
    case (A)
      4'b0000: B = 4'b0000;
      4'b0001: B = 4'b0001;
      4'b0010: B = 4'b0011;
      4'b0011: B = 4'b0010;
      4'b0100: B = 4'b0110;
      4'b0101: B = 4'b0111;
      4'b0110: B = 4'b0101;
      4'b0111: B = 4'b0100;
      4'b1000: B = 4'b1100;
      4'b1001: B = 4'b1101;
      4'b1010: B = 4'b1111;
      4'b1011: B = 4'b1110;
      4'b1100: B = 4'b1010;
      4'b1101: B = 4'b1011;
      4'b1110: B = 4'b1001;
      4'b1111: B = 4'b1000;
      default: B = 4'bxxxx; // Undefined value
    endcase
  end

endmodule