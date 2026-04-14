module restoring_divider(
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);

    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [2:0] count;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0;
            remainder <= 4'b0;
            temp_dividend <= 4'b0;
            temp_quotient <= 4'b0;
            count <= 3'b0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Initialize
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 4'b0;
                        count <= 4; // 4 bits to process
                        state <= 1;
                    end
                end
                1: begin // Divide process
                    if (count > 0) begin
                        temp_quotient <= {temp_quotient[2:0], 1'b1}; // Shift left
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor; // Subtract
                        end else begin
                            temp_quotient <= {temp_quotient[2:0], 1'b0}; // Shift left
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        valid <= 1;
                        state <= 2; // Move to finished state
                    end
                end
                2: begin // Finished state
                    valid <= 0; // Reset valid after reading
                    state <= 0; // Go back to initialize
                end
            endcase
        end
    end
endmodule