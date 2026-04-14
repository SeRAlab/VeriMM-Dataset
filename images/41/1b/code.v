module top_module(
    input in,
    output out
);// Implement NOT gate using NAND gates
    wire not_output;
    assign not_output = ~(in & in);

    // Implement AND gate using behavioral model
    assign out = not_output & 1'b1;

endmodule