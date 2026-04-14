module restoring_divider (
    input clk,
    input rst,
    input [4:0] dividend,
    input [4:0] divisor,
    output reg [4:0] quotient,
    output reg [4:0] remainder
);
    reg [4:0] current;
    reg [4:0] count;
    reg [3:0] state; // 0: idle, 1: start, 2: subtract, 3: check, 4: done

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 5'b0;
            remainder <= 5'b0;
            current <= 5'b0;
            count <= 5'b0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (divisor != 0) begin
                        current <= dividend;
                        count <= 5'b0;
                        quotient <= 5'b0;
                        state <= 1; // start
                    end
                end
                1: begin
                    current <= current - divisor;
                    quotient <= (quotient << 1) | 1; // assume division by 1
                    state <= 2; // subtract
                end
                2: begin
                    if (current < 0) begin
                        current <= current + divisor;
                        quotient <= quotient << 1; // clear the last bit
                    end
                    count <= count + 1;
                    if (count == 5) begin
                        remainder <= current;
                        state <= 4; // done
                    end else begin
                        state <= 1; // continue dividing
                    end
                end
                4: begin
                    // Division complete, stay in done state
                end
            endcase
        end
    end
endmodule