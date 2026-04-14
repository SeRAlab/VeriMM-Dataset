module top_module(
  input [3:0] bin,
  output reg [3:0] bcd1,  // Change output to reg
  output reg [3:0] bcd2,  // Change output to reg
  output reg [3:0] bcd3,  // Change output to reg
  output reg [3:0] bcd4   // Change output to reg
);reg [7:0] decimal;
  reg [3:0] quotient;
  reg [3:0] remainder;

  always @(*) begin
    decimal = bin[3]*2**3 + bin[2]*2**2 + bin[1]*2**1 + bin[0]*2**0;
    quotient = decimal / 10;
    remainder = decimal % 10;
    bcd1 = remainder;
    bcd2 = quotient % 10;
    bcd3 = (quotient / 10) % 10;
    bcd4 = (quotient / 100) % 10;
  end

endmodule