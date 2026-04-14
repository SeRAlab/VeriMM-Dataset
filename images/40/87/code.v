module decision_tree (
    input [3:0] feature1,
    input [3:0] feature2,
    input [3:0] feature3,
    output reg decision
);
    
    always @(*) begin
        if (feature1 < 4'd5) begin
            decision = 1'b0;
        end else if (feature2 < 4'd10) begin
            decision = 1'b1;
        end else if (feature3 < 4'd15) begin
            decision = 1'b1;
        end else begin
            decision = 1'b0;
        end
    end
endmodule