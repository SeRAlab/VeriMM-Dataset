module divider (
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;
    reg [3:0] temp_quotient;
    reg [3:0] temp_remainder;
    reg [2:0] state;

    localparam IDLE = 3'b000,
               DIVIDE = 3'b001,
               DONE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            valid <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 0) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        temp_quotient <= 4'b0000;
                        temp_remainder <= dividend;
                        state <= DIVIDE;
                        valid <= 1'b0;
                    end else begin
                        quotient <= 4'b0000;
                        remainder <= 4'b0000;
                        valid <= 1'b1;
                    end
                end
                
                DIVIDE: begin
                    if (temp_remainder >= temp_divisor) begin
                        temp_remainder <= temp_remainder - temp_divisor;
                        temp_quotient <= temp_quotient + 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_remainder;
                        valid <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule