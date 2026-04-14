module top_module(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] sum
);reg [15:0] a_mag;
    reg [15:0] b_mag;
    reg a_sign;
    reg b_sign;

    // Determine the sign and magnitude of A
    assign a_sign = A[15];
    assign a_mag = (a_sign) ? ~A + 1 : A;

    // Determine the sign and magnitude of B
    assign b_sign = B[15];
    assign b_mag = (b_sign) ? ~B + 1 : B;

    // Add the magnitudes of A and B
    always @(*) begin
        if (a_sign == b_sign) begin
            sum = (a_sign) ? ~(a_mag + b_mag) + 1 : a_mag + b_mag;
        end else begin
            if (a_mag > b_mag) begin
                sum = (a_sign) ? a_mag - b_mag : a_mag + b_mag;
            end else begin
                sum = (b_sign) ? b_mag - a_mag : a_mag - b_mag;
            end
        end
    end

    // Set the sign bit of the sum
    always @(*) begin
        if (sum == 0) begin
            sum[15] = 0;
        end else if (a_sign == b_sign) begin
            sum[15] = a_sign;
        end else if (a_mag > b_mag) begin
            sum[15] = a_sign;
        end else begin
            sum[15] = b_sign;
        end
    end

endmodule