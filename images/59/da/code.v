module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg EQ,   // Changed from wire to reg
    output reg GT,   // Changed from wire to reg
    output reg LT    // Changed from wire to reg
);always @(*) begin
        if (A == B) begin
            EQ = 1'b1;
            GT = 1'b0;
            LT = 1'b0;
        end else if (A > B) begin
            EQ = 1'b0;
            GT = 1'b1;
            LT = 1'b0;
        end else begin
            EQ = 1'b0;
            GT = 1'b0;
            LT = 1'b1;
        end
    end

endmodule