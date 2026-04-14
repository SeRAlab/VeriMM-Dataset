module top_module(
    input in0,
    input in1,
    input sel,
    output out
);

    // Assign the output based on the select signal
    assign out = sel ? in1 : in0;

endmodule