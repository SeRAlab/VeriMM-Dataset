module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  C1,
    output reg X
);always @(A1, A2, B1, C1) begin
        if (A1 && !A2) begin
            X <= 1'b1;
        end else if (!A1 && A2) begin
            X <= 1'b0;
        end else if (!A1 && !A2) begin
            if (B1 && !C1) begin
                X <= 1'b1;
            end else if (!B1 || C1) begin
                X <= 1'b0;
            end
        end else if (A1 && A2) begin
            if (B1 || !C1) begin
                X <= 1'b1;
            end else if (!B1 && C1) begin
                X <= 1'b0;
            end
        end
    end

endmodule