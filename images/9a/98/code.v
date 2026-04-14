module top_module (
    input sel,
    input a,
    input b,
    output y
);
    assign y = sel ? b : a;
endmodule