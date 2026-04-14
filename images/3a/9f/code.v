module divider_4bit (
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [2:0] state; // 0: idle, 1: subtract, 2: shift, 3: done
    reg [3:0] current_divisor;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            temp_dividend <= 4'b0000;
            temp_quotient <= 4'b0000;
            state <= 3'b000;
            done <= 0;
        end else begin
            case (state)
                3'b000: begin // idle
                    temp_dividend <= dividend;
                    current_divisor <= divisor;
                    temp_quotient <= 4'b0000;
                    state <= 3'b001; // move to subtract state
                end
                3'b001: begin // subtract
                    if (temp_dividend >= current_divisor) begin
                        temp_dividend <= temp_dividend - current_divisor;
                        temp_quotient <= temp_quotient + 1;
                    end
                    state <= 3'b010; // move to shift state
                end
                3'b010: begin // shift
                    if (temp_quotient < 4'b1111) begin
                        temp_quotient <= temp_quotient << 1;
                        temp_dividend <= temp_dividend << 1;
                        state <= 3'b001; // return to subtract
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1;
                        state <= 3'b011; // move to done state
                    end
                end
                3'b011: begin // done
                    done <= 1; // output is stable
                end
            endcase
        end
    end
endmodule