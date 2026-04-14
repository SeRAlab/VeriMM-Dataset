module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    output [15:0] SUM,
    output CARRY_OUT
);
    assign {CARRY_OUT, SUM} = A + B;
endmodule