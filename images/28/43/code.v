module knn(
    input [7:0] feature1_1,
    input [7:0] feature1_2,
    input [7:0] feature1_3,
    input [7:0] feature1_4,
    input [7:0] feature1_5,
    input [7:0] feature2_1,
    input [7:0] feature2_2,
    input [7:0] feature2_3,
    input [7:0] feature2_4,
    input [7:0] feature2_5,
    output reg same_class
);

    wire [15:0] dist1, dist2, dist3, dist4, dist5;
    wire [15:0] total_dist;

    assign dist1 = (feature1_1 - feature2_1) * (feature1_1 - feature2_1);
    assign dist2 = (feature1_2 - feature2_2) * (feature1_2 - feature2_2);
    assign dist3 = (feature1_3 - feature2_3) * (feature1_3 - feature2_3);
    assign dist4 = (feature1_4 - feature2_4) * (feature1_4 - feature2_4);
    assign dist5 = (feature1_5 - feature2_5) * (feature1_5 - feature2_5);
    
    assign total_dist = dist1 + dist2 + dist3 + dist4 + dist5;

    always @(*) begin
        if (total_dist < 16'h0100) // arbitrary threshold for same class
            same_class = 1;
        else
            same_class = 0;
    end
endmodule