module top_module(
    input input1,
    input input2,
    input input3,
    input input4,
    input enable,
    output output1
);wire X;

    // This is a placeholder for the functionality of sky130_fd_sc_hd__o22a_1.
    // You should include the correct module or import the library/package that defines it.
    // Here, I will replace it with a simple implementation of the O22 function.
    // You need to adjust this according to your design needs or include the correct module definition.

    assign X = (input1 & input2) | (input3 & input4);

    assign output1 = enable ? X : 1'b0;

endmodule