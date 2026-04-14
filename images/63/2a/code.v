module top_module(
    out,
    in0,
    in1,
    in2,
    in3,
    in4,
    sel
);output out;
    input in0;
    input in1;
    input in2;
    input in3;
    input in4;
    input [2:0] sel;

    assign out = (sel == 3'b000) ? in0 :
                 (sel == 3'b001) ? in1 :
                 (sel == 3'b010) ? in2 :
                 (sel == 3'b011) ? in3 :
                 (sel == 3'b100) ? in4 :
                 1'b0;

endmodule