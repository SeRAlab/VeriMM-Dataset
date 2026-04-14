module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg Y
);always @(*) begin
    if (A && !C && B && !D) begin
        Y = 1;
    end else begin
        Y = 0;
    end
end

endmodule