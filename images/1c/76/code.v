module knn_classifier (
    input [3:0] pointA_x,
    input [3:0] pointA_y,
    input [1:0] labelA,
    input [3:0] pointB_x,
    input [3:0] pointB_y,
    input [1:0] labelB,
    input [3:0] pointC_x,
    input [3:0] pointC_y,
    input [1:0] labelC,
    input [3:0] test_x,
    input [3:0] test_y,
    input [1:0] K,
    output reg [1:0] class_label
);
    wire [7:0] distA, distB, distC;
    reg [1:0] count_label0, count_label1;

    // Euclidean distance calculation (squared distance for simplicity)
    assign distA = (pointA_x - test_x) * (pointA_x - test_x) + (pointA_y - test_y) * (pointA_y - test_y);
    assign distB = (pointB_x - test_x) * (pointB_x - test_x) + (pointB_y - test_y) * (pointB_y - test_y);
    assign distC = (pointC_x - test_x) * (pointC_x - test_x) + (pointC_y - test_y) * (pointC_y - test_y);

    always @* begin
        count_label0 = 0;
        count_label1 = 0;

        // Finding K nearest points
        if (K >= 1 && distA <= distB && distA <= distC) begin
            if (labelA == 0) count_label0 = count_label0 + 1;
            else count_label1 = count_label1 + 1;
        end
        if (K >= 1 && distB <= distA && distB <= distC) begin
            if (labelB == 0) count_label0 = count_label0 + 1;
            else count_label1 = count_label1 + 1;
        end
        if (K >= 1 && distC <= distA && distC <= distB) begin
            if (labelC == 0) count_label0 = count_label0 + 1;
            else count_label1 = count_label1 + 1;
        end

        // Determine the class label based on counts
        if (count_label0 > count_label1) class_label = 0;
        else class_label = 1;
    end
endmodule