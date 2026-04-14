module qr_decomposition (
    input [15:0] a11, a12,
    input [15:0] a21, a22,
    output reg [15:0] q1x, q1y,
    output reg [15:0] q2x, q2y
);
    reg [31:0] norm_q1;
    reg [31:0] dot_product;
    reg [31:0] q1_length_squared;
    reg [31:0] q2_length_squared;

    always @(*) begin
        // Calculate the norm of the first vector
        norm_q1 = a11 * a11 + a12 * a12;
        if (norm_q1 != 0) begin
            // Normalize q1
            q1x = a11 * 16'h10000 / norm_q1;  // Scale factor
            q1y = a12 * 16'h10000 / norm_q1;  // Scale factor
        end else begin
            // If the first vector is zero, output zero
            q1x = 0;
            q1y = 0;
        end
        
        // Calculate q2 using the Gram-Schmidt process
        dot_product = q1x * a21 + q1y * a22;
        q2x = a21 - (dot_product * q1x / norm_q1);
        q2y = a22 - (dot_product * q1y / norm_q1);
        
        // Normalize q2
        q2_length_squared = q2x * q2x + q2y * q2y;
        if (q2_length_squared != 0) begin
            q2x = q2x * 16'h10000 / q2_length_squared;  // Scale factor
            q2y = q2y * 16'h10000 / q2_length_squared;  // Scale factor
        end
    end
endmodule