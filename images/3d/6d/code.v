module multiplier_32x32 (
    input [31:0] a,
    input [31:0] b,
    input valid,
    output reg [63:0] result,
    output reg ready
);
    always @(*) begin
        if (valid) begin
            result = a * b;
            ready = 1; // Output is valid
        end else begin
            result = 64'b0; // Clear output if not valid
            ready = 0; // Output is not valid
        end
    end
endmodule