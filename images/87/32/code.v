module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    output reg X
);always @(*) begin
        if (A1 == 1) begin
            X <= A2;
        end else begin
            X <= A3 ^ A4;
        end
    end

    always @(*) begin
        if (B1 == 1) begin
            X <= ~X;
        end
    end

endmodule