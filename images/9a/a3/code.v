module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    input I,
    input J,
    output reg X
);always @(*) begin
    if (A && B && C && D) begin
        X = 1;
    end else if (E && F && G && H) begin
        X = 1;
    end else if (I && J) begin
        X = 1;
    end else begin
        X = 0;
    end
end

endmodule