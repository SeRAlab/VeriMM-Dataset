module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    input wire E,
    output wire Y
);
    assign Y = (A & ~B) | (~A & C) | D | (~A & B & ~E);
endmodule