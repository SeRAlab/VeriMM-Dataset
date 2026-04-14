module top_module(input wire [3:0] in, output wire [3:0] out);// If input is positive, simply convert to binary and pad with leading zeroes
   assign out = (in[3]) ? ~(in) + 1 : in;

endmodule