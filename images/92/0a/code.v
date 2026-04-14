module top_module(Out_add, Out_sub, in1, in2, c1, c2);output signed[21-1:0] Out_add;
    output signed[21-1:0] Out_sub;
    input signed[7-1:0] c1, c2;
    input signed[13-1:0] in1;
    input signed[13-1:0] in2;

    assign Out_add = in1 * c1 + in2 * c2;
    assign Out_sub = in1 * c2 - in2 * c1;endmodule