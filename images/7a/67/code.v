module top_module(
     input  [7:0] in0,
     input  [7:0] in1,
     output wire [7:0] out0,
     output wire [7:0] out1
);assign out0 = (in0<in1) ? in0:in1;
     assign out1 = (in0<in1) ? in1:in0;endmodule