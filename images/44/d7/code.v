module top_module(
    input signed [31:0] A,
    input signed [31:0] B,
    output reg EQ,  // Change to 'reg' to avoid declaration conflict
    output reg GT,  // Change to 'reg' to avoid declaration conflict
    output reg LT   // Change to 'reg' to avoid declaration conflict
);always @(*) begin
    if (A == B) begin
        EQ = 1;
        GT = 0;
        LT = 0;
    end else if (A > B) begin
        EQ = 0;
        GT = 1;
        LT = 0;
    end else begin
        EQ = 0;
        GT = 0;
        LT = 1;
    end
end

endmodule