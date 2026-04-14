module decision_tree (
    input wire x0,
    input wire x1,
    input wire x2,
    output wire y
);

assign y = (x0 == 0) ? x1 : ((x1 == 0) ? 0 : x2);

endmodule