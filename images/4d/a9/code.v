module top_module(
  input [3:0] data,
  output reg [7:0] seg
);always @(*) begin
    case(data)
      4'b0000: seg = 8'b11111100; // Displays '0'
      4'b0001: seg = 8'b01100000; // Displays '1'
      4'b0010: seg = 8'b11011010; // Displays '2'
      4'b0011: seg = 8'b11110010; // Displays '3'
      4'b0100: seg = 8'b01100110; // Displays '4'
      4'b0101: seg = 8'b10110110; // Displays '5'
      4'b0110: seg = 8'b10111110; // Displays '6'
      4'b0111: seg = 8'b11100000; // Displays '7'
      4'b1000: seg = 8'b11111110; // Displays '8'
      4'b1001: seg = 8'b11110110; // Displays '9'
      default: seg = 8'b00000000; // Displays nothing
    endcase
  end

endmodule