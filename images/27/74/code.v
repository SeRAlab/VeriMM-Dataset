module restoring_divider(
    input clk,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);

    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [3:0] neg_divisor;
    reg [3:0] count;
    reg state;

    initial begin
        quotient = 4'b0;
        remainder = 4'b0;
        done = 0;
        temp_quotient = 4'b0;
    end

    always @(posedge clk) begin
        if (start) begin
            temp_dividend = dividend;
            neg_divisor = ~divisor + 1; // Two's complement
            temp_quotient = 4'b0;
            count = 4'b1000; // Start with the most significant bit
            done = 0;
            state = 1; // Start state
        end else if (state) begin
            if (count > 0) begin
                // Shift left
                {temp_dividend, temp_quotient} = {temp_dividend, temp_quotient} << 1;
                temp_quotient[0] = 1'b1; // Add 1 to quotient
                temp_dividend = temp_dividend + neg_divisor; // Subtract divisor

                if (temp_dividend[3] == 1'b1) begin
                    temp_dividend = temp_dividend + divisor; // Restore
                    temp_quotient[0] = 1'b0; // Clear the last bit of quotient
                end

                count = count - 1;
            end else begin
                quotient = temp_quotient;
                remainder = temp_dividend;
                done = 1; // Division done
                state = 0; // Exit state
            end
        end
    end
endmodule