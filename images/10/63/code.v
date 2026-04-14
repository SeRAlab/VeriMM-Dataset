module divider(
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;
    reg state;

    localparam IDLE = 1'b0, DIVIDE = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 1'b0;
            count <= 4'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 8'b0) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 8'b0;
                        count <= 8;
                        state <= DIVIDE;
                        done <= 1'b0;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        temp_quotient <= {temp_quotient[6:0], 1'b0}; // Shift left
                        temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor;
                            temp_quotient[0] <= 1'b1; // Set least significant bit
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule