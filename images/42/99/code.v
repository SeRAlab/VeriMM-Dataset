module top_module(sel, in0, in1, in2, in3, out);input sel;
  input in0;
  input in1;
  input in2;
  input in3;
  output out;

  assign out = (sel == 0) ? in0 :
               (sel == 1) ? in1 :
               (sel == 2) ? in2 :
               (sel == 3) ? in3 : 1'b0;

endmodule