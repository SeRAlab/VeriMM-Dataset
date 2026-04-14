module three_input_nor(
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    assign Y = ~(A | B | C);
endmodule