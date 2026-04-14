module decision_tree (
    input wire feature1,
    input wire feature2,
    output wire classification
);
    assign classification = (feature1 & feature2) | (~feature1);
endmodule