module divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;
    
    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 4'b0;
            remainder <= 4'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (count < 4) begin
            remainder <= {remainder[2:0], temp_dividend[3]};
            temp_dividend <= {temp_dividend[2:0], 1'b0};
            if (remainder >= temp_divisor) begin
                remainder <= remainder - temp_divisor;
                quotient <= {quotient[2:0], 1'b1};
            end else begin
                quotient <= {quotient[2:0], 1'b0};
            end
            count <= count + 1;
        end else begin
            done <= 1'b1;
        end
    end
endmodule