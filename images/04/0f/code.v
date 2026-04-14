module multiplier (
    input [31:0] a,
    input [31:0] b,
    output reg [63:0] product
);
    always @(*) begin
        product = a * b;
    end
endmodule