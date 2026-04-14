module top_module(out, in0, in1, sel);output out;
    input in0, in1;
    input sel;

    assign out = sel ? in1 : in0;
endmodule