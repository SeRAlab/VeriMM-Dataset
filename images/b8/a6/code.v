module top_module(
    input     wire        A,
    input     wire        B,
    input     wire        VPWR,
    input     wire        VGND,
    output    reg         Y
);// Implement NOR2 gate logic
    assign Y = ~(A | B);

endmodule