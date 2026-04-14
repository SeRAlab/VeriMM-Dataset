module restoring_divider(
    input wire [4:0] dividend,
    input wire [2:0] divisor,
    input wire start,
    input wire clk,
    input wire rst,
    output reg [4:0] quotient,
    output reg [2:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [2:0] temp_divisor;
    reg [2:0] count;
    reg state; // 0: idle, 1: dividing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            count <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        quotient <= 0;
                        remainder <= 0;
                        count <= 5; // number of bits
                        state <= 1;
                        done <= 0;
                    end
                end
                1: begin // dividing state
                    {remainder, temp_dividend} <= {remainder, temp_dividend} - {2'b00, temp_divisor};
                    if (remainder[4]) begin // if remainder is negative
                        remainder <= remainder + {2'b00, temp_divisor};
                        quotient <= {quotient[3:0], 1'b0}; // shift left and add 0
                    end else begin
                        quotient <= {quotient[3:0], 1'b1}; // shift left and add 1
                    end
                    count <= count - 1;
                    if (count == 0) begin
                        state <= 0; // return to idle
                        done <= 1; // indicate done
                    end
                end
            endcase
        end
    end
endmodule