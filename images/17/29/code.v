module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);

assign Y = (A == 1) ? (B == 1) : (C == 1);

endmodule