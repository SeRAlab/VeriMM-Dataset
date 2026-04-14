module non_restoring_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    reg [4:0] r; // Remainder and the bit to be shifted in
    reg [4:0] d; // Divisor
    
    integer i;

    always @(*) begin
        r = {1'b0, dividend}; // Initialize remainder
        d = {1'b0, divisor}; // Initialize divisor
        quotient = 4'b0; // Initialize quotient

        for (i = 0; i < 4; i = i + 1) begin
            r = r << 1; // Shift left
            r[0] = dividend[3 - i]; // Bring in next bit of dividend
            r = r - d; // Subtract divisor
            if (r[4] == 1) begin
                r = r + d; // If negative, restore
                quotient[i] = 0; // Set quotient bit to 0
            end else begin
                quotient[i] = 1; // Set quotient bit to 1
            end
        end
        remainder = r[3:0]; // Final remainder
    end
endmodule