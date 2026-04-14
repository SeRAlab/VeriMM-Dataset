module multiplier_4bit (
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] product
);
    always @(*) begin
        product = a * b;
    end
endmodule