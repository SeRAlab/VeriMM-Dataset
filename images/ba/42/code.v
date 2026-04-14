module comparator (
    input [3:0] a,
    input [3:0] b,
    output reg gt
);

    // Comparator logic
    always @(*) begin
        if (a > b)
            gt = 1'b1;
        else
            gt = 1'b0;
    end

endmodule