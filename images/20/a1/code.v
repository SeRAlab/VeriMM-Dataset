module comparator (
    input [1:0] a,
    input [1:0] b,
    output reg lt,
    output reg eq,
    output reg gt
);

always @(*) begin
    lt = 0;
    eq = 0;
    gt = 0;

    if (a < b) begin
        lt = 1;
    end else if (a == b) begin
        eq = 1;
    end else begin
        gt = 1;
    end
end

endmodule