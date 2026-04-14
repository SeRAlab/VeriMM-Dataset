module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg EQ,
    output reg GT,
    output reg LT
);always @(*) begin
    // Check if A is greater than B
    if (A > B) begin
        GT = 1;
        LT = 0;
        EQ = 0;
    end
    // Check if A is less than B
    else if (A < B) begin
        GT = 0;
        LT = 1;
        EQ = 0;
    end
    // Check if A is equal to B
    else begin
        GT = 0;
        LT = 0;
        EQ = 1;
    end
end

endmodule