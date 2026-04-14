module top_module(out, in0, in1, s);input in0;
   input in1;
   input s;
   output out;
   
   assign out = s ? in1 : in0;
endmodule