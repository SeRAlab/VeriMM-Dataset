module decision_tree (
    input [3:0] x1,
    input [3:0] x2,
    output reg class
);
    always @(*) begin
        if (x1 < 4'd5 && x2 < 4'd5)
            class = 1'b0;
        else if (x1 < 4'd5 && x2 >= 4'd5)
            class = 1'b1;
        else if (x1 >= 4'd5 && x2 < 4'd5)
            class = 1'b1;
        else
            class = 1'b0;
    end
endmodule