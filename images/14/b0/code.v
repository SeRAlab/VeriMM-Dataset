module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [15:0] A; // Augmented dividend
    reg [7:0] B; // Divisor
    reg [3:0] count; // Count of bits shifted

    always @(posedge start) begin
        A <= {8'b0, dividend}; // Initialize A with the dividend
        B <= divisor; // Initialize B with the divisor
        quotient <= 0; // Initialize quotient
        remainder <= 0; // Initialize remainder
        count <= 8; // Set count for 8 bits
        done <= 0; // Initial state done is false
    end

    always @(posedge start or posedge done) begin
        if (!done) begin
            if (count > 0) begin
                A <= A << 1; // Shift A left
                quotient <= {quotient[6:0], A[15]}; // Update quotient
                A[7:0] <= A[7:0] - B; // Subtract B from lower part of A

                if (A[7] == 1) begin
                    A[7:0] <= A[7:0] + B; // Restore A if negative
                    quotient[0] <= 0; // Set the current bit of quotient to 0
                end else begin
                    quotient[0] <= 1; // Set the current bit of quotient to 1
                end

                count <= count - 1; // Decrement the count
            end else begin
                remainder <= A[7:0]; // Set remainder
                done <= 1; // Set done to true
            end
        end
    end
endmodule