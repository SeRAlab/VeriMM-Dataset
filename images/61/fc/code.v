module binary_multiplier (
    input [3:0] m,
    input [3:0] n,
    output reg [7:0] product);always @(*) begin
        product = m * n;
    end

endmodule