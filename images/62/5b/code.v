module top_module(out, in0, in1, sel);output [3:0] out;
   input [3:0] in0;
   input [3:0] in1;
   input [1:0] sel;

   wire [3:0] out0;
   wire [3:0] out1;
   wire [3:0] out2;
   wire [3:0] out3;

   assign out0 = (sel == 2'b00) ? in0 : in1;
   assign out1 = (sel == 2'b01) ? in0 : in1;
   assign out2 = (sel == 2'b10) ? in0 : in1;
   assign out3 = (sel == 2'b11) ? in0 : in1;

   assign out = (sel == 2'b00) ? out0 : (sel == 2'b01) ? out1 : (sel == 2'b10) ? out2 : out3;

endmodule