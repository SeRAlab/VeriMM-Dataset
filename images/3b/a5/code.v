module divider (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [3:0] state;
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;

    parameter IDLE = 4'b0000,
              DIVIDE = 4'b0001,
              DONE = 4'b0010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 8'b0;
                        remainder <= 8'b0;
                        count <= 4'b0;
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (count < 8) begin
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor;
                            temp_quotient <= temp_quotient + 1;
                        end
                        count <= count + 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1'b1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule