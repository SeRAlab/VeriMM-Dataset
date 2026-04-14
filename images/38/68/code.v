module vector_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output OVF
);
    assign {OVF, SUM} = A + B; // Concatenating OVF with SUM
endmodule