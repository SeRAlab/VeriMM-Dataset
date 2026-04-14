module sub (
   input [15:0] in1,
   input [15:0] in2,
   output [31:0] out1,
   output [31:0] out2
   );
   
   assign out1 = in1 & in2;
   assign out2 = in1 | in2;
   
endmodule