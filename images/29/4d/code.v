module decision_tree (
    input feature1,
    input feature2,
    output class
);
    assign class = (feature1 == 0 && feature2 == 0) ? 0 :
                   (feature1 == 0 && feature2 == 1) ? 1 :
                   (feature1 == 1 && feature2 == 0) ? 1 :
                   0; // feature1 == 1 && feature2 == 1
endmodule