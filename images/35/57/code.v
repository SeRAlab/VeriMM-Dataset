module fir_filter (
    input [3:0] x, // 4-bit input
    output reg [7:0] y // 8-bit output
);
    reg [3:0] coeff [0:3]; // Coefficients array
    integer i;

    initial begin
        // Initialize coefficients (example values)
        coeff[0] = 4'd1; // Coefficient for tap 0
        coeff[1] = 4'd2; // Coefficient for tap 1
        coeff[2] = 4'd3; // Coefficient for tap 2
        coeff[3] = 4'd4; // Coefficient for tap 3
    end

    always @(*) begin
        y = 8'd0; // Initialize output
        for (i = 0; i < 4; i = i + 1) begin
            y = y + (x * coeff[i]); // Multiply and accumulate
        end
    end
endmodule