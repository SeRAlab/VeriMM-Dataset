module three_input_nor (
    input a,
    input b,
    input c,
    output y
);
    assign y = ~(a | b | c);
endmodule