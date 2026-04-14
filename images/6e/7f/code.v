module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] result
);always @(*) begin
        if (B >= 0) begin
            result = A << B;
        end else begin
            // Corrected: Use a max function for shifting right, assuming B is unsigned
            result = A >> (-B);  // Change abs(B) to -B for right shift
        end
    end

endmodule