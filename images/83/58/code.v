module top_module(
    input A,
    input B,
    input sel,
    output Z
);assign Z = sel ? B : A;

endmodule