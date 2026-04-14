module decision_tree (
    input wire A,
    input wire B,
    input wire C,
    output wire class
);

assign class = (A && ~B) || (~A && C);

endmodule