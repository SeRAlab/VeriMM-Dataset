module fixed_point_multiplier (
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] product
);
    always @(*) begin
        // Perform fixed-point multiplication and adjust the result
        product = (a * b) >> 4; // Shift right by 4 to maintain the fixed-point format
    end
endmodule