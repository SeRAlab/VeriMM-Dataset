module comparator_2bit (
    input [1:0] a,
    input [1:0] b,
    output reg gt
);

    // Comparator logic
    always @(*) begin
        gt = (a > b) ? 1'b1 : 1'b0;
    end

endmodule