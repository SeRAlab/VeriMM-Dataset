module non_restoring_divider(
    input clk,
    input reset,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp_dividend <= 0;
            temp_quotient <= 0;
            count <= 0;
            done <= 0;
        end else if (count < 8) begin
            if (count == 0) begin
                temp_dividend <= dividend;
                temp_quotient <= 0;
                done <= 0;
            end else begin
                temp_dividend = {temp_dividend[6:0], 1'b0}; // Shift left
                temp_quotient = {temp_quotient[6:0], 1'b0}; // Shift left

                if (temp_dividend >= divisor) begin
                    temp_dividend = temp_dividend - divisor; // Subtract divisor
                    temp_quotient[0] = 1; // Set least significant bit of quotient
                end
            end
            count <= count + 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule