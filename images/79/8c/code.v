module binary_comparator(
    input wire [3:0] a,
    input wire [3:0] b,
    output reg lt,
    output reg eq,
    output reg gt
);

always @(*) begin
    if (a < b) begin
        lt = 1;
        eq = 0;
        gt = 0;
    end else if (a == b) begin
        lt = 0;
        eq = 1;
        gt = 0;
    end else begin
        lt = 0;
        eq = 0;
        gt = 1;
    end
end

endmodule