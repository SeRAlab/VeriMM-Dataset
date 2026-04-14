module divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);

    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'd0;
            remainder <= 8'd0;
            count <= 4'd0;
        end else begin
            if (count == 0) begin
                temp_dividend <= dividend;
                temp_divisor <= divisor;
                quotient <= 8'd0;
                remainder <= 8'd0;
                if (divisor == 8'd0) begin
                    quotient <= 8'd0;
                    remainder <= 8'd0;
                end else begin
                    count <= 4'd8; // 8 iterations for 8 bits
                end
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
            end
        end
    end
endmodule