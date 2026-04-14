module top_module(a, b, RESULT);input	signed [31:0]	a;
   input	signed [31:0]	b;
   output [31:0] RESULT;
   wire			 lessThanEqualTo;
   wire [31:0]		 mux;
   assign		 lessThanEqualTo=a<=b;
   assign		 mux=(lessThanEqualTo)?a:b;
   assign		 RESULT=mux;
endmodule