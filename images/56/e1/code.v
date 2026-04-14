module top_module(out, in0, in1, sel);output [3:0] out;
    input [3:0] in0, in1;
    input [1:0] sel;

    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in0 :
                                  in1;
endmodule