module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input D1,
    output reg X
);always @(*) begin
    if (A1 == 1) begin
        X = 1;
    end else if (A1 == 0 && A2 == 1) begin
        X = B1;
    end else if (A1 == 0 && A2 == 0 && B1 == 0 && B2 == 1) begin
        X = B2;
    end else if (A1 == 0 && A2 == 0 && B1 == 0 && B2 == 0 && C1 == 1) begin
        X = C1;
    end else if (A1 == 0 && A2 == 0 && B1 == 0 && B2 == 0 && C1 == 0 && D1 == 1) begin
        X = D1;
    end else begin
        X = 0;
    end
end

endmodule