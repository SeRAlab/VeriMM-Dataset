module restoring_divider (
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [2:0] state; // 0: idle, 1-4: compute, 5: done
    reg [3:0] subtract_result;

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
                3'b000: begin // idle state
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 4'b0000;
                        state <= 3'b001;
                        done <= 0;
                    end
                end
                3'b001: begin // first cycle
                    temp_quotient <= {temp_quotient[2:0], 1'b1}; // assume quotient bit is 1
                    subtract_result = temp_dividend - divisor;
                    if (subtract_result[3] == 0) begin // if no borrow
                        temp_dividend <= subtract_result;
                    end else begin
                        temp_quotient <= {temp_quotient[2:0], 1'b0}; // quotient bit is 0
                        temp_dividend <= temp_dividend; // no change to dividend
                    end
                    state <= 3'b010;
                end
                3'b010: begin // second cycle
                    temp_quotient <= {temp_quotient[2:0], 1'b1}; // assume quotient bit is 1
                    subtract_result = temp_dividend - divisor;
                    if (subtract_result[3] == 0) begin
                        temp_dividend <= subtract_result;
                    end else begin
                        temp_quotient <= {temp_quotient[2:0], 1'b0};
                    end
                    state <= 3'b011;
                end
                3'b011: begin // third cycle
                    temp_quotient <= {temp_quotient[2:0], 1'b1}; // assume quotient bit is 1
                    subtract_result = temp_dividend - divisor;
                    if (subtract_result[3] == 0) begin
                        temp_dividend <= subtract_result;
                    end else begin
                        temp_quotient <= {temp_quotient[2:0], 1'b0};
                    end
                    state <= 3'b100;
                end
                3'b100: begin // fourth cycle
                    temp_quotient <= {temp_quotient[2:0], 1'b1}; // assume quotient bit is 1
                    subtract_result = temp_dividend - divisor;
                    if (subtract_result[3] == 0) begin
                        temp_dividend <= subtract_result;
                    end else begin
                        temp_quotient <= {temp_quotient[2:0], 1'b0};
                    end
                    quotient <= temp_quotient;
                    remainder <= temp_dividend;
                    state <= 3'b101; // move to done state
                end
                3'b101: begin // done state
                    done <= 1;
                    state <= 3'b000; // reset to idle state
                end
            endcase
        end
    end
endmodule