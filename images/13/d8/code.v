module SRT_Divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        // Initialize outputs
        quotient = 0;
        remainder = 0;

        if (divisor != 0) begin
            // Simple implementation of SRT division
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule