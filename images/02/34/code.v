module NonRestoringDivider (
    input clk,
    input rst,
    input start,
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_numerator;
    reg [7:0] temp_quotient;
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            state <= 0;
            count <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        temp_numerator <= numerator;
                        temp_quotient <= 0;
                        count <= 8; // 8 bits for division
                        state <= 1;
                    end
                end
                1: begin // Division process
                    if (count > 0) begin
                        // Shift left
                        temp_quotient <= {temp_quotient[6:0], 1'b0};
                        temp_numerator <= {temp_numerator[6:0], 1'b0};

                        // Subtract denominator
                        if (temp_numerator >= denominator) begin
                            temp_numerator <= temp_numerator - denominator;
                            temp_quotient[0] <= 1;
                        end

                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_numerator;
                        done <= 1;
                        state <= 0; // Back to idle
                    end
                end
            endcase
        end
    end
endmodule