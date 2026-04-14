module srt_divider(
    input clk,
    input rst_n,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [3:0] state;
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [7:0] temp_quotient;

    localparam IDLE = 4'd0,
               DIVIDE = 4'd1,
               DONE = 4'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            quotient <= 8'd0;
            remainder <= 8'd0;
            done <= 1'b0;
            temp_dividend <= 8'd0;
            temp_divisor <= 8'd0;
            temp_quotient <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        temp_quotient <= 8'd0;
                        state <= DIVIDE;
                        done <= 1'b0;
                    end
                end
                DIVIDE: begin
                    if (temp_dividend >= temp_divisor) begin
                        temp_dividend <= temp_dividend - temp_divisor;
                        temp_quotient <= temp_quotient + 1;
                    end else begin
                        remainder <= temp_dividend;
                        quotient <= temp_quotient;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end
endmodule