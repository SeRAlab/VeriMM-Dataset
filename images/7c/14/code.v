module comparator_2bit (
    input [1:0] a,
    input [1:0] b,
    output reg greater,
    output reg equal,
    output reg less
);

    // Comparator logic
    always @(*) begin
        if (a > b) begin
            greater = 1'b1;
            equal = 1'b0;
            less = 1'b0;
        end
        else if (a == b) begin
            greater = 1'b0;
            equal = 1'b1;
            less = 1'b0;
        end
        else begin
            greater = 1'b0;
            equal = 1'b0;
            less = 1'b1;
        end
    end

endmodule