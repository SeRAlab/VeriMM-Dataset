module multiplier_16x16 (
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] product
);
    always @(*) begin
        product = a * b;
    end
endmodule