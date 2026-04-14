module top_module(
    // Module ports
    input  in0,
    input  in1,
    input  sel,
    output out
);// Select the input based on the value of sel
    assign out = sel ? in1 : in0;

endmodule