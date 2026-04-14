module top_module(
    input A,
    input B,
    input EN,
    output reg Y
);always @ (A, B, EN) begin
    if (EN == 1'b0) begin
        Y = A;
    end else begin
        Y = B;
    end
end

endmodule