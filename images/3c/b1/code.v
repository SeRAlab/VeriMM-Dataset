module decision_tree (
    input [3:0] feature1,
    input [3:0] feature2,
    output reg [1:0] class
);
    always @(*) begin
        if (feature1 <= 4'b0101) begin
            if (feature2 <= 4'b0101)
                class = 2'b00; // Class 0
            else
                class = 2'b01; // Class 1
        end else begin
            if (feature2 <= 4'b0101)
                class = 2'b10; // Class 2
            else
                class = 2'b11; // Class 3
        end
    end
endmodule