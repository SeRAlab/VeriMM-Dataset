module comparator (
    input [1:0] a,
    input [1:0] b,
    output reg gt
);

    always @(*) begin
        gt = (a > b);
    end

endmodule