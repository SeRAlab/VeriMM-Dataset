module top_module(
    A,
    B,
    C,
    D,
    X
);// Module ports
    input A;
    input B;
    input C;
    input D;
    output X;

    // Local signals
    wire nor_out;
    wire and_out;

    //  Name  Output      Other arguments
    nor nor_gate (nor_out, A, B);
    and and_gate (and_out, C, D);
    assign X = nor_out & and_out;

endmodule