module decision_tree (
    input A,
    input B,
    input C,
    output Y
);
    assign Y = (A && !B) || (!A && C);
endmodule