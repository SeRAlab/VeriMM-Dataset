module binary_multiplier (
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] prod);always @(*) begin
        prod = a * b;
    end

endmodule