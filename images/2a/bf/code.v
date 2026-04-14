module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    assign Y = (A && !B) || (!A && B && !C) || (!A && !B) ? 0 : 1;
endmodule