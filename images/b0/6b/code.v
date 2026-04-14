module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    output reg X
);always @(*) begin
        if (A1 && A2) begin
            X <= 1;
        end else if (!A1 && B1) begin
            X <= 0;
        end else if (!A1 && !B1 && C1) begin
            X <= 1;
        end else begin
            X <= 0;
        end
    end

endmodule