module butterworth_filter (
    input [4:0] x, // 5-bit input
    output reg [4:0] y // 5-bit output
);
    // Butterworth filter coefficients for a 5th-order filter (example coefficients)
    parameter [4:0] b0 = 5'b00001;
    parameter [4:0] b1 = 5'b00010;
    parameter [4:0] b2 = 5'b00011;
    parameter [4:0] b3 = 5'b00100;
    parameter [4:0] b4 = 5'b00101;

    always @(*) begin
        // Apply the Butterworth filter formula
        y = (b0 * x + b1 * (x >> 1) + b2 * (x >> 2) + b3 * (x >> 3) + b4 * (x >> 4)) >> 4;
    end
endmodule