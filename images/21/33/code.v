module divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [2:0] state;
    reg [2:0] count;

    localparam IDLE = 3'b000, LOAD = 3'b001, DIVIDE = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 4'b0;
            remainder <= 4'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 0) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 4'b0;
                        count <= 4;
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    if (count > 0) begin
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor;
                            temp_quotient <= temp_quotient + 1;
                        end
                        count <= count - 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    quotient <= temp_quotient;
                    remainder <= temp_dividend;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule