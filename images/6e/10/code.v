module top_module(input [3:0] in, output reg [15:0] bcd);// Implementing the conversion using a combinational logic
  
  // Define the BCD values for each binary value from 0 to 15
  always @(*)
  begin
    case(in)
      4'b0000: bcd = 16'b0000_0000_0000_0000;
      4'b0001: bcd = 16'b0000_0000_0000_0001;
      4'b0010: bcd = 16'b0000_0000_0001_0000;
      4'b0011: bcd = 16'b0000_0000_0001_0001;
      4'b0100: bcd = 16'b0000_0000_0010_0000;
      4'b0101: bcd = 16'b0000_0000_0010_0001;
      4'b0110: bcd = 16'b0000_0000_0011_0000;
      4'b0111: bcd = 16'b0000_0000_0011_0001;
      4'b1000: bcd = 16'b0000_0000_0100_0000;
      4'b1001: bcd = 16'b0000_0000_0100_0001;
      4'b1010: bcd = 16'b0000_0000_0101_0000;
      4'b1011: bcd = 16'b0000_0000_0101_0001;
      4'b1100: bcd = 16'b0000_0000_0110_0000;
      4'b1101: bcd = 16'b0000_0000_0110_0001;
      4'b1110: bcd = 16'b0000_0000_0111_0000;
      4'b1111: bcd = 16'b0000_0000_0111_0001;
      default: bcd = 16'b0000_0000_0000_0000; // Default case for safety
    endcase
  end

endmodule