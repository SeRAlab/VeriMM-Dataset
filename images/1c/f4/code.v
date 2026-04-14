module non_restoring_divider (
    input clk,
    input reset,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            temp_dividend <= 8'b0;
            temp_quotient <= 8'b0;
            count <= 4'b0;
            done <= 0;
            state <= 0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_quotient <= 8'b0;
            count <= 8; // Assuming 8-bit division
            done <= 0;
            state <= 1;
        end else if (state) begin
            if (count > 0) begin
                temp_quotient <= {temp_quotient[6:0], 1'b0};
                temp_dividend <= {temp_dividend[6:0], 1'b0};
                
                // Subtract the divisor
                if (temp_dividend >= divisor) begin
                    temp_dividend <= temp_dividend - divisor;
                    temp_quotient[0] <= 1'b1; // Set the LSB of quotient
                end else begin
                    temp_quotient[0] <= 1'b0; // LSB remains 0
                end
                count <= count - 1;
            end else begin
                quotient <= temp_quotient;
                remainder <= temp_dividend;
                done <= 1;
                state <= 0;
            end
        end
    end
endmodule