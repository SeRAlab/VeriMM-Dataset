module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg remainder,
    input start,
    input clk,
    input reset
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;
    reg [8:0] result; // to hold remainder

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 1'b0;
            count <= 4'b0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            result <= {1'b0, temp_dividend}; // initialize result
            count <= 8; // 8 bits to process
            quotient <= 8'b0;
            remainder <= 1'b0;
        end else if (count > 0) begin
            result <= result << 1; // shift left
            result[0] <= temp_dividend[7]; // bring in next bit of dividend
            temp_dividend <= temp_dividend << 1; // shift dividend
            
            if (result[8:1] >= temp_divisor) begin
                result[8:1] <= result[8:1] - temp_divisor; // subtract divisor
                quotient <= {quotient[6:0], 1'b1}; // set quotient bit
            end else begin
                quotient <= {quotient[6:0], 1'b0}; // clear quotient bit
            end
            
            count <= count - 1; // decrement count
        end else begin
            remainder <= result[8:1]; // final remainder
        end
    end
endmodule