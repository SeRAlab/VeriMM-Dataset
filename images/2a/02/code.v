module decision_tree (
    input [3:0] feature1,
    input [3:0] feature2,
    input [3:0] feature3,
    output reg [1:0] classification
);
    always @(*) begin
        if (feature1 < 4'd5) begin
            classification = 2'b00; // Output 0
        end else if (feature2 < 4'd10) begin
            classification = 2'b01; // Output 1
        end else if (feature3 < 4'd15) begin
            classification = 2'b10; // Output 2
        end else begin
            classification = 2'b11; // Output 3
        end
    end
endmodule