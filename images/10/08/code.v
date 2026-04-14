module divider (
    input clk,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input start,
    output reg ready
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 8'b0;
            remainder <= 8'b0;
            count <= 8; // Set count for 8 bits
            ready <= 0;
        end else if (count > 0) begin
            remainder <= {remainder[6:0], temp_dividend[7]};
            temp_dividend <= {temp_dividend[6:0], 1'b0};
            if (remainder >= temp_divisor) begin
                remainder <= remainder - temp_divisor;
                quotient <= {quotient[6:0], 1'b1};
            end else begin
                quotient <= {quotient[6:0], 1'b0};
            end
            count <= count - 1;
        end else begin
            ready <= 1; // Indicate ready for output
        end
    end
endmodule