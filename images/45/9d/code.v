module top_module(
  input [3:0] binary_in,
  output reg [3:0] gray_out
);reg [3:0] gray_temp;

  always @ (binary_in) begin
    case (binary_in)
      4'b0000: gray_temp = 4'b0000;
      4'b0001: gray_temp = 4'b0001;
      4'b0010: gray_temp = 4'b0011;
      4'b0011: gray_temp = 4'b0010;
      4'b0100: gray_temp = 4'b0110;
      4'b0101: gray_temp = 4'b0111;
      4'b0110: gray_temp = 4'b0101;
      4'b0111: gray_temp = 4'b0100;
      4'b1000: gray_temp = 4'b1100;
      4'b1001: gray_temp = 4'b1101;
      4'b1010: gray_temp = 4'b1111;
      4'b1011: gray_temp = 4'b1110;
      4'b1100: gray_temp = 4'b1010;
      4'b1101: gray_temp = 4'b1011;
      4'b1110: gray_temp = 4'b1001;
      4'b1111: gray_temp = 4'b1000;
      default: gray_temp = 4'b0000; // Default case to handle undefined inputs
    endcase
    gray_out = gray_temp; // Use continuous assignment to assign gray_temp to gray_out
  end

endmodule