module top_module(input in0, input in1, output out0, output out1, output out2);assign out0 = in0 ^ in1;
   assign out1 = in0 | in1;
   assign out2 = in0 & in1;
endmodule