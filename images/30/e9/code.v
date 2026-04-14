module decision_tree (
    input wire x1,
    input wire x2,
    input wire x3,
    output wire y
);
    assign y = (x1) ? 1 : (x2 ? x3 : 0);
endmodule