module decision_tree_inference (
    input [3:0] input1,
    input [3:0] input2,
    output reg class_output
);

always @(*) begin
    if (input1 > 4) begin
        class_output = 1'b1; // Class A
    end else if (input2 > 3) begin
        class_output = 1'b1; // Class A
    end else begin
        class_output = 1'b0; // Class B
    end
end

endmodule