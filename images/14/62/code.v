module restoring_divider(
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;
    reg [4:0] temp;
    reg [2:0] count;
    reg state;

    localparam IDLE = 1'b0, DIVIDE = 1'b1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0;
            remainder <= 4'b0;
            temp_dividend <= 4'b0;
            temp_divisor <= 4'b0;
            temp <= 5'b0;
            count <= 3'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    temp_dividend <= dividend;
                    temp_divisor <= divisor;
                    quotient <= 4'b0;
                    count <= 3'b100; // 4 bits
                    state <= DIVIDE;
                    done <= 0;
                end
                DIVIDE: begin
                    temp <= {quotient, 1'b0}; // Shift left quotient
                    if (count > 0) begin
                        // Subtract
                        temp = temp_dividend - temp_divisor;
                        if (temp[4] == 1) begin
                            // Restore
                            temp_dividend = temp_dividend;
                            quotient = {quotient[2:0], 1'b0}; // Shift left quotient, add 0
                        end else begin
                            // Not restore
                            temp_dividend = temp[3:0];
                            quotient = {quotient[2:0], 1'b1}; // Shift left quotient, add 1
                        end
                        count = count - 1;
                    end else begin
                        remainder <= temp_dividend;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule