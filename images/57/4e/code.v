module top_module(
    Y,
    A1,
    A2,
    B1,
    C1
);output Y;
    input A1;
    input A2;
    input B1;
    input C1;

    wire and_out;
    wire xor_out;
    wire inv_out;

    assign and_out = A1 & A2;
    assign xor_out = B1 ^ C1;
    assign inv_out = ~B1;

    // Replace sky130_fd_sc_ls__a211oi_1 with a behavioral implementation for logic gates
    assign Y = (1'b1 & xor_out) | (1'b0 & inv_out);

endmodule