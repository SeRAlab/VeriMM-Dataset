module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);// Local signals
    wire and0_out;
    wire and1_out;

    //  Name  Output      Other arguments
    and and0 (and0_out, A, B     );
    and and1 (and1_out, C, D     );
    and and2 (Y       , and0_out, and1_out );

endmodule