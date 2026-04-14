module top_module(
    input in0,
    input in1,
    input in2,
    input in3,
    input [1:0] sel,
    output out
);assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 :
                                  in3;

endmodule