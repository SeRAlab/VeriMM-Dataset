module fixed_point_multiplier (
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] product
);
    always @* begin
        product = (a * b) >> 4; // Shift right by 4 to account for the fixed-point representation
    end
endmodule