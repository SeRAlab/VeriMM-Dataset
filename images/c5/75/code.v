module logic_circuit(
    input a,
    input b,
    input c,
    output x,
    output y,
    output z
    );

    assign x = a;
    assign y = (a == 1'b0 && b == 1'b1);
    assign z = (a == 1'b0 && b == 1'b0 && c == 1'b1);

endmodule