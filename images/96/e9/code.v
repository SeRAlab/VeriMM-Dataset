module top_module(subout,in1,in2);input [15:0] in1,in2;
    output reg [15:0] subout;
    always@(*)
      subout = in1 - in2;endmodule