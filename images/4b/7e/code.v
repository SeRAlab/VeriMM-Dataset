module top_module(Out_add, Out_sub, in1, in2);output signed[12-1:0] Out_add;
    output signed[12-1:0] Out_sub;
    input [11-1:0] in1;
    input [11-1:0] in2;

    assign Out_add = in1 + in2;
    assign Out_sub = in1 - in2;endmodule