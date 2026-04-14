module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
assign Y = (A & ~B) | (~A & B) | (~A & C);
endmodule