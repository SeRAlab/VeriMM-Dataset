module decision_tree_inference (
    input [3:0] feature1,
    input [3:0] feature2,
    input [3:0] feature3,
    output reg [1:0] decision
);
    always @(*) begin
        if (feature1 >= 4'b1000) begin
            decision = 2'b11;
        end else if (feature2 >= 4'b1000) begin
            decision = 2'b10;
        end else if (feature3 >= 4'b1000) begin
            decision = 2'b01;
        end else begin
            decision = 2'b00;
        end
    end
endmodule