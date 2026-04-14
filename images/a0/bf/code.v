module top_module(
  input [3:0] address,
  output reg [7:0] dout
);always @(address)
    case (address)
      
      4'b0000: dout <= 8'b10111111; 
      4'b0001: dout <= 8'b10110000; 
      4'b0010: dout <= 8'b11110000; 
      4'b0011: dout <= 8'b00000000;
      4'b0100: dout <= 8'b00000000;
      4'b0101: dout <= 8'b00000000;
      4'b0110: dout <= 8'b00000000;
      4'b0111: dout <= 8'b00000000;
      4'b1000: dout <= 8'b00000000;
      4'b1001: dout <= 8'b00000000;
      4'b1010: dout <= 8'b00000000;
      4'b1011: dout <= 8'b00000000;
      4'b1100: dout <= 8'b00000000;
      4'b1101: dout <= 8'b00000000;
      4'b1110: dout <= 8'b00000000;
      4'b1111: dout <= 8'b00000000;
      default: dout <= 8'bxxxxxxxx;
    endcase
endmodule