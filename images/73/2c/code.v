module top_module(input [15:0] Data,
   input [15:0] CRC,
   output [15:0] NewCRC);reg [15:0] D;
  reg [15:0] C;

  assign NewCRC = nextCRC16_D16(D, C);

  function [15:0] nextCRC16_D16;

    input [15:0] D;
    input [15:0] C;

    reg [31:0] dividend;
    reg [15:0] divisor;
    reg [15:0] remainder;
    reg [15:0] quotient;
    integer i;

    begin
      dividend = {D, 16'h0000};
      divisor = 16'h1021;
      remainder = 16'h0000;
      quotient = 16'h0000;

      for (i = 0; i < 16; i = i + 1) begin
        remainder = {remainder[14:0], dividend[i]};
        quotient = remainder[15] ? divisor : 16'h0000;
        remainder = remainder ^ (quotient << 1);
      end

      nextCRC16_D16 = remainder ^ C;
    end

  endfunction

endmodule