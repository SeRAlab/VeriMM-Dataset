module top_module(
    input [3:0] A, B, C, D,
    output reg EQ, GT
);always @(*) begin
        if (A == B && C == D) begin
            EQ = 1'b1;
            GT = 1'b0;
        end else if (A > B || (A == B && C > D)) begin
            EQ = 1'b0;
            GT = 1'b1;
        end else begin
            EQ = 1'b0;
            GT = 1'b0;
        end
    end

endmodule