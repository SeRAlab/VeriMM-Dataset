module fixed_point_multiplier (
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);
    wire [15:0] product;

    // Unsigned multiplication of 8-bit inputs
    assign product = a * b;

    // Check for overflow
    always @(*) begin
        if (product[15:8] != 8'b00000000) begin
            result = 16'hFFFF; // Saturate to maximum
        end else begin
            result = product;
        end
    end
endmodule