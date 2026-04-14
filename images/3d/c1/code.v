module three_input_and (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    assign Y = A & B & C;
endmodule