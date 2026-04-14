module top_module(
  input [3:0] bin_input,
  output reg [1:0] gray_output,  // Changed 'wire' to 'reg'
  output valid
);assign valid = (bin_input == 4'b0000 || bin_input == 4'b0001 || 
                  bin_input == 4'b0011 || bin_input == 4'b0111 || 
                  bin_input == 4'b1111);

  always @(*) begin
    case (bin_input)
      4'b0000: gray_output = 2'b00;
      4'b0001: gray_output = 2'b01;
      4'b0010: gray_output = 2'b11;
      4'b0011: gray_output = 2'b10;
      4'b0100: gray_output = 2'b11;
      4'b0101: gray_output = 2'b10;
      4'b0110: gray_output = 2'b00;
      4'b0111: gray_output = 2'b01;
      4'b1000: gray_output = 2'b10;
      4'b1001: gray_output = 2'b11;
      4'b1010: gray_output = 2'b01;
      4'b1011: gray_output = 2'b00;
      4'b1100: gray_output = 2'b01;
      4'b1101: gray_output = 2'b00;
      4'b1110: gray_output = 2'b10;
      4'b1111: gray_output = 2'b11;
      default: gray_output = 2'b00;
    endcase
  end

endmodule