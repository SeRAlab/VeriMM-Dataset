module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [7:0] temp_dividend;

    always @(posedge clk) begin
        if (start) begin
            if (divisor == 0) begin
                quotient <= 4'b0000;
                remainder <= dividend;
                done <= 1'b1;
            end else begin
                count <= 4'b0000;
                temp_dividend <= {4'b0000, dividend};
                quotient <= 4'b0000;
                remainder <= dividend;
                done <= 1'b0;
            end
        end else if (!done) begin
            if (temp_dividend >= {4'b0000, divisor}) begin
                temp_dividend <= temp_dividend - {4'b0000, divisor};
                quotient <= quotient + 1;
            end
            count <= count + 1;
            if (count == 4'b0011) begin // 4 cycles for 4 bits
                remainder <= temp_dividend[3:0];
                done <= 1'b1;
            end
        end
    end
endmodule