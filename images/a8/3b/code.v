module top_module(pgtn,in1,in2);input [15:0] in1 , in2;
    output pgtn;
    assign pgtn = (in1 < in2);endmodule