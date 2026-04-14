module decision_tree(
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
assign Y = (A == 1) || (A == 0 && B == 1) || (A == 0 && B == 0 && C == 0);
endmodule