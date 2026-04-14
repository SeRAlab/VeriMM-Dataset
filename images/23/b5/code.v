module divider (
    input wire clk,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input wire start,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            quotient <= 0;
            remainder <= 0;
            count <= 8;
            done <= 0;
        end
        else if (count > 0) begin
            remainder <= {remainder[6:0], temp_dividend[7]};
            temp_dividend <= {temp_dividend[6:0], 1'b0};
            if (remainder >= divisor) begin
                remainder <= remainder - divisor;
                quotient <= {quotient[6:0], 1'b1};
            end else begin
                quotient <= {quotient[6:0], 1'b0};
            end
            count <= count - 1;
        end
        else begin
            done <= 1;
        end
    end
endmodule