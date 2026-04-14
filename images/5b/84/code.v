module top_module(nibble, sseg);input [3:0] nibble;
   output [6:0] sseg;

   reg [6:0] 	segment;

   
   assign sseg = ~segment;
   
   always @(*)
     case(nibble)
       4'b0000: segment <= 7'b1111110;
       4'b0001: segment <= 7'b0110000;
       4'b0010: segment <= 7'b1101101;
       4'b0011: segment <= 7'b1111001;
       4'b0100: segment <= 7'b0110011;
       4'b0101: segment <= 7'b1011011;
       4'b0110: segment <= 7'b1011111;
       4'b0111: segment <= 7'b1110000;
       4'b1000: segment <= 7'b1111111;
       4'b1001: segment <= 7'b1111011;
       4'b1010: segment <= 7'b1110111;
       4'b1011: segment <= 7'b0011111;
       4'b1100: segment <= 7'b1001110;
       4'b1101: segment <= 7'b0111101;
       4'b1110: segment <= 7'b1001111;
       4'b1111: segment <= 7'b1000111;
     endcase

endmodule