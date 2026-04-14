module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg lt,
    output reg eq,
    output reg gt
);

always @(*) begin
    lt = 0;
    eq = 0;
    gt = 0;

    if (A < B) begin
        lt = 1;
    end else if (A == B) begin
        eq = 1;
    end else begin
        gt = 1;
    end
end

endmodule