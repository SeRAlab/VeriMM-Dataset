module decision_tree (
    input [2:0] X,
    output reg Y
);
    always @(*) begin
        if (X[2] == 1) begin
            Y = 1; // class 1
        end else if (X[1] == 1) begin
            Y = 0; // class 0
        end else if (X[0] == 1) begin
            Y = 1; // class 1
        end else begin
            Y = 0; // class 0
        end
    end
endmodule