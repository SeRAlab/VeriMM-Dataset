module simple_adder(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] Sum,
    output wire Carry_out
);

    assign {Carry_out, Sum} = A + B;

endmodule