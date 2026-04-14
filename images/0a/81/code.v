module multiplier_64x64 (
    input [63:0] a,
    input [63:0] b,
    output reg [127:0] product
);
    
    always @(*) begin
        product = a * b; // Perform unsigned multiplication
    end

endmodule