module multiplier_64x64 (
    input [63:0] a,
    input [63:0] b,
    output reg [127:0] product,
    output reg valid
);
    always @(*) begin
        product = a * b;
        valid = 1'b1; // Output is valid whenever inputs are valid
    end
endmodule