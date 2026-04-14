module top_module(
    Y,
    A
);// Module ports
    output Y;
    input  A;

    // Local signals
    wire not0_out_Y;

    //  Name  Output      Other arguments
    not not0 (not0_out_Y, A              );
    assign Y = not0_out_Y;

endmodule