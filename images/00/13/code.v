module decision_tree (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output reg Y
);

always @(*) begin
    if (A > 4'b0101) begin
        Y = 1;
    end else if (B > 4'b0011) begin
        Y = 1;
    end else if (C > 4'b0010) begin
        Y = 1;
    end else begin
        Y = 0;
    end
end

endmodule