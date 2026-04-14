module non_restoring_divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [8:0] temp_remainder; // To hold the remainder with one extra bit for subtraction
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            temp_dividend <= 0;
            temp_remainder <= 0;
            count <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (count == 0) begin
                        temp_dividend <= dividend;
                        temp_remainder <= 0;
                        quotient <= 0;
                    end
                    state <= 1;
                end
                1: begin
                    if (count < 8) begin
                        temp_remainder = {temp_remainder[6:0], temp_dividend[7]};
                        temp_dividend = {temp_dividend[6:0], 1'b0};
                        if (temp_remainder >= divisor) begin
                            temp_remainder = temp_remainder - divisor;
                            quotient[count] = 1;
                        end else begin
                            quotient[count] = 0;
                        end
                        count <= count + 1;
                    end else begin
                        remainder <= temp_remainder[7:0];
                        done <= 1;
                        state <= 2;
                    end
                end
                2: begin
                    // Wait for next clock or reset
                end
            endcase
        end
    end
endmodule