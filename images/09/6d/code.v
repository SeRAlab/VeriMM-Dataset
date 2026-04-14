module decision_tree (
    input wire A,
    input wire B,
    output wire Y
);

assign Y = (A == 0 && B == 0) ? 0 :
           (A == 0 && B == 1) ? 1 :
           (A == 1 && B == 0) ? 1 :
           (A == 1 && B == 1) ? 0 : 0;

endmodule