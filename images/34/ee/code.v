module SRT_Divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 4'b1111;  // maximum 4-bit value
            remainder = dividend; // remainder is the dividend
            valid = 1;
        end else if (start) begin
            // Simple SRT division logic
            quotient = dividend / divisor;
            remainder = dividend % divisor;
            valid = 1;
        end else begin
            valid = 0;
        end
    end
endmodule