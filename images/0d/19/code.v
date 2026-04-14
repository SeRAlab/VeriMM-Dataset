module divider (
    input [7:0] numerator,
    input [7:0] denominator,
    input start,
    input clk,
    input reset,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg ready
);
    reg [7:0] num, denom;
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder <= 0;
            ready <= 0;
            count <= 0;
            state <= 0;
        end else if (start && !state) begin
            num <= numerator;
            denom <= denominator;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            state <= 1;
        end else if (state) begin
            if (count < 8) begin
                remainder = {remainder[6:0], num[7]};
                num = {num[6:0], 1'b0};
                if (remainder >= denom) begin
                    remainder = remainder - denom;
                    quotient = quotient | (1'b1 << (7 - count));
                end
                count <= count + 1;
            end else begin
                ready <= 1;
                state <= 0;
            end
        end
    end
endmodule