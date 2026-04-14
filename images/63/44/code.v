module top_module(
    output Y,
    input A,
    input B,
    input C,
    input D
);wire Y1;
    wire Y2;
    wire Y3;

    // Define a functionally equivalent AND gate using the native AND operation
    // Instead of referencing an unknown module `sky130_fd_sc_ls__and_2`
    assign Y1 = A & B; // Y1 = A AND B
    assign Y2 = C & D; // Y2 = C AND D
    assign Y3 = Y1 & Y2; // Y3 = Y1 AND Y2

    assign Y = Y3; // Final output

endmodule