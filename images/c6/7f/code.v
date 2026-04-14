module combinational_circuit(
    input [3:0] A,
    input [1:0] B,
    input C,
    input D,
    input E,
    output X
);

    assign X = ((A <= 5) && (B == 2)) ? 1 :
               ((C == 1) && (D == 0) && (E == 1)) ? 1 : 0;

endmodule