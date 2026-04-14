module top_module(in0, in1, in2, in3, sel, out);input [7:0] in0, in1, in2, in3;
  input [1:0] sel;
  output [7:0] out;

  assign out = (sel == 2'b00) ? in0 :
               (sel == 2'b01) ? in1 :
               (sel == 2'b10) ? in2 :
               (sel == 2'b11) ? in3 : 8'b0;
endmodule