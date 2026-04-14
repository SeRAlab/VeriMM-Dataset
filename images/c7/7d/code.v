module add5_4bit (
    input [3:0] A,
    output [3:0] Y
);

    // Add 4 to the input
    wire [3:0] add4 = A + 4;

    // Add 1 to the result of adding 4
    assign Y = (add4[3]) ? add4[2:0] : add4[2:0] + 1;

endmodule