module top_module(
    input [1:0] sel,
    input in0,
    input in1,
    input in2,
    output out
);assign out = (sel == 2) ? in2 :
                 (sel == 1) ? in1 :
                 (sel == 0) ? in0 :
                 0;

endmodule