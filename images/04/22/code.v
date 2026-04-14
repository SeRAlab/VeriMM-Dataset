module divider (
    input clk,
    input reset,
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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            state <= 0;
            count <= 0;
        end else begin
            case (state)
                0: begin
                    temp_dividend <= dividend;
                    temp_quotient <= 0;
                    count <= 8;
                    state <= 1;
                end
                1: begin
                    if (count > 0) begin
                        temp_quotient <= {temp_quotient[6:0], 1'b0};
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor;
                            temp_quotient[0] <= 1;
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule