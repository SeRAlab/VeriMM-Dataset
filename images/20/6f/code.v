module comparator_64bit(
    input [63:0] a,
    input [63:0] b,
    output reg gt
);
    always @(*) begin
        if (a > b)
            gt = 1;
        else
            gt = 0;
    end
endmodule