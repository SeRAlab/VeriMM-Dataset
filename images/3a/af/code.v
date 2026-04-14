module decision_tree (
    input  [2:0] X,
    output reg [1:0] Y
);
    always @* begin
        case ({X[2], X[1]})
            2'b00: Y = 2'b00; // case: X[2] == 0, X[1] == 0
            2'b01: Y = 2'b01; // case: X[2] == 0, X[1] == 1
            2'b10: Y = 2'b10; // case: X[2] == 1, X[1] == 0
            2'b11: Y = 2'b11; // case: X[2] == 1, X[1] == 1
            default: Y = 2'b00; // default case
        endcase
    end
endmodule