module top_module(
    input a,
    input b,
    input c,
    output y
);

    assign y = a & b & c;  // 3-input AND gate

endmodule