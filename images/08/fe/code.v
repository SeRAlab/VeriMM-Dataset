module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    input reset,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            state <= 0;
            count <= 0;
        end else begin
            case (state)
                0: begin
                    if (start) begin
                        if (divisor != 0) begin
                            temp_dividend <= dividend;
                            temp_divisor <= divisor;
                            quotient <= 0;
                            remainder <= 0;
                            count <= 8;
                            state <= 1;
                        end else begin
                            quotient <= 0;
                            remainder <= 0;
                            done <= 1;
                        end
                    end
                end
                1: begin
                    if (count > 0) begin
                        remainder <= (remainder << 1) | (temp_dividend[7]);
                        temp_dividend <= temp_dividend << 1;
                        if (remainder >= temp_divisor) begin
                            remainder <= remainder - temp_divisor;
                            quotient <= (quotient << 1) | 1;
                        end else begin
                            quotient <= (quotient << 1);
                        end
                        count <= count - 1;
                    end else begin
                        done <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule