module restoring_divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] state;
    
    localparam IDLE = 4'b0000,
               SHIFT = 4'b0001,
               SUBTRACT = 4'b0010,
               DONE = 4'b0011;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 0;
                        state <= SHIFT;
                    end
                end
                SHIFT: begin
                    temp_quotient <= {temp_quotient[6:0], 1'b1};
                    temp_dividend <= {temp_dividend[6:0], 1'b0};
                    state <= SUBTRACT;
                end
                SUBTRACT: begin
                    if (temp_dividend >= divisor) begin
                        temp_dividend <= temp_dividend - divisor;
                        temp_quotient <= temp_quotient | 1'b1;
                    end
                    if (temp_quotient[7] == 1'b1) begin
                        state <= DONE;
                    end else begin
                        state <= SHIFT;
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