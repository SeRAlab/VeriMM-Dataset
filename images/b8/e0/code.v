module top_module(in1, in2, in3, in4, sel, out);input in1;
   input in2;
   input in3;
   input in4;
   input [1:0] sel;
   output out;

   assign out = sel[1] ? (sel[0] ? in4 : in3) : (sel[0] ? in2 : in1);

endmodule